//
//  AppDelegate+Extend.m
//  kActivity
//
//  Created by rubick on 16/10/26.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import "AppDelegate+Extend.h"

@implementation AppDelegate (Extend)

+ (UIWindow *)getMainWindow {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return delegate.window;
}

@end
