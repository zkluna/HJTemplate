//
//  NetworkTool.h
//  DeapLearn
//
//  Created by Rubick on 2017/11/3.
//  Copyright © 2017年 ***. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

/** 网络状态 */
typedef NS_ENUM(NSUInteger, NetworkingStatus) {
    NetworkingStatusUnknown,
    NetworkingStatusNotReachable,
    NetworkingStatusReachableViaWWAN,
    NetworkingStatusReachableViaWifi,
};
/** 请求方式 */
typedef NS_ENUM(NSUInteger, RequestSerializer) {
    RequestSerializerJSON,
    RequestSerializerHTTP,
};
/** 应答方式 */
typedef NS_ENUM(NSUInteger, ResponseSerializer) {
    ResponseSerializerJSON,
    ResponseSerializerHTTP,
    ResponseSerializerXML,
};
/** 成功回调 */
typedef void(^NetworkResponseSuccess)(id responseObject);
/** 失败回调 */
typedef void(^NetworkResponseFailure)(NSError *error);
/** 进度block */
typedef void(^NetworkingProgress)(NSProgress *progress);
/** 网络状态block */
typedef void(^NetworkingStatusBlock)(NetworkingStatus status);

@interface HJNetworkingTool : NSObject

@property (unsafe_unretained, nonatomic) AFNetworkReachabilityStatus networkStatus;

+ (instancetype)shareTool;
+ (AFHTTPSessionManager *)shareSessionManager;
+ (void)startMonitoring;
/** 网络请求头设置 */
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;
/** 取消请求 */
//+ (void)cancelAllRequest;
//+ (void)cancelRequestWithURL:(NSString *)url;

/** get请求 */
+ (NSURLSessionTask *)getWithSessionManager:(AFHTTPSessionManager *)sessionManager URL:(NSString *)URL paramaters:(NSDictionary *)parameters success:(NetworkResponseSuccess)success failure:(NetworkResponseFailure)failure progress:(NetworkingProgress)progress;
/** post请求 */
+ (NSURLSessionTask *)postWithSessionManager:(AFHTTPSessionManager *)sessionManager URL:(NSString *)URL paramaters:(NSDictionary *)parameters success:(NetworkResponseSuccess)success failure:(NetworkResponseFailure)failure progress:(NetworkingProgress)progress;

/** 上传图片 */
+ (NSURLSessionTask *)uploadWithSessionManager:(AFHTTPSessionManager *)sessionManager URL:(NSString *)URL parameters:(NSDictionary *)parameters images:(NSArray<id>*)images name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType progress:(NetworkingProgress)progress success:(NetworkResponseSuccess)success failure:(NetworkResponseFailure)failure;
/** 下载 */
+ (NSURLSessionTask *)downloadWithSessionManager:(AFHTTPSessionManager *)sessionManager URL:(NSString *)URL fileDir:(NSString *)fileDir progress:(NetworkingProgress)progress success:(void(^)(NSString *filePath))success failure:(NetworkResponseFailure)failure;

@end
