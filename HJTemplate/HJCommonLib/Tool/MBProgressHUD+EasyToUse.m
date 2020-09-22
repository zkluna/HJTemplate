//
//  MBProgressHUD+EasyToUse.m
//  HJTemplate
//
//  Created by rubick on 2018/11/16.
//  Copyright © 2018 LG. All rights reserved.
//

#import "MBProgressHUD+EasyToUse.h"

@implementation MBProgressHUD (EasyToUse)

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error onView:(nullable UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *tempView = view;
        if (!tempView) {
            tempView = [UIApplication sharedApplication].keyWindow;
        }
        __block MBProgressHUD *hud = [self HUDForView:tempView];
        if (hud) {
            [hud hideAnimated:YES];
        }
        hud = [[MBProgressHUD alloc] initWithView:tempView];
        hud.label.textColor = [UIColor whiteColor];
        hud.customView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        hud.removeFromSuperViewOnHide = YES;
        [tempView addSubview:hud];
        
        // Set the custom view mode to show any view.
        hud.mode = MBProgressHUDModeText;
        // Set an image view with a checkmark.
        //        UIImage *image = [[UIImage imageNamed:@"shop-setting_icon_close_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        //        hud.customView = [[UIImageView alloc] initWithImage:image];
        // Looks a bit nicer if we make it square.
        //        hud.square = YES;
        // Optional label text.
        //        hud.label.text = error;
        hud.detailsLabel.text = error;
        hud.detailsLabel.font = [UIFont boldSystemFontOfSize:15];
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:1.5];
    });
}
+ (void)showWarnMsg:(NSString *)msg onView:(nullable UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *tempView = view;
        if (!tempView) {
            tempView = [UIApplication sharedApplication].keyWindow;
        }
        __block MBProgressHUD *hud = [self HUDForView:tempView];
        if (hud) {
            [hud hideAnimated:YES];
        }
        hud = [[MBProgressHUD alloc] initWithView:tempView];
        hud.label.textColor = [UIColor whiteColor];
        hud.customView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        hud.removeFromSuperViewOnHide = YES;
        [tempView addSubview:hud];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = msg;
        hud.detailsLabel.font = [UIFont boldSystemFontOfSize:15];
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:1.5];
    });
}
#pragma mark 显示一些信息

+ (void)showSuccess:(NSString *)success onView:(nullable UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *tempView = view;
        if (!tempView) {
            tempView = [UIApplication sharedApplication].keyWindow;
        }
        __block MBProgressHUD *hud = [self HUDForView:tempView];
        if (hud) {
            [hud hideAnimated:YES];
        }
        hud = [[MBProgressHUD alloc] initWithView:tempView];
        hud.label.textColor = [UIColor whiteColor];
        hud.customView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        hud.removeFromSuperViewOnHide = YES;
        [tempView addSubview:hud];
        // Set the custom view mode to show any view.
        hud.mode = MBProgressHUDModeText;
        // Set an image view with a checkmark.
        //        UIImage *image = [[UIImage imageNamed:@"shop-setting_icon_close_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        //        hud.customView = [[UIImageView alloc] initWithImage:image];
        // Looks a bit nicer if we make it square.
        //        hud.square = YES;
        // Optional label text.
        hud.detailsLabel.text = success;
        hud.detailsLabel.font = [UIFont boldSystemFontOfSize:15];
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:1.5f];
    });
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        if (!hud) {
    //            hud = [[MBProgressHUD alloc] initWithView:view];
    //            hud.removeFromSuperViewOnHide = NO;
    //            [view addSubview:hud];
    //        }
    //        // Set the custom view mode to show any view.
    //        hud.mode = MBProgressHUDModeText;
    //        // Set an image view with a checkmark.
    //        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //        hud.customView = [[UIImageView alloc] initWithImage:image];
    //        // Looks a bit nicer if we make it square.
    //        hud.square = YES;
    //        // Optional label text.
    //        hud.label.text = success;
    //        [hud showAnimated:YES];
    //
    //        [hud hideAnimated:YES afterDelay:3.f];
    //    });
}

+ (void)showSuccess:(NSString *)success onView:(nullable UIView *)view andCompleteAction:(void (^)(void))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *tempView = view;
        if (!tempView) {
            tempView = [UIApplication sharedApplication].keyWindow;
        }
        __block MBProgressHUD *hud = [self HUDForView:tempView];
        if (hud) {
            [hud hideAnimated:YES];
        }
        hud = [[MBProgressHUD alloc] initWithView:tempView];
        hud.customView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        hud.label.textColor = [UIColor whiteColor];
        hud.removeFromSuperViewOnHide = YES;
        [tempView addSubview:hud];
        
        // Set the custom view mode to show any view.
        hud.mode = MBProgressHUDModeText;
        // Set an image view with a checkmark.
        //        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        //        hud.customView = [[UIImageView alloc] initWithImage:image];
        // Looks a bit nicer if we make it square.
        //        hud.square = YES;
        // Optional label text.
        hud.detailsLabel.text = success;
        hud.detailsLabel.font = [UIFont boldSystemFontOfSize:15];
        [hud setCompletionBlock:^{
            if (completion) {
                completion();
            }
        }];
        [hud showAnimated:YES];
        
        [hud hideAnimated:YES afterDelay:1.5f];
    });
}

+ (void)showMessage:(nullable NSString *)message onView:(nullable UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *tempView = view;
        if (!tempView) {
            tempView = [UIApplication sharedApplication].keyWindow;
        }
        __block MBProgressHUD *hud = [self HUDForView:tempView];
        if (hud) {
            [hud hideAnimated:YES];
        }
        hud = [[MBProgressHUD alloc] initWithView:tempView];
        hud.customView.backgroundColor = [UIColor blackColor];//[[UIColor blackColor] colorWithAlphaComponent:0.8];
        hud.label.textColor = [UIColor whiteColor];
        hud.removeFromSuperViewOnHide = YES;
        [tempView addSubview:hud];
        // Set the label text.
        hud.label.text = message;
        [hud showAnimated:YES];
    });
}

+ (void)showProgress:(CGFloat)progress status:(NSString *)status onView:(nullable UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *tempView = view;
        if (!tempView) {
            tempView = [UIApplication sharedApplication].keyWindow;
        }
        __block MBProgressHUD *hud = [self HUDForView:tempView];
        if (hud && hud.mode != MBProgressHUDModeDeterminate) {
            [hud hideAnimated:YES];
        } else {
            hud.progress = progress;
            return;
        }
        hud = [[MBProgressHUD alloc] initWithView:tempView];
        hud.customView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        hud.label.textColor = [UIColor whiteColor];
        hud.removeFromSuperViewOnHide = YES;
        [tempView addSubview:hud];
        hud.mode = MBProgressHUDModeDeterminate;
        hud.label.text = status;
        hud.progress = progress;
        [hud showAnimated:YES];
    });
}
+ (void)hideHUDForView:(nullable UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication] keyWindow];
    MBProgressHUD *hud = [self HUDForView:view];
    if (hud) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (hud != nil) {
                hud.removeFromSuperViewOnHide = YES;
                [hud hideAnimated:YES];
            }
        });
    }
}

@end
