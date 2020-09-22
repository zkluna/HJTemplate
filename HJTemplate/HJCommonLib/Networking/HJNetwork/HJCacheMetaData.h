//
//  HJCacheMetaData.h
//  HKProject
//
//  Created by rubick on 2018/7/29.
//  Copyright © 2018年 hjkl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJCacheMetaData : NSObject<NSSecureCoding>

@property (assign, nonatomic) long long version;
@property (strong, nonatomic) NSString *sensitiveDataString;
@property (assign, nonatomic) NSStringEncoding stringEncoding;
@property (strong, nonatomic) NSDate *creationDate;
@property (strong, nonatomic) NSString *appVersion;

@end
