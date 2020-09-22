//
//  UITabBar+hj_badge.h
//  YoutilN
//
//  Created by rubick on 2019/3/29.
//  Copyright © 2019 kl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (hj_badge)

- (void)showBadgeOnItemIndex:(int)index;  
- (void)hideBadgeOnItemIndex:(int)index;

@end

NS_ASSUME_NONNULL_END
