//
//  UIControl+Extend.h
//  kActivity
//
//  Created by rubick on 16/10/26.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (Extend)

- (void)removeAllTargets;
- (void)setTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)addBlockForControlEvents:(UIControlEvents)controlEvents block:(void(^)(id sender))block;
- (void)setBlcokforControlEvents:(UIControlEvents)controlEvents block:(void(^)(id sender))block;
- (void)removeAllBlocksforControlEvents:(UIControlEvents)controlEvents;

@end
