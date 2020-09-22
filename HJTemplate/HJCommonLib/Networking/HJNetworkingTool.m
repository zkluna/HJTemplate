//
//  NetworkTool.m
//  DeapLearn
//
//  Created by Rubick on 2017/11/3.
//  Copyright © 2017年 ***. All rights reserved.
//

#import "HJNetworkingTool.h"
#import "NSString+Extend.h"

static AFHTTPSessionManager *_sessionManager;
static NSMutableArray *_allSeesionTask;
static HJNetworkingTool *_shareTool;

@interface HJNetworkingTool()
@property (strong, nonatomic) AFNetworkReachabilityManager *reachabilityMgr;
@end

@implementation HJNetworkingTool

+ (instancetype)shareTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareTool = [[HJNetworkingTool alloc] init];
        _shareTool.networkStatus = AFNetworkReachabilityStatusUnknown;
        _shareTool.reachabilityMgr = [AFNetworkReachabilityManager managerForDomain:@""];
    });
    return _shareTool;
}
+ (AFHTTPSessionManager *)shareSessionManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer.timeoutInterval = 90.f;
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/plain",@"text/javascript",@"text/xml",@"image/*", nil];
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    });
    return _sessionManager;
}
+ (void)startMonitoring {
    [self shareTool];
    AFNetworkReachabilityManager *reachabilityMgr = _sessionManager.reachabilityManager;
    [reachabilityMgr startMonitoring];
    [reachabilityMgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        _shareTool.networkStatus = status;
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:{}
                break;
            case AFNetworkReachabilityStatusNotReachable:{}
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:{}
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:{}
                break;
            default:
                break;
        }
    }];
}
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [_sessionManager.requestSerializer setValue:value forHTTPHeaderField:field];
}
+ (NSMutableArray *)allSessionTask {
    if(!_allSeesionTask){
        _allSeesionTask = [[NSMutableArray alloc] init];
    }
    return _allSeesionTask;
}
//+ (void)cancelAllRequest {
//    @synchronized (self) {
//        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
//            [task cancel];
//        }];
//        [[self allSessionTask] removeAllObjects];
//    }
//}
//+ (void)cancelRequestWithURL:(NSString *)url {
//    if(!url) return;
//    @synchronized(self) {
//        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
//            if([task.currentRequest.URL.absoluteString hasPrefix:url]) {
//                [task cancel];
//                [[self allSessionTask] removeObject:task];
//                *stop = YES;
//            }
//        }];
//    }
//}
+ (NSURLSessionTask *)getWithSessionManager:(AFHTTPSessionManager *)sessionManager URL:(NSString *)URL paramaters:(NSDictionary *)parameters success:(NetworkResponseSuccess)success failure:(NetworkResponseFailure)failure progress:(NetworkingProgress)progress {
    AFHTTPSessionManager *manager = sessionManager;
    if(!manager){
        manager = [self shareSessionManager];
    }
    NSError *serializationError = nil;
    NSMutableURLRequest *requst = [manager.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URL relativeToURL:manager.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if(serializationError) {
        if(failure){
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(serializationError);
            });
        }
        return nil;
    }
    __block NSURLSessionTask *sessionTask = nil;
    sessionTask = [manager dataTaskWithRequest:requst uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        if(progress){
            progress(uploadProgress);
        }
    } downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(error){
            if(failure){ failure(error); }
        } else {
            if(success){ success(responseObject); };
        }
    }];
    [sessionTask resume];
    return sessionTask;
}
+ (NSURLSessionTask *)postWithSessionManager:(AFHTTPSessionManager *)sessionManager URL:(NSString *)URL paramaters:(NSDictionary *)parameters success:(NetworkResponseSuccess)success failure:(NetworkResponseFailure)failure progress:(NetworkingProgress)progress {
    AFHTTPSessionManager *manager = sessionManager;
    if(!manager){
        manager = [self shareSessionManager];
    }
    __block NSURLSessionTask *sessionTask = [self createPOSTTaskWithSessionManager:manager urlString:URL parameters:parameters success:^(NSURLSessionDataTask *task, id result) {
        if(success){
            success(result);
        }
    } failure:^(NSURLSessionDataTask *task, NSError * error) {
        if(failure){
            failure(error);
        }
    }];
    [sessionTask resume];
    return sessionTask;
}
+ (NSURLSessionTask *)uploadWithSessionManager:(AFHTTPSessionManager *)sessionManager URL:(NSString *)URL parameters:(NSDictionary *)parameters images:(NSArray<id> *)images name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType progress:(NetworkingProgress)progress success:(NetworkResponseSuccess)success failure:(NetworkResponseFailure)failure {
    AFHTTPSessionManager *manager = sessionManager;
    if(!manager){
        manager = [self shareSessionManager];
    }
    // 生成图片名字
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSUUID *uuid = [NSUUID UUID];
    NSString *newfileName = [[NSString stringWithFormat:@"%@%@",uuid.UUIDString,str] md5];
    NSString *base64ImgName = [[newfileName dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    // 拼接表单
    void(^form)(id <AFMultipartFormData> formData) = nil;
    form = ^(id <AFMultipartFormData> formData) {
        int i=0;
        for(id temp in images){
            if([temp isKindOfClass:[NSURL class]]){
                NSError *uploadFileErr = nil;
                [formData appendPartWithFileURL:(NSURL *)temp name:name fileName:[NSString stringWithFormat:@"%@%d.png",base64ImgName,i] mimeType:@"image/png" error:&uploadFileErr];
            } else if([temp isKindOfClass:[NSData class]]) {
                [formData appendPartWithFileData:(NSData *)temp name:name fileName:[NSString stringWithFormat:@"%@%d.png",base64ImgName,i] mimeType:@"image/png"];
            } else if([temp isKindOfClass:[UIImage class]]){
                [formData appendPartWithFileData:UIImagePNGRepresentation((UIImage *)temp) name:name fileName:[NSString stringWithFormat:@"%@%d.png",base64ImgName,i] mimeType:@"image/png"];
            }
            i+=1;
        }
    };
    __block NSURLSessionTask *task =[self createPostTaskWithSessionManager:manager urlString:URL parameters:parameters constructingBodyWithBlock:form progress:^(NSProgress *uploadProgress) {
        if(progress){
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask *task , id resultObj) {
        if(success){
            success(resultObj);
        }
    } failure:^(NSURLSessionDataTask *task, NSError * error) {
        if(failure){
            failure(error);
        }
    }];
    [task resume];
    return task;
}
+ (NSURLSessionTask *)downloadWithSessionManager:(AFHTTPSessionManager *)sessionManager URL:(NSString *)URL fileDir:(NSString *)fileDir progress:(NetworkingProgress)progress success:(void (^)(NSString *))success failure:(NetworkResponseFailure)failure {
    NSURLRequest *requst = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    __block NSURLSessionDownloadTask *downloadTask = [_sessionManager downloadTaskWithRequest:requst progress:progress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir?fileDir:@"Download"];
        NSFileManager *fileMananger = [NSFileManager defaultManager];
        [fileMananger createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [[self allSessionTask] removeObject:downloadTask];
        if(failure && error){
            failure(error);
            return;
        } else {
            success?success(filePath.absoluteString):nil;
        }
    }];
    [downloadTask resume];
    downloadTask?[[self allSessionTask] addObject:downloadTask]:nil;
    return downloadTask;
}
//
+ (NSURLSessionDataTask *)createPostTaskWithSessionManager:(AFHTTPSessionManager *)sessionManager urlString:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block progress:(void (^)(NSProgress *))progress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    AFHTTPSessionManager *mgr = sessionManager;
    if (!mgr) {
        mgr = [self shareSessionManager];
    }
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [mgr.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:mgr.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(mgr.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        return nil;
    }
    __block NSURLSessionDataTask *task = [mgr uploadTaskWithStreamedRequest:request progress:progress completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(task, error);
            }
        } else {
            if (success) {
                success(task, responseObject);
            }
        }
    }];
    return task;
}
//
+ (NSURLSessionDataTask *)createPOSTTaskWithSessionManager:(AFHTTPSessionManager *)sessionManager urlString:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    AFHTTPSessionManager *mgr = sessionManager;
    if (!mgr) {
        mgr = [self shareSessionManager];
    }
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [mgr.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:mgr.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(mgr.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        return nil;
    }
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [mgr dataTaskWithRequest:request
                         uploadProgress:nil
                       downloadProgress:nil
                      completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                          if (error) {
                              if (failure) {
                                  failure(dataTask, error);
                              }
                          } else {
                              if (success) {
                                  success(dataTask, responseObject);
                              }
                          }
                      }];
    
    return dataTask;
}

@end
