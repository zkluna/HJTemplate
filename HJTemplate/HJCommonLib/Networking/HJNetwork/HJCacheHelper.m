//
//  HJPathHelper.m
//  HKProject
//
//  Created by rubick on 2018/7/29.
//  Copyright © 2018年 hjkl. All rights reserved.
//

#import "HJCacheHelper.h"
#import <CommonCrypto/CommonDigest.h>
#import "HJCacheMetaData.h"

@implementation HJCacheHelper

@end

@implementation HJPathHelper

+ (NSString *)hj_requestCacheBasePath {
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [pathOfLibrary stringByAppendingPathComponent:@"HJ_Request_Cache"];
    [self createDirectoryIfNeeded:path];
    return path;
}
+ (void)createDirectoryIfNeeded:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if(![fileManager fileExistsAtPath:path isDirectory:&isDir]){
        [self createBaseDirectoryAtPath:path];
    } else {
        if(!isDir){
            NSError *error = nil;
            [fileManager removeItemAtPath:path error:&error];
            [self createBaseDirectoryAtPath:path];
        }
    }
}
+ (void)createBaseDirectoryAtPath:(NSString *)path {
    NSError * error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    if(error){
        NSLog(@"create cache directory failed, error = %@",error);
    } else {
        [HJPathHelper addDoNotBackupAttribute:path];
    }
}
+ (void)addDoNotBackupAttribute:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if(error){
        NSLog(@"Error to set do not backup attribute, error = %@",error);
    }
}
+ (NSString *)md5StringFromString:(NSString *)string {
    NSParameterAssert(string != nil && [string length] > 0);
    const char *value = [string UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}

@end

@implementation HJAppInfoTool

+ (NSString *)appVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

@end
