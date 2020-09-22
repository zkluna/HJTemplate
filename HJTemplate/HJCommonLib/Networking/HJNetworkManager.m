//
//  HJNetworkManager.m
//  newRn
//
//  Created by rubick on 2019/7/10.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "HJNetworkManager.h"
#import "HJNetworkConfig.h"

@implementation HJNetworkManager

+ (void)configNetworking {
  HJNetworkConfig *config = [HJNetworkConfig shareConfig];
  config.baseUrl = @"https://www.apiopen.top";
#ifdef DEBUG
  config.debugLogEnabled = YES;
#endif
}
+ (HJNetworkManager *)shareHJNetworkManager {
  static HJNetworkManager *shareNetworkMgr = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    shareNetworkMgr = [[HJNetworkManager alloc] init];
  });
  return shareNetworkMgr;
}

- (void)startNetworkingMonitoring {
  AFNetworkReachabilityManager *reachabilityMgr = [AFNetworkReachabilityManager sharedManager];
  [reachabilityMgr startMonitoring];
  [reachabilityMgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    self.networkStatus = status;
    switch (status) {
      case AFNetworkReachabilityStatusUnknown:
        self.isNetworkReachable = @(NO);
        break;
      case AFNetworkReachabilityStatusNotReachable:
        self.isNetworkReachable = @(NO);
        break;
      case AFNetworkReachabilityStatusReachableViaWiFi:
        self.isNetworkReachable = @(YES);
        break;
      case AFNetworkReachabilityStatusReachableViaWWAN:
        self.isNetworkReachable = @(YES);
        break;
      default:
        break;
    }
  }];
}
- (void)stopNetworkingMonitoring {
  [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

+ (void)configForHTTPS {
  NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"xxx" ofType:@"pem"];
  NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
  
  AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
  securityPolicy.allowInvalidCertificates = YES;
  securityPolicy.validatesDomainName = YES;
  securityPolicy.pinnedCertificates = [NSSet setWithObject:cerData];
  [[HJNetworkConfig shareConfig] setSecurityPolicy:securityPolicy];
}

@end
