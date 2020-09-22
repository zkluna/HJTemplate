//
//  HJRequest.h
//  HKProject
//
//  Created by rubick on 2018/7/27.
//  Copyright © 2018年 hjkl. All rights reserved.
//

#import "HJBaseRequest.h"
#import "HJNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const HJRequestCacheErrorDomain;

NS_ENUM(NSInteger) {
    HJRequestCacheErrorExpired = -1,
    HJRequestCacheErrorVersionMismatch = -2,
    HJRequestCacheErrorSensitiveDataMismatch = -3,
    HJRequestCacheErrorAppVersionMismatch = -4,
    HJRequestCacheErrorInvalidCacheTime = -5,
    HJRequestCacheErrorInvalidMetadata = -6,
    HJRequestCacheErrorInvalidCacheData = -7,
    HJRequestNoNetworkConnectError =  -8,
    HJRequestUnknownError = -9,
};

@interface HJRequest : HJBaseRequest

@property (nonatomic) BOOL isNeedCache;

- (BOOL)loadCacheWithError:(NSError * __autoreleasing *)error;
- (void)startWithoutCache;
- (void)saveResponseDataToCacheFile:(NSData *)data;
//- (NSInteger)cacheTimeInSeconds;
- (long long)cacheVersion;
- (nullable id)cacheSensitiveData;

- (void)startRequestWithCompletionSuccess:(nullable void(^)(id responseObject))success failure:(nullable void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
