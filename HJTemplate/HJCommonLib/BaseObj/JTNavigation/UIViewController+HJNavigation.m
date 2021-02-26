//
//  UIViewController+HJNavigation.m
//  HJTemplate
//
//  Created by 曼殊 on 2021/2/26.
//  Copyright © 2021 hhh. All rights reserved.
//

#import "UIViewController+HJNavigation.h"
#import <objc/runtime.h>

@implementation UIViewController (HJNavigation)

- (BOOL)jt_screenPopGestureEnabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setJt_screenPopGestureEnabled:(BOOL)jt_screenPopGestureEnabled {
    objc_setAssociatedObject(self, @selector(jt_screenPopGestureEnabled), @(jt_screenPopGestureEnabled), OBJC_ASSOCIATION_RETAIN);
}
- (JTNavigationController *)jt_navigationController {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setJt_navigationController:(JTNavigationController *)jt_navigationController {
    objc_setAssociatedObject(self, @selector(jt_navigationController), jt_navigationController, OBJC_ASSOCIATION_ASSIGN);
}
@end
