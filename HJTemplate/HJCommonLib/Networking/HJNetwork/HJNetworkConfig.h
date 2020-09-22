//
//  HJNetworkConfig.h
//  HKProject
//
//  Created by rubick on 2018/7/27.
//  Copyright © 2018年 hjkl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HJBaseRequest;
@class AFSecurityPolicy;

@interface HJNetworkConfig : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (HJNetworkConfig *)shareConfig;

@property (strong, nonatomic) NSString *baseUrl;
@property (strong, nonatomic) NSString *cdnUrl;
@property (strong, nonatomic) AFSecurityPolicy *securityPolicy;
@property (nonatomic) BOOL debugLogEnabled;
@property (strong, nonatomic) NSURLSessionConfiguration *sessionConfiguration;

@end

NS_ASSUME_NONNULL_END
