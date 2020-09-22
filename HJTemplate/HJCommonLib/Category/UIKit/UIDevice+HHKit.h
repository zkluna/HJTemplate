//
//  UIDevice+HHKit.h
//  HKProject
//
//  Created by apple on 2017/3/22.
//  Copyright © 2017年 hjkl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (HHKit)

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

- (float)iOSVersion;

+ (NSNumber * _Nonnull)totalDiskSpace;
+ (NSNumber * _Nonnull)freeDiskSpace;

+ (NSString * _Nonnull)UUID;

@end
