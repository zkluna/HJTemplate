//
//  CacheDataManager.m
//  LaoTieWallet
//
//  Created by rubick on 2018/11/7.
//  Copyright © 2018 LG. All rights reserved.
//

#import "CacheDataManager.h"
#import "HJCommonLib.h"
#import "UIImage+Extend.h"

@implementation CacheDataManager

+ (NSString *)getUserDefaultFolderWithUserId:(nullable NSString *)userId {
    NSString *defaultFolder = [_kPathDocument stringByAppendingPathComponent:@"defaultUser"];
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDir = YES;
    if(![manager fileExistsAtPath:defaultFolder isDirectory:&isDir]){
        NSError *error = nil;
        [manager createDirectoryAtPath:defaultFolder withIntermediateDirectories:YES attributes:nil error:&error];
        if(error){
            return nil;
        } else {
            return defaultFolder;
        }
    } else {
        return defaultFolder;
    }
}
+ (NSString *)cacheADImagePath {
    NSString *defaultDir = [self getUserDefaultFolderWithUserId:nil];
    if(defaultDir == nil){
        return nil;
    } else {
        NSString *imagePath = [defaultDir stringByAppendingPathComponent:@"/AdCacheImage"];
        return imagePath;
    }
}
+ (NSString *)offLineImageFileFolder {
    NSString *defalutDir = [self getUserDefaultFolderWithUserId:nil];
    if(defalutDir == nil){
        return nil;
    }
    NSString *folderForImage = [defalutDir stringByAppendingPathComponent:@"/AD_Image"];
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDir = YES;
    if(![manager fileExistsAtPath:folderForImage isDirectory:&isDir]){
        NSError *error = nil;
        [manager createDirectoryAtPath:folderForImage withIntermediateDirectories:YES attributes:nil error:&error];
        if(error){
            return nil;
        } else {
            return folderForImage;
        }
    } else {
        return folderForImage;
    }
}

@end
