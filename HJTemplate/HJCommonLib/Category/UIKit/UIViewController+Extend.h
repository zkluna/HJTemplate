//
//  UIViewController+Extend.h
//  kActivity
//
//  Created by rubick on 16/10/26.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extend)

/**  push/pop */
- (void)popToRoot;
/**  custom navigation */
- (void)setNaviTitle:(NSString *)title withColor:(UIColor  *)color;

- (void)popLastVCInStack;

/** 移除navigation中倒数第index个VC */
- (void)popVCInStackReverseOrderIndex:(NSInteger)index;

/**
 *  - 自定义pop
 *  如果是navigationController中最后一个就pop，不是则从栈中移除)
 *  主要解决目前弹框提示没有跟VC绑定，直接用window实现的。
 而有些界面提交数据后要立即pop返回，此时刚好推送来了会造成pop失败
 */
- (void)lf_customPopViewControllerAnimated:(BOOL)animated;

- (UINavigationController *)hj_rootNavigationController;

+ (UIViewController *)getCurrentController;


@end
