//
//  JTWrapViewController.m
//  HJTemplate
//
//  Created by 曼殊 on 2021/2/26.
//  Copyright © 2021 hhh. All rights reserved.
//

#import "JTWrapViewController.h"
#import "JTNavigationController.h"
#import "JTWrapNavigationController.h"
#import "UIViewController+HJNavigation.h"

static NSValue *jt_tabBarRectValue;
@interface JTWrapViewController ()

@end

@implementation JTWrapViewController

- (JTWrapViewController *)wrapViewControllerWithViewController:(UIViewController *)viewController {
    JTWrapNavigationController *wrapNavController = [[JTWrapNavigationController alloc] init];
    wrapNavController.viewControllers = @[viewController];
    JTWrapViewController *wrapViewController = [[JTWrapViewController alloc] init];
    [wrapViewController.view addSubview:wrapNavController.view];
    [wrapViewController addChildViewController:wrapNavController];
    return wrapViewController;
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.tabBarController && !jt_tabBarRectValue) {
        jt_tabBarRectValue = [NSValue valueWithCGRect:self.tabBarController.tabBar.frame];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.tabBarController && [self rootViewController].hidesBottomBarWhenPushed) {
        self.tabBarController.tabBar.frame = CGRectZero;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.translucent = YES;
    if (self.tabBarController && !self.tabBarController.tabBar.hidden && jt_tabBarRectValue) {
        self.tabBarController.tabBar.frame = jt_tabBarRectValue.CGRectValue;
    }
}
- (BOOL)jt_screenPopGestureEnabled {
    return [self rootViewController].jt_screenPopGestureEnabled;
}
- (BOOL)hidesBottomBarWhenPushed {
    return [self rootViewController].hidesBottomBarWhenPushed;
}

@end
