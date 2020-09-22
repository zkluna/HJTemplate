//
//  BaseViewController.h
//  HJTemplate
//
//  Created by zhaoke on 2019/1/25.
//  Copyright © 2019 LG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

@property (weak, nonatomic) AFHTTPSessionManager *sessionManager;
@property (readonly, strong, nonatomic) UIBarButtonItem *rightBtnItem;
@property (readonly, strong, nonatomic) UIBarButtonItem *leftBtnItem;

#pragma mark - 自定义navgaiton barItem 放在NavigationBar上
- (void)hj_setCustomTitle:(NSString *)title;
- (void)hj_setCustomRightItemTile:(NSString *)title;
- (void)hj_setCustomRightItemImage:(UIImage *)image;
- (void)hj_setCustomLeftItemTitle:(NSString *)title;
- (void)hj_setCustomLeftItemImage:(UIImage *)Image;
- (void)hj_customLeftItemAction:(id)sender;
- (void)hj_customRightItemAction:(id)sender;

#pragma mark - 系统NavigationBarItem 设置
- (void)setLeftItemTitle:(NSString *)title;
- (void)setLeftItemImage:(UIImage *)image;

- (void)setRightItemTitle:(NSString *)title;
- (void)setRightItemImage:(UIImage *)image;

- (void)addLeftItemTitle:(NSString *)title;
- (void)addLeftItemImage:(UIImage *)image;

- (void)addRightItemTitle:(NSString *)title;
- (void)addRightItemImage:(UIImage *)image;

- (void)leftItemAction:(id)sender;
- (void)rightItemAction:(id)sender;

- (void)showErrorPromptActionWithError:(NSError *)error;

- (BOOL)shouldBePoppedFromNavigation:(UINavigationController *)navigation;
- (void)willBePoppedFromNavigation:(UINavigationController *)navigation;

@end

NS_ASSUME_NONNULL_END
