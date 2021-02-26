//
//  HJNavigationController.m
//  newRn
//
//  Created by rubick on 2019/7/12.
//  Copyright © 2019 hjkl. All rights reserved.
//

#import "HJNavigationController.h"
#import "UIImage+Extend.h"

@interface HJNavigationController () <UIGestureRecognizerDelegate>
@end

@implementation HJNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpConfig];
    self.navigationBar.translucent = NO;
//    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forBarMetrics:UIBarMetricsDefault];
}
- (void)setUpConfig {
      id target = self.interactivePopGestureRecognizer.delegate;
      SEL handleTransition = NSSelectorFromString(@"handleNavigationTransition:");
      UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:handleTransition];
      pan.delegate = self;
      [self.view addGestureRecognizer:pan];
      self.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
      if(self.childViewControllers.count == 1 || self.forbiddenPanGesture) { return NO; }
      CGPoint point = [gestureRecognizer locationInView:self.view];
      if(point.x > MAX(50, 50)) { return NO; }
      return YES;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
      if(self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
      }
      [super pushViewController:viewController animated:animated];
}

@end
