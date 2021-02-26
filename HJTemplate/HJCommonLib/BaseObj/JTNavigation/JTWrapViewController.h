//
//  JTWrapViewController.h
//  HJTemplate
//
//  Created by 曼殊 on 2021/2/26.
//  Copyright © 2021 hhh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTWrapViewController : UIViewController

@property (strong, nonatomic, readonly) UIViewController *rootViewController;
+ (JTWrapViewController *)wrapViewControllerWithViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
