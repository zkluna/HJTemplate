//
//  UIScrollView+Touch.h
//  sunflower
//
//  Created by rubick on 16/8/25.
//  Copyright © 2016年 shenbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Touch)

- (void)scrollToTop;
- (void)scrollToTopAnimated:(BOOL)animated;

- (void)scrollToBottom;
- (void)scrollToBottomAnimated:(BOOL)animated;

- (void)scrollToLeft;
- (void)scrollToLeftAnimated:(BOOL)animated;

- (void)scrollToRight;
- (void)scrollToRightAnimated:(BOOL)animated;

@end
