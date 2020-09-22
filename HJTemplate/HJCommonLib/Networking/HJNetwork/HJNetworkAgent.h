//
//  HJNetworkAgent.h
//  HKProject
//
//  Created by rubick on 2018/7/27.
//  Copyright © 2018年 hjkl. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HJBaseRequest;

NS_ASSUME_NONNULL_BEGIN

@interface HJNetworkAgent : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

+ (HJNetworkAgent *)shareAgent;
- (void)addRequest:(HJBaseRequest *)request;
- (void)cancelRequest:(HJBaseRequest *)request;
- (void)cancelAllRequests;
- (NSString *)buildRequestUrl:(HJBaseRequest *)request;

@end

NS_ASSUME_NONNULL_END
