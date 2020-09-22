//
//  HJRequest.m
//  HKProject
//
//  Created by rubick on 2018/7/27.
//  Copyright © 2018年 hjkl. All rights reserved.
//

#import "HJRequest.h"
#import "HJNetworkConfig.h"
#import "HJNetworkPrivate.h"
#import "HJNetworkTool.h"
#import "HJCacheHelper.h"
#import "HJCacheMetaData.h"

#ifndef NSFoundationVersionNumber_iOS_8_0
#define NSFoundationVersionNumber_With_QoS_Available 1140.11
#else
#define NSFoundationVersionNumber_With_QoS_Available NSFoundationVersionNumber_iOS_8_0
#endif

NSString *const HJRequestCacheErrorDomain = @"com.hjkl.request.cacheing";

static dispatch_queue_t hj_request_cache_writing_queue() {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_attr_t attr = DISPATCH_QUEUE_SERIAL;
        if(NSFoundationVersionNumber >= NSFoundationVersionNumber_With_QoS_Available) {
            attr = dispatch_queue_attr_make_with_qos_class(attr, QOS_CLASS_BACKGROUND, 0);
        }
        queue = dispatch_queue_create("com.hjkl.hjrequest.cacheing", attr);
    });
    return queue;
}

@interface HJRequest()

@property (strong, nonatomic) NSData *cacheData;
@property (strong, nonatomic) NSString *cacheString;
@property (strong, nonatomic) id cacheJSON;
@property (strong, nonatomic) NSXMLParser *cacheXML;
@property (strong, nonatomic) HJCacheMetaData *cacheMetaData;

@end

@implementation HJRequest

- (void)start {
    [self startWithoutCache];
//    if(self.ignoreCache){
//        return;
//    }
//    if(self.resumableDownloadPath){
//        [self startWithoutCache];
//        return;
//    }
//    if(![self loadCacheWithError:nil]){
//        [self startWithoutCache];
//        return;
//    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        HJRequest *strongSelf = self;
//        [strongSelf.delegate requestFailed:strongSelf];
//        if(strongSelf.successCompletionBlock){
//            strongSelf.successCompletionBlock(strongSelf);
//        }
//        [strongSelf clearCompletionBlock];
//    });
}
- (void)startWithoutCache {
    [self clearCacheVariables];
    [super start];
}
- (void)clearCacheVariables {
    _cacheData = nil;
    _cacheXML = nil;
    _cacheJSON = nil;
    _cacheString = nil;
    _cacheMetaData = nil;
}
- (NSInteger)cacheTimeInSeconds {
    return 60*60*24*15;
}
- (long long)cacheVersion {
    return 0;
}
- (id)cacheSensitiveData {
    return nil;
}
- (NSData *)responseData {
    if(_cacheData){
        return _cacheData;
    }
    return [super responseData];
}
- (NSString *)responseString {
    if(_cacheString) {
        return _cacheString;
    }
    return [super responseString];
}
- (id)responseJSONObject {
    if(_cacheJSON){
        return _cacheJSON;
    }
    return [super responseJSONObject];
}
- (id)responseObject {
    if (_cacheJSON) {
        return _cacheJSON;
    }
    if (_cacheXML) {
        return _cacheXML;
    }
    if (_cacheData) {
        return _cacheData;
    }
    return [super responseObject];
}
- (BOOL)loadCacheWithError:(NSError * _Nullable __autoreleasing *)error {
//    if ([self cacheTimeInSeconds] < 0) {
//        if (error) {
//            *error = [NSError errorWithDomain:HJRequestCacheErrorDomain code:HJRequestCacheErrorInvalidCacheTime userInfo:@{ NSLocalizedDescriptionKey:@"Invalid cache time"}];
//        }
//        return NO;
//    }
    if (![self loadCacheMetaData]) {
        if (error) {
            *error = [NSError errorWithDomain:HJRequestCacheErrorDomain code:HJRequestCacheErrorInvalidMetadata userInfo:@{ NSLocalizedDescriptionKey:@"Invalid metadata. Cache may not exist"}];
        }
        return NO;
    }
    if (![self validateCacheWithError:error]) {
        return NO;
    }
    if (![self loadCacheData]) {
        if (error) {
            *error = [NSError errorWithDomain:HJRequestCacheErrorDomain code:HJRequestCacheErrorInvalidCacheData userInfo:@{ NSLocalizedDescriptionKey:@"Invalid cache data"}];
        }
        return NO;
    }
    return YES;
}
- (BOOL)validateCacheWithError:(NSError * _Nullable __autoreleasing *)error {
    NSDate *creationDate = self.cacheMetaData.creationDate;
    NSTimeInterval duration = -[creationDate timeIntervalSinceNow];
//    if (duration < 0 || duration > [self cacheTimeInSeconds]) {
//        if (error) {
//            *error = [NSError errorWithDomain:HJRequestCacheErrorDomain code:HJRequestCacheErrorExpired userInfo:@{ NSLocalizedDescriptionKey:@"Cache expired"}];
//        }
//        return NO;
//    }
    long long cacheVersionFileContent = self.cacheMetaData.version;
    if (cacheVersionFileContent != [self cacheVersion]) {
        if (error) {
            *error = [NSError errorWithDomain:HJRequestCacheErrorDomain code:HJRequestCacheErrorVersionMismatch userInfo:@{ NSLocalizedDescriptionKey:@"Cache version mismatch"}];
        }
        return NO;
    }
    NSString *sensitiveDataString = self.cacheMetaData.sensitiveDataString;
    NSString *currentSensitiveDataString = ((NSObject *)[self cacheSensitiveData]).description;
    if (sensitiveDataString || currentSensitiveDataString) {
        if (sensitiveDataString.length != currentSensitiveDataString.length || ![sensitiveDataString isEqualToString:currentSensitiveDataString]) {
            if (error) {
                *error = [NSError errorWithDomain:HJRequestCacheErrorDomain code:HJRequestCacheErrorSensitiveDataMismatch userInfo:@{ NSLocalizedDescriptionKey:@"Cache sensitive data mismatch"}];
            }
            return NO;
        }
    }
    NSString *appVersionString = self.cacheMetaData.appVersion;
    NSString *currentAppVersionString = [HJAppInfoTool appVersion];
    if (appVersionString || currentAppVersionString) {
        if (appVersionString.length != currentAppVersionString.length || ![appVersionString isEqualToString:currentAppVersionString]) {
            if (error) {
                *error = [NSError errorWithDomain:HJRequestCacheErrorDomain code:HJRequestCacheErrorAppVersionMismatch userInfo:@{ NSLocalizedDescriptionKey:@"App version mismatch"}];
            }
            return NO;
        }
    }
    return YES;
}
- (BOOL)loadCacheMetaData {
    NSString *path = [self cacheMetaDataFilePath];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path isDirectory:nil]) {
        @try {
            _cacheMetaData = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
            return YES;
        } @catch (NSException *exception) {
            NSLog(@"Load cache metadata failed, reason = %@", exception.reason);
            return NO;
        }
    }
    return NO;
}

- (BOOL)loadCacheData {
    NSString *path = [self cacheFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    if ([fileManager fileExistsAtPath:path isDirectory:nil]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        _cacheData = data;
        _cacheString = [[NSString alloc] initWithData:_cacheData encoding:self.cacheMetaData.stringEncoding];
        switch (self.responseSerializerType) {
            case HJResponseSerializerHTTP:
                return YES;
            case HJResponseSerializerJSON:
                _cacheJSON = [NSJSONSerialization JSONObjectWithData:_cacheData options:(NSJSONReadingOptions)0 error:&error];
                return error == nil;
            case HJResponseSerializerXML:
                _cacheXML = [[NSXMLParser alloc] initWithData:_cacheData];
                return YES;
        }
    }
    return NO;
}
- (void)saveResponseDataToCacheFile:(NSData *)data {
    if ([self cacheTimeInSeconds] > 0) {
        if (data != nil) {
            @try {
                [data writeToFile:[self cacheFilePath] atomically:YES];
                HJCacheMetaData *metadata = [[HJCacheMetaData alloc] init];
                metadata.version = [self cacheVersion];
                metadata.sensitiveDataString = ((NSObject *)[self cacheSensitiveData]).description;
                metadata.stringEncoding = [HJNetworkTool stringEncodingWithRequest:self];
                metadata.creationDate = [NSDate date];
                metadata.appVersion = [HJAppInfoTool appVersion];
//                if(@available(iOS 12.0, *)) {
//                    NSError *error = nil;
//                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:metadata requiringSecureCoding:NO error:&error];
//                    if(!error) {
//                        [data writeToFile:[self cacheMetaDataFilePath] options:NSDataWritingAtomic error:&error];
//                    }
//                } else {
//                }
                [NSKeyedArchiver archiveRootObject:metadata toFile:[self cacheMetaDataFilePath]];
            } @catch (NSException *exception) {
                NSLog(@"Save cache failed, reason = %@", exception.reason);
            }
        }
    }
}
- (NSString *)cacheFileName {
    NSString *requestUrl = [self requestUrl];
    NSString *baseUrl = [HJNetworkConfig shareConfig].baseUrl;
    id argument = [self requestArgument];
    NSString *requestInfo = [NSString stringWithFormat:@"Method:%ld Host:%@ Url:%@ Argument:%@",(long)[self requestMethod],baseUrl,requestUrl,argument];
    NSString *cacheFileName = [HJPathHelper md5StringFromString:requestInfo];
    return cacheFileName;
}
- (NSString *)cacheFilePath {
    NSString *cacheFileName = [self cacheFileName];
    NSString *path = [HJPathHelper hj_requestCacheBasePath];
    path = [path stringByAppendingPathComponent:cacheFileName];
    return path;
}
- (NSString *)cacheMetaDataFilePath {
    NSString *cacheMetaDataFileName = [NSString stringWithFormat:@"%@.metadata",[self cacheFileName]];
    NSString *path = [HJPathHelper hj_requestCacheBasePath];
    path = [path stringByAppendingPathComponent:cacheMetaDataFileName];
    return path;
}
- (void)startRequestWithCompletionSuccess:(nullable void(^)(id responseObject))success failure:(nullable void(^)(NSError *error))failure {
    BOOL isNetwortConnect = [[HJNetworkManager shareHJNetworkManager].isNetworkReachable boolValue];
    if(!isNetwortConnect && self.isNeedCache) {
        NSError *error = nil;
        BOOL isLoadSuccess = [self loadCacheWithError:&error];
        if(isLoadSuccess) {
            if(self.cacheJSON) {
                if(success) { success(self.cacheJSON); }
                return;
            }
            if(self.cacheData) {
                if(success) { success(self.cacheData); }
                return;
            }
        } else {
            NSError *networkError = [NSError errorWithDomain:@"NoNetworkConnect" code:HJRequestNoNetworkConnectError userInfo:@{NSLocalizedDescriptionKey:@"暂无网络连接"}];
            if(failure) { failure(networkError); }
        }
        return;
    }
    [super startWithCompletionBlockWithSuccess:^(__kindof HJBaseRequest * _Nonnull request) {
        if(success) {
            if(self.responseData && self.isNeedCache) {
                [self saveResponseDataToCacheFile:self.responseData];
            }
            if(self.responseObject) {
                success(self.responseObject);
                return;
            }
        }
    } failure:^(__kindof HJBaseRequest * _Nonnull request) {
        if(self.isNeedCache) {
            if(self.isNeedCache) {
                NSError *error = nil;
                BOOL isLoadSuccess = [self loadCacheWithError:&error];
                if(isLoadSuccess) {
                    if(self.cacheJSON) {
                        if(success) { success(self.cacheJSON); }
                        return;
                    }
                    if(self.cacheData) {
                        if(success) { success(self.cacheData); }
                        return;
                    }
                    return;
                }
            }
        }
        if(failure) { failure(self.error); }
    }];
}
- (void)saveToLocalWithObject:(NSData *)reponseObject {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        [self saveResponseDataToCacheFile:reponseObject];
    });
}
@end
