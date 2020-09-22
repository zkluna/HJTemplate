//
//  UIViewController+Extend.m
//  kActivity
//
//  Created by rubick on 16/10/26.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import "UIViewController+Extend.h"
#import "UILabel+Extend.h"
#import "HJCommonLib.h"

@implementation UIViewController (Extend)

- (void)popToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)setNaviTitle:(NSString *)title withColor:(UIColor  *)color {
    UILabel *label = [UILabel naviLabelWithTitle:title color:color];
    CGFloat fontSize;
    if(isIphone4 || isIphone5) {
        fontSize = 17.0f;
    } else if(isIphone6) {
        fontSize = 18.0f;
    } else if(isIphone6plus) {
        fontSize = 20.0f;
    }
    label.font = [UIFont systemFontOfSize:fontSize];
    self.navigationItem.titleView = label;
}
- (void)popLastVCInStack {
    if(self.navigationController){
        if(self.navigationController.viewControllers.count > 1){
            NSMutableArray *temp = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [temp removeLastObject];
            self.navigationController.viewControllers = [temp copy];
        }
    }
}

- (void)popVCInStackReverseOrderIndex:(NSInteger)index {
    if(self.navigationController){
        NSInteger count = (NSInteger)self.navigationController.viewControllers.count;
        if(count > index){
            NSMutableArray *temp = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [temp removeObjectAtIndex:count-index];
            self.navigationController.viewControllers = [temp copy];
        }
    }
}
- (void)lf_customPopViewControllerAnimated:(BOOL)animated {
    if(self.navigationController){
        if([[self.navigationController.viewControllers lastObject] isKindOfClass:[self class]]){
            [self.navigationController popViewControllerAnimated:animated];
        } else {
            NSMutableArray *temp = [self.navigationController.viewControllers mutableCopy];
            [temp removeObject:self];
            self.navigationController.viewControllers = [temp copy];
        }
    }
}
- (UINavigationController *)hj_rootNavigationController {
    id rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    if([rootVC isKindOfClass:[UITabBarController class]]) {
        UIViewController *selectVC = [(UITabBarController *)rootVC selectedViewController];
        if([selectVC isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)selectVC;
        } else {
            return selectVC.navigationController;
        }
    } else if([rootVC isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)rootVC;
    } else {
        UIViewController *vc = (UIViewController *)rootVC;
        return vc.navigationController;
    }
}
+ (UIViewController *)getCurrentController {
    UIViewController *rootVC = _kMyWindow.rootViewController;
    return [self getCurrentVCFrom:rootVC];
}
+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        currentVC = rootVC;
    }
    return currentVC;
}

@end
