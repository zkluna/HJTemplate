//
//  UITabBar+hj_badge.m
//  YoutilN
//
//  Created by rubick on 2019/3/29.
//  Copyright © 2019 kl. All rights reserved.
//

#import "UITabBar+hj_badge.h"
#define TabbarItemNums 4.0

@implementation UITabBar (hj_badge)

- (void)showBadgeOnItemIndex:(int)index {
    //移除之前的小红点
//    [self removeBadgeOnItemIndex:index];
    UIView *red = [self viewWithTag:888+index];
    if(red){
        return;
    }
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 3.5;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;
    //确定小红点的位置
    float percentX = (index +0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
//    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, 5, 7, 7);
    [self addSubview:badgeView];
}
- (void)hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}
- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end
