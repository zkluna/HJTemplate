//
//  UIViewController+HJNavigation.h
//  HJTemplate
//
//  Created by 曼殊 on 2021/2/26.
//  Copyright © 2021 hhh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (HJNavigation)

@property (assign, nonatomic) BOOL jt_screenPopGestureEnabled;
@property (weak, nonatomic) JTNavigationController *jt_navigationController;

@end

NS_ASSUME_NONNULL_END
