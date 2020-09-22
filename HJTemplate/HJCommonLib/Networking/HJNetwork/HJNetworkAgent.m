//
//  HJNetworkAgent.m
//  HKProject
//
//  Created by rubick on 2018/7/27.
//  Copyright © 2018年 hjkl. All rights reserved.
//

#import "HJNetworkAgent.h"
#import "HJBaseRequest.h"
#import "HJNetworkPrivate.h"
#import "HJNetworkTool.h"
#import "HJNetworkConfig.h"
#import "HJCacheHelper.h"
#import <pthread/pthread.h>

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

#define Lock() pthread_mutex_lock(&_lock)
#define Unlock() pthread_mutex_unlock(&_lock)

#define kHJNetworkIncompleteDownloadFolderName @"HJIncomplete"

@interface HJNetworkAgent(){
    pthread_mutex_t _lock;
}
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@property (strong, nonatomic) HJNetworkConfig *config;
@property (strong, nonatomic) AFJSONResponseSerializer *jsonResponseSerializer;
@property (strong, nonatomic) AFXMLParserResponseSerializer *xmlParserResponseSerializer;
@property (strong, nonatomic) NSMutableDictionary<NSNumber *, HJBaseRequest *> *requestsRecord;
@property (strong, nonatomic) dispatch_queue_t processingQueue;
@property (strong, nonatomic) NSIndexSet *allStatusCode;

@end

@implementation HJNetworkAgent

+ (HJNetworkAgent *)shareAgent {
    static id shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}
- (instancetype)init {
    self = [super init];
    if(self){
        _config = [HJNetworkConfig shareConfig];
        _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:_config.sessionConfiguration];
        _requestsRecord = [NSMutableDictionary dictionary];
        _processingQueue = dispatch_queue_create("com.hjkl.network.processing", DISPATCH_QUEUE_CONCURRENT);
        _allStatusCode = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
        pthread_mutex_init(&_lock, NULL);
        _manager.securityPolicy = _config.securityPolicy;
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer.acceptableStatusCodes = _allStatusCode;
        _manager.completionQueue = _processingQueue;
    }
    return self;
}
- (AFJSONResponseSerializer *)jsonResponseSerializer {
    if(!_jsonResponseSerializer){
        _jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        _jsonResponseSerializer.acceptableStatusCodes = _allStatusCode;
    }
    return _jsonResponseSerializer;
}
- (AFXMLParserResponseSerializer *)xmlParserResponseSerializer {
    if(!_xmlParserResponseSerializer){
        _xmlParserResponseSerializer = [AFXMLParserResponseSerializer serializer];
        _xmlParserResponseSerializer.acceptableStatusCodes = _allStatusCode;
    }
    return _xmlParserResponseSerializer;
}
#pragma mark - Request Set 
- (NSString *)buildRequestUrl:(HJBaseRequest *)request {
    NSParameterAssert(request != nil);
    NSString *detailUrl = [request requestUrl];
    NSURL *temp = [NSURL URLWithString:detailUrl];
    if(temp && temp.host && temp.scheme){
        return detailUrl;
    }
    NSString *baseUrl;
    if([request useCDN]){
        if([request cdnUrl].length > 0){
            baseUrl = [request cdnUrl];
        } else {
            baseUrl = [_config cdnUrl];
        }
    } else {
        if ([request baseUrl].length > 0) {
            baseUrl = [request baseUrl];
        } else {
            baseUrl = [_config baseUrl];
        }
    }
    NSURL *url = [NSURL URLWithString:baseUrl];
    if(baseUrl.length > 0 && ![baseUrl hasSuffix:@"/"]){
        url = [url URLByAppendingPathComponent:@""];
    }
    return [NSURL URLWithString:detailUrl relativeToURL:url].absoluteString;
}
- (AFHTTPRequestSerializer *)requestSerializerForRequest:(HJBaseRequest *)request {
    AFHTTPRequestSerializer *requestSerializer = nil;
    if(request.requestSerializerType == HJRequestSerializerHTTP){
        requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if(request.requestSerializerType == HJRequestSerializerJSON){
        requestSerializer = [AFJSONRequestSerializer serializer];
    }
    requestSerializer.timeoutInterval = [request requestTimeoutInterval];
    requestSerializer.allowsCellularAccess = [request allowsCellularAccess];
    NSArray<NSString *> *authorizationHeaderFiledArray = [request requestAuthorizationHeaderFieldArray];
    if(authorizationHeaderFiledArray != nil){
        [requestSerializer setAuthorizationHeaderFieldWithUsername:authorizationHeaderFiledArray.firstObject password:authorizationHeaderFiledArray.lastObject];
    }
    NSDictionary<NSString *, NSString *> *headerFieldValueDictionary = [request requestHeaderFieldValueDictionary];
    if(headerFieldValueDictionary != nil){
        for(NSString *httpHeaderField in headerFieldValueDictionary.allKeys){
            NSString *value = headerFieldValueDictionary[httpHeaderField];
            [requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    return requestSerializer;
}
- (NSURLSessionTask *)sessionTaskForRequest:(HJBaseRequest *)request error:(NSError * _Nullable __autoreleasing *)error {
    HJRequestMethod method = [request requestMethod];
    NSString *url = [self buildRequestUrl:request];
    id param = request.requestArgument;
    AFConstructingBlock constructingBlock = [request constructingBodyBlock];
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerForRequest:request];
    switch (method) {
        case HJRequestMethodGET:
            if(request.resumableDownloadPath){
                return [self downloadTaskWithDownloadPath:request.resumableDownloadPath requestSerializer:requestSerializer URLString:url parameters:param progress:request.resumableDownloadProgressBlock error:error];
            } else {
                return [self dataTaskWithHTTPMethod:@"GET" requestSerializer:requestSerializer URLString:url parameters:param error:error];
            }
            break;
        case HJRequestMethodPOST:
            return [self dataTaskWithHTTPMethod:@"POST" requestSerializer:requestSerializer URLString:url parameters:param constructingBodyWithBlock:constructingBlock error:error];
            break;
        case HJRequestMethodHEAD:
            return [self dataTaskWithHTTPMethod:@"HEAD" requestSerializer:requestSerializer URLString:url parameters:param error:error];
            break;
        case HJRequestMethodPUT:
            return [self dataTaskWithHTTPMethod:@"PUT" requestSerializer:requestSerializer URLString:url parameters:param error:error];
            break;
        case HJRequestMethodDELETE:
            return [self dataTaskWithHTTPMethod:@"DELETE" requestSerializer:requestSerializer URLString:url parameters:param error:error];
            break;
        case HJRequestMethodPATCH:
            return [self dataTaskWithHTTPMethod:@"PATCH" requestSerializer:requestSerializer URLString:url parameters:param error:error];
            break;
    }
}
#pragma mark - Manager Request
- (void)addRequest:(HJBaseRequest *)request {
    NSParameterAssert(request != nil);
    NSError * __autoreleasing requestSerializationError = nil;
    NSURLRequest *customUrlRequest = [request buildCustomUrlRequest];
    if(customUrlRequest) {
        __block NSURLSessionDataTask *dataTask = nil;
        dataTask = [self.manager dataTaskWithRequest:customUrlRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            [self handleRequestResult:dataTask responseObject:responseObject error:error];
        }];
        request.requestTask = dataTask;
    } else {
        request.requestTask = [self sessionTaskForRequest:request error:&requestSerializationError];
    }
    if(requestSerializationError) {
        [self requestDidFailWithRequest:request error:requestSerializationError];
        return;
    }
    NSAssert(request.requestTask != nil, @"rquest task should not be nil");
    [self addRequestToRecord:request];
    [request.requestTask resume];
}
- (void)cancelRequest:(HJBaseRequest *)request {
    NSParameterAssert(request != nil);
    if(request.resumableDownloadPath){
        NSURLSessionDownloadTask *requestTask = (NSURLSessionDownloadTask *)request.requestTask;
        [requestTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            NSURL *localUrl = [self incompleteDownloadTempPathForDownloadPath:request.resumableDownloadPath];
            [resumeData writeToURL:localUrl atomically:YES];
        }];
    } else {
        [request.requestTask cancel];
    }
    [self removeRequestFromRecord:request];
    [request clearCompletionBlock];
}
- (void)cancelAllRequests {
    Lock();
    NSArray *allKeys = [_requestsRecord allKeys];
    Unlock();
    if(allKeys && allKeys.count > 0) {
        NSArray *copiedKeys = [allKeys copy];
        for(NSNumber *key in copiedKeys) {
            Lock();
            HJBaseRequest *request = _requestsRecord[key];
            Unlock();
            [request stop];
        }
    }
}
- (void)addRequestToRecord:(HJBaseRequest *)request {
    Lock();
    self.requestsRecord[@(request.requestTask.taskIdentifier)] = request;
    Unlock();
}
- (void)removeRequestFromRecord:(HJBaseRequest *)request {
    Lock();
    [self.requestsRecord removeObjectForKey:@(request.requestTask.taskIdentifier)];
    Unlock();
}
#pragma mark - HTTP Method
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                               requestSerializer:(AFHTTPRequestSerializer *)requestSerializer URLString:(NSString *)URLString parameters:(id)parameters error:(NSError * _Nullable __autoreleasing *)error {
    return [self dataTaskWithHTTPMethod:method requestSerializer:requestSerializer URLString:URLString parameters:parameters constructingBodyWithBlock:nil error:error];
}
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                               requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                       constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                           error:(NSError * _Nullable __autoreleasing *)error {
    NSMutableURLRequest *request = nil;
    if(block){
        request = [requestSerializer multipartFormRequestWithMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:block error:error];
    } else {
        request = [requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:error];
    }
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [self handleRequestResult:dataTask responseObject:responseObject error:error];
    }];
    return dataTask;
}
- (NSURLSessionDownloadTask *)downloadTaskWithDownloadPath:(NSString *)downloadPath requestSerializer:(AFHTTPRequestSerializer *)requestSerializer URLString:(NSString *)URLString parameters:(id)parameters progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock error:(NSError * _Nullable __autoreleasing *)error {
    NSMutableURLRequest *urlRequest = [requestSerializer requestWithMethod:@"GET" URLString:URLString parameters:parameters error:error];
    NSString *downloadTargetPath;
    BOOL isDirectory;
    if(![[NSFileManager defaultManager] fileExistsAtPath:downloadPath isDirectory:&isDirectory]) {
        isDirectory = NO;
    }
    if(isDirectory) {
        NSString *fileName = [urlRequest.URL lastPathComponent];
        downloadTargetPath = [NSString pathWithComponents:@[downloadPath, fileName]];
    } else {
        downloadTargetPath = downloadPath;
    }
    if([[NSFileManager defaultManager] fileExistsAtPath:downloadTargetPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:downloadTargetPath error:nil];
    }
    BOOL resumeDataFileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self incompleteDownloadTempPathForDownloadPath:downloadPath].path];
    NSData *data = [NSData dataWithContentsOfURL:[self incompleteDownloadTempPathForDownloadPath:downloadPath]];
    BOOL resumeDataIsValid = [HJNetworkTool validateResumeData:data];
    BOOL canBeResumed = resumeDataFileExists && resumeDataIsValid;
    BOOL resumeSuccesseded = NO;
    __block NSURLSessionDownloadTask *downloadTask = nil;
    if(canBeResumed){
        @try {
            downloadTask = [self.manager downloadTaskWithResumeData:data progress:downloadProgressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                return [NSURL fileURLWithPath:downloadTargetPath isDirectory:NO];
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                [self handleRequestResult:downloadTask responseObject:filePath error:error];
            }];
            resumeSuccesseded = YES;
        } @catch (NSException *exception) {
            resumeSuccesseded = NO;
        }
    }
    if(!resumeSuccesseded){
        downloadTask = [self.manager downloadTaskWithRequest:urlRequest progress:downloadProgressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL fileURLWithPath:downloadTargetPath isDirectory:NO];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            [self handleRequestResult:downloadTask responseObject:filePath error:error];
        }];
    }
    return downloadTask;
}
#pragma mark - Request Result Handle
- (void)handleRequestResult:(NSURLSessionTask *)task responseObject:(id)responseObject error:(NSError *)error {
    Lock();
    HJBaseRequest *request = self.requestsRecord[@(task.taskIdentifier)];
    Unlock();
    if(!request) return;
    NSError * __autoreleasing serializationError = nil;
    NSError * __autoreleasing validationError = nil;
    NSError *requestError = nil;
    BOOL succeed = NO;
    
    request.responseObject = responseObject;
    if([request.responseObject isKindOfClass:[NSData class]]) {
        request.responseData = responseObject;
        request.responseString = [[NSString alloc] initWithData:responseObject encoding:[HJNetworkTool stringEncodingWithRequest:request]];
        switch(request.responseSerializerType){
            case HJResponseSerializerHTTP:
                break;
            case HJResponseSerializerJSON:
                request.responseObject = [self.jsonResponseSerializer responseObjectForResponse:task.response data:request.responseData error:&serializationError];
                request.responseJSONObject = request.responseObject;
                break;
            case HJResponseSerializerXML:
                request.responseObject = [self.xmlParserResponseSerializer responseObjectForResponse:task.response data:request.responseData error:&serializationError];
                break;
        }
    }
    if(error) {
        succeed = NO;
        requestError = error;
    } else if(serializationError){
        succeed = NO;
        requestError = serializationError;
    } else {
        succeed = [self validateResult:request error:&validationError];
        requestError = validationError;
    }
    if(succeed){
        [self requestDidSucceedWithRequest:request];
    } else {
        [self requestDidFailWithRequest:request error:requestError];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeRequestFromRecord:request];
        [request clearCompletionBlock];
    });
}
- (void)requestDidSucceedWithRequest:(HJBaseRequest *)request {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (request.delegate != nil) {
            [request.delegate requestFinished:request];
        }
        if (request.successCompletionBlock) {
            request.successCompletionBlock(request);
        }
    });
}
- (void)requestDidFailWithRequest:(HJBaseRequest *)request error:(NSError *)error {
    request.error = error;
    NSData *incompleteDownloadData = error.userInfo[NSURLSessionDownloadTaskResumeData];
    if (incompleteDownloadData) {
        [incompleteDownloadData writeToURL:[self incompleteDownloadTempPathForDownloadPath:request.resumableDownloadPath] atomically:YES];
    }
    if ([request.responseObject isKindOfClass:[NSURL class]]) {
        NSURL *url = request.responseObject;
        if (url.isFileURL && [[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
            request.responseData = [NSData dataWithContentsOfURL:url];
            request.responseString = [[NSString alloc] initWithData:request.responseData encoding:[HJNetworkTool stringEncodingWithRequest:request]];
            [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
        }
        request.responseObject = nil;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (request.delegate != nil) {
            [request.delegate requestFailed:request];
        }
        if (request.failureCompletionBlock) {
            request.failureCompletionBlock(request);
        }
    });
}
#pragma mark - Resumable Download
- (NSString *)incompleteDownloadTempCacheFolder {
    NSFileManager *fileManager = [NSFileManager new];
    static NSString *cacheFolder;
    if (!cacheFolder) {
        NSString *cacheDir = NSTemporaryDirectory();
        cacheFolder = [cacheDir stringByAppendingPathComponent:kHJNetworkIncompleteDownloadFolderName];
    }
    NSError *error = nil;
    if(![fileManager createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:&error]) {
        NSLog(@"Failed to create cache directory at %@", cacheFolder);
        cacheFolder = nil;
    }
    return cacheFolder;
}

- (NSURL *)incompleteDownloadTempPathForDownloadPath:(NSString *)downloadPath {
    NSString *tempPath = nil;
    NSString *md5URLString = [HJPathHelper md5StringFromString:downloadPath];
    tempPath = [[self incompleteDownloadTempCacheFolder] stringByAppendingPathComponent:md5URLString];
    return [NSURL fileURLWithPath:tempPath];
}
- (BOOL)validateResult:(HJBaseRequest *)request error:(NSError * _Nullable __autoreleasing *)error {
    BOOL result = [request statusCodeValidator];
    if (!result) {
        if (error) {
            *error = [NSError errorWithDomain:HJRequestValidationErrorDomain code:-2 userInfo:@{NSLocalizedDescriptionKey:@"Invalid status code"}];
        }
        return result;
    }
    id json = [request responseJSONObject];
    id validator = [request jsonValidator];
    if (json && validator) {
        result = [HJNetworkTool validateJSON:json withValidator:validator];
        if (!result) {
            if (error) {
                *error = [NSError errorWithDomain:HJRequestValidationErrorDomain code:-3 userInfo:@{NSLocalizedDescriptionKey:@"Invalid JSON format"}];
            }
            return result;
        }
    }
    return YES;
}

#pragma mark - Testing
- (AFHTTPSessionManager *)manager {
    return _manager;
}
- (void)resetURLSessionManager {
    _manager = [AFHTTPSessionManager manager];
}
- (void)resetURLSessionManagerWithConfiguration:(NSURLSessionConfiguration *)configuration {
    _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
}

@end
