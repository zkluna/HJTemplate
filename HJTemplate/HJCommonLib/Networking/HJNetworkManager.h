//
//  HJNetworkManager.h
//  newRn
//
//  Created by rubick on 2019/7/10.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJNetworkManager : NSObject

@property (strong, nonatomic) NSNumber *isNetworkReachable;
@property (unsafe_unretained, nonatomic) AFNetworkReachabilityStatus networkStatus;

+ (void)configNetworking;
+ (HJNetworkManager *)shareHJNetworkManager;

- (void)startNetworkingMonitoring;
- (void)stopNetworkingMonitoring;

@end

NS_ASSUME_NONNULL_END
