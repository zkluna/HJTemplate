//
//  LTLaunchADTool.m
//  LaoTieWallet
//
//  Created by rubick on 2018/11/7.
//  Copyright © 2018 LG. All rights reserved.
//

#import "LTLaunchADTool.h"
#import "CacheDataManager.h"
#import "SDWebImageDownloader.h"
#import "MBProgressHUD+EasyToUse.h"
#import "HJCustomTabBarC.h"
#import "HJNetworkingTool.h"
#import "LTLaunchAdVC.h"

@implementation LTLaunchADTool

+ (void)switchRootControllerToMainVCAnimation:(BOOL)isAnimation {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(isAnimation){
            [UIView transitionWithView:UIApplication.sharedApplication.delegate.window duration:0.4 options:UIViewAnimationOptionTransitionCurlUp animations:^{
                BOOL oldState = [UIView areAnimationsEnabled];
                [UIView setAnimationsEnabled:NO];
                [self setupRootViewController];
                [UIView setAnimationsEnabled:oldState];
            } completion:^(BOOL finished) {}];
        } else {
            [self setupRootViewController];
        }
    });
}
+ (void)setupRootViewController {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isLog"]){
        HJCustomTabBarC *tabtabVc=[[HJCustomTabBarC alloc] init];
        UIApplication.sharedApplication.delegate.window.rootViewController = tabtabVc;;
    } else {
        // 创建tabBarVc
        NSString *loginVCName = @"LTLoginVC";
        if(NSClassFromString(loginVCName)){
            UIViewController *vc = (UIViewController *)[[NSClassFromString(loginVCName) alloc] init];
            UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
            UIApplication.sharedApplication.delegate.window.rootViewController = navVC;
        } else {
            [MBProgressHUD showError:@"登录页面类名错误" onView:nil];
        }
    }
}
+ (void)downloadADImage {
    NSString *url = @"";
    [HJNetworkingTool postWithSessionManager:nil URL:url paramaters:@{} success:^(id responseObject) {
        NSString *adImageURLString = responseObject[@"data"][@"startupPageTwo"];
        if(adImageURLString){
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:adImageURLString] options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                if(image){
                    NSString *adImagePath = [CacheDataManager cacheADImagePath];
                    if([NSFileManager.defaultManager fileExistsAtPath:adImagePath]){
                        [NSFileManager.defaultManager removeItemAtPath:adImagePath error:nil];
                    }
                    [UIImagePNGRepresentation(image) writeToFile:adImagePath atomically:YES];
                }
            }];
        }
    } failure:^(NSError *error) {
        
    } progress:nil];
}

+ (UIImage *)getCacheADImage {
    NSString *adImgPath = [CacheDataManager cacheADImagePath];
    if([NSFileManager.defaultManager fileExistsAtPath:adImgPath]){
        UIImage *adImage = [[UIImage alloc] initWithContentsOfFile:adImgPath];
        return adImage;
    } else {
        return [UIImage imageNamed:@"adImage_normal"];
//        return nil;
    }
}
+ (void)checkIfShowADController {
    UIImage *image = [self getCacheADImage];
    if(image){
        LTLaunchAdVC *vc = [[LTLaunchAdVC alloc] init];
        vc.launcheImage = image;
        UIApplication.sharedApplication.delegate.window.rootViewController = vc;
    } else {
        [self setupRootViewController];
        [LTLaunchADTool downloadADImage];
    }
}

@end
