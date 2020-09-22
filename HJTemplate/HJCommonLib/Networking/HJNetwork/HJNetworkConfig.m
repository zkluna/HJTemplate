//
//  HJNetworkConfig.m
//  HKProject
//
//  Created by rubick on 2018/7/27.
//  Copyright © 2018年 hjkl. All rights reserved.
//

#import "HJNetworkConfig.h"
#import "HJBaseRequest.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

@implementation HJNetworkConfig

+ (HJNetworkConfig *)shareConfig {
    static id shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}
- (instancetype)init {
    self = [super init];
    if(self) {
        _baseUrl = @"";
        _cdnUrl = @"";
        _securityPolicy = [AFSecurityPolicy defaultPolicy];
        _debugLogEnabled = NO;
    }
    return self;
}

@end
