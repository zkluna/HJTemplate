//
//  UIDevice+HHKit.m
//  HKProject
//
//  Created by apple on 2017/3/22.
//  Copyright © 2017年 hjkl. All rights reserved.
//

#import "UIDevice+HHKit.h"

@implementation UIDevice (HHKit)

- (float)iOSVersion {
    return [[[UIDevice currentDevice] systemVersion ] floatValue];
}
- (NSNumber * _Nonnull)totalDiskSpace {
    NSDictionary *attribute = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [attribute objectForKey:NSFileSystemSize];
}
- (NSNumber * _Nonnull)freeDiskSpace {
    NSDictionary *attribute = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [attribute objectForKey:NSFileSystemFreeSize];
}
+ (NSString * _Nonnull)UUID {
    NSString *UUIDStr;
    if([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]){
        UUIDStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        UUIDStr = [defaults stringForKey:@"BFUniqueIdentifier"];
        if(!UUIDStr){
            CFUUIDRef theUUID = CFUUIDCreate(NULL);
            CFStringRef string = CFUUIDCreateString(NULL, theUUID);
            CFRelease(theUUID);
            UUIDStr = (__bridge_transfer NSString *)string;
            [defaults setObject:UUIDStr forKey:@"BFUniqueIdentifier"];
            [defaults synchronize];
        }
    }
    return UUIDStr;
}

@end
