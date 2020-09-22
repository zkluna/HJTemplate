//
//  HJPathHelper.h
//  HKProject
//
//  Created by rubick on 2018/7/29.
//  Copyright © 2018年 hjkl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJCacheHelper : NSObject

@end

@interface HJPathHelper : NSObject

+ (NSString *)hj_requestCacheBasePath;

+ (void)createDirectoryIfNeeded:(NSString *)path;

/** 设置缓存不备份到iCloud */
+ (void)addDoNotBackupAttribute:(NSString *)path;

/** 对文件名做md5处理 */
+ (NSString *)md5StringFromString:(NSString *)string;

@end

@interface HJAppInfoTool : NSObject

+ (NSString *)appVersion;

@end
