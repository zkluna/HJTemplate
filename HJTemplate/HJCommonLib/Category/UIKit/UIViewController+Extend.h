//
//  UIViewController+Extend.h
//  kActivity
//
//  Created by rubick on 16/10/26.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extend)

- (void)popToRoot;

- (void)setNaviTitle:(NSString *)title withColor:(UIColor  *)color;

- (void)popLastVCInStack;

/** 移除navigation中倒数第index个VC */
- (void)popVCInStackReverseOrderIndex:(NSInteger)index;

- (void)lf_customPopViewControllerAnimated:(BOOL)animated;

- (UINavigationController *)hj_rootNavigationController;

+ (UIViewController *)getCurrentController;

- (void)showAlertWithMessage:(NSString *)message action:(void(^)(void))setAction;

@end
