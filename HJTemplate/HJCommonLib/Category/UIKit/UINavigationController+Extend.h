//
//  UINavigationController+Extend.h
//  kActivity
//
//  Created by rubick on 2016/11/18.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Extend)

- (void)autoHidden;
- (void)setBackgroundColor:(UIColor *)bgcolor textColor:(UIColor *)textcolor;
- (UIViewController *)popToViewControllerOfClass:(Class)cls animated:(BOOL)animated;
- (UIViewController *)popToViewControllerOfClass:(Class)cls animated:(BOOL)animated competion:(void(^)(void))completion;
@end
