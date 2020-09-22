//
//  MBProgressHUD+EasyToUse.h
//  HJTemplate
//
//  Created by rubick on 2018/11/16.
//  Copyright © 2018 LG. All rights reserved.
//

#import <MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (EasyToUse)

+ (void)showError:(NSString *)error onView:(nullable UIView *)view;

+ (void)showSuccess:(NSString *)success onView:(nullable UIView *)view andCompleteAction:(void(^)(void))completion;
+ (void)showSuccess:(NSString *)success onView:(nullable UIView *)view;

+ (void)showWarnMsg:(NSString *)msg onView:(nullable UIView *)view;
+ (void)showMessage:(nullable NSString *)message onView:(nullable UIView *)view;

+ (void)hideHUDForView:(nullable UIView *)view;

+ (void)showProgress:(CGFloat)progress
              status:(NSString *)status
              onView:(nullable UIView *)view;

@end

NS_ASSUME_NONNULL_END
