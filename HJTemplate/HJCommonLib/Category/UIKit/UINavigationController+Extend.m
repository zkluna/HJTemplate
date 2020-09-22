//
//  UINavigationController+Extend.m
//  kActivity
//
//  Created by rubick on 2016/11/18.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import "UINavigationController+Extend.h"

@implementation UINavigationController (Extend)

- (void)setBackgroundColor:(UIColor *)bgcolor textColor:(UIColor *)textcolor {
    if(!self.viewControllers.count) return;
    self.navigationBar.translucent = NO;
    if([[UIDevice currentDevice] systemVersion].floatValue > 7.0){
        self.navigationBar.barTintColor = bgcolor;
        self.navigationBar.tintColor = textcolor;
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:textcolor};
    } else {
        self.navigationBar.tintColor = bgcolor;
    }
}
- (void)autoHidden {
    self.hidesBarsOnSwipe = YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}
- (UIViewController *)popToViewControllerOfClass:(Class)cls animated:(BOOL)animated {
    return [self popToViewControllerOfClass:cls animated:animated competion:nil];
}
- (UIViewController *)popToViewControllerOfClass:(Class)cls animated:(BOOL)animated competion:(void(^)(void))completion {
    UIViewController *viewController = nil;
    for(UIViewController *controller in self.viewControllers){
        if([controller isKindOfClass:cls]){
            if(completion){
                NSTimeInterval delay = animated ? 0.2 : 0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_global_queue(0, 0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion();
                    });
                });
            }
            [self popToViewController:controller animated:animated];
            viewController = controller;
            break;
        }
    }
    if(!viewController) {
        viewController = [self popViewControllerAnimated:animated];
    }
    return viewController;
}
@end
