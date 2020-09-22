//
//  HJBaseRequest.h
//  HKProject
//
//  Created by rubick on 2018/7/24.
//  Copyright © 2018年 hjkl. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const HJRequestValidationErrorDomain;

/** Networking Status */
typedef NS_ENUM(NSUInteger, HJNetworkingStatus) {
    HJNetworkingStatusUnknown = 0,
    HJNetworkingStatusNotReachable,
    HJNetworkingStatusReachableViaWWAN,
    HJNetworkingStatusReachableViaWifi,
};
/** HTTP Request Method */
typedef NS_ENUM(NSUInteger, HJRequestMethod) {
    HJRequestMethodGET = 0,
    HJRequestMethodPOST,
    HJRequestMethodHEAD,
    HJRequestMethodDELETE,
    HJRequestMethodPATCH,
    HJRequestMethodPUT,
};
/** Request Serializer Type */
typedef NS_ENUM(NSUInteger, HJRequestSerializer) {
    HJRequestSerializerHTTP = 0,
    HJRequestSerializerJSON,
};
/** Response Object Type */
typedef NS_ENUM(NSUInteger, HJResponseSerializer) {
    HJResponseSerializerHTTP = 0,
    HJResponseSerializerJSON,
    HJResponseSerializerXML,
};

@protocol AFMultipartFormData;

typedef void(^AFConstructingBlock)(id<AFMultipartFormData> formData);
typedef void(^AFURLSessionTaskProgressBlock)(NSProgress *hj_progress);

@class HJBaseRequest;

typedef void(^HJRequestCompletionBlock)(__kindof HJBaseRequest *request);

@protocol HJRequestDelegate <NSObject>

@optional
- (void)requestFinished:(__kindof HJBaseRequest *)request;
- (void)requestFailed:(__kindof HJBaseRequest *)request;

@end

@interface HJBaseRequest : NSObject

@property (strong, nonatomic, readonly) NSURLSessionTask *requestTask;
@property (strong, nonatomic, readonly) NSURLRequest *currentRequest;
@property (strong, nonatomic, readonly) NSURLRequest *originalRequest;

@property (strong, nonatomic, readonly) NSHTTPURLResponse *response;
@property (nonatomic, readonly) NSInteger responseStatusCode;
@property (strong, nonatomic, readonly, nullable) NSDictionary *responseHeaders;
@property (strong, nonatomic, readonly, nullable) NSData *responseData;
@property (strong, nonatomic, readonly, nullable) NSString *responseString;
@property (strong, nonatomic, readonly, nullable) id responseObject;
@property (strong, nonatomic, readonly, nullable) id responseJSONObjc;
@property (strong, nonatomic, readonly, nullable) NSError *error;
@property (nonatomic, readonly, getter=isCacelled) BOOL cacelled;
@property (nonatomic, readonly, getter=isExecuting) BOOL executing;

@property (nonatomic) NSInteger tag;
@property (strong, nonatomic,  nullable) NSDictionary *userInfo;
@property (weak, nonatomic, nullable) id<HJRequestDelegate> delegate;
@property (copy, nonatomic, nullable) HJRequestCompletionBlock successCompletionBlock;
@property (copy, nonatomic, nullable) HJRequestCompletionBlock failureCompletionBlock;
@property (copy, nonatomic, nullable) AFConstructingBlock constructingBodyBlock;
@property (nonatomic, strong, nullable) NSString *resumableDownloadPath;
@property (nonatomic, copy, nullable) AFURLSessionTaskProgressBlock resumableDownloadProgressBlock;

- (void)setCompletionBlockWithSuccess:(nullable HJRequestCompletionBlock)success
                              failure:(nullable HJRequestCompletionBlock)failure;
- (void)start;
- (void)stop;
- (void)startWithCompletionBlockWithSuccess:(nullable HJRequestCompletionBlock)success failure:(nullable HJRequestCompletionBlock)failure;

- (void)clearCompletionBlock;
- (NSString *)baseUrl;
- (NSString *)requestUrl;
- (NSString *)cdnUrl;
- (NSTimeInterval)requestTimeoutInterval;
- (nullable id)requestArgument;
- (id)cacheFileNameFilterForRequestArgument:(id)argument;
- (HJRequestMethod)requestMethod;
- (HJRequestSerializer)requestSerializerType;
- (HJResponseSerializer)responseSerializerType;

- (nullable NSArray<NSString *>*)requestAuthorizationHeaderFieldArray;
- (nullable NSDictionary<NSString *, NSString *>*)requestHeaderFieldValueDictionary;
- (nullable NSURLRequest *)buildCustomUrlRequest;

- (BOOL)useCDN;
- (BOOL)allowsCellularAccess;
- (nullable id)jsonValidator;
- (BOOL)statusCodeValidator;

@end

NS_ASSUME_NONNULL_END
