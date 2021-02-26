//
//  JTWrapNavigationController.m
//  HJTemplate
//
//  Created by 曼殊 on 2021/2/26.
//  Copyright © 2021 hhh. All rights reserved.
//

#import "JTWrapNavigationController.h"
#import "JTNavigationController.h"
#import "UIViewController+HJNavigation.h"

#define kDefaultBackImage @"backImage"

@implementation JTWrapNavigationController

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    return [self.navigationController popViewControllerAnimated:animated];
}
- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    return [self.navigationController popToRootViewControllerAnimated:animated];
}
- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    JTNavigationController *jtNavigationController = viewController.jt_navigationController;
    NSInteger index = [jtNavigationController.jt_viewControllers indexOfObject:viewController];
    return [self.navigationController popToViewController:jtNavigationController.viewControllers[index] animated:animated];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.jt_navigationController = (JTNavigationController *)self.navigationController;
    viewController.jt_screenPopGestureEnabled = viewController.jt_navigationController.screenPopGestureEnabled;
    UIImage *backBtnImage = viewController.jt_navigationController.backBtnImage;
    if (!backBtnImage) {
        backBtnImage = [UIImage imageNamed:kDefaultBackImage];
    }
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backBtnImage style:UIBarButtonItemStylePlain target:self action:@selector(didTapBackButton)];
    [self.navigationController pushViewController:[JTWrapViewController wrapViewControllerWithViewController:viewController] animated:animated];
}
- (void)didTapBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    [self.navigationController dismissViewControllerAnimated:flag completion:completion];
    self.viewControllers.firstObject.jt_navigationController=nil;
}

@end
