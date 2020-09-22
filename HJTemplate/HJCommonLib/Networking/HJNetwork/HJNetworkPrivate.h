//
//  HJNetworkPrivate.h
//  HKProject
//
//  Created by rubick on 2018/7/27.
//  Copyright © 2018年 hjkl. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HJBaseRequest.h"
#import "HJNetworkAgent.h"

NS_ASSUME_NONNULL_BEGIN

@class AFHTTPSessionManager;

@interface HJBaseRequest (Setter)

@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;
@property (nonatomic, strong, readwrite, nullable) NSData *responseData;
@property (nonatomic, strong, readwrite, nullable) id responseJSONObject;
@property (nonatomic, strong, readwrite, nullable) id responseObject;
@property (nonatomic, strong, readwrite, nullable) NSString *responseString;
@property (nonatomic, strong, readwrite, nullable) NSError *error;

@end

@interface HJNetworkAgent (Private)

- (AFHTTPSessionManager *)manager;
- (void)resetURLSessionManager;
- (void)resetURLSessionManagerWithConfiguration:(NSURLSessionConfiguration *)configuration;
- (NSString *)incompleteDownloadTempCacheFolder;

@end

NS_ASSUME_NONNULL_END
