//
//  CALayer+Extend.h
//  kActivity
//
//  Created by rubick on 16/10/27.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CALayer (Extend)

- (void)setLayerShadow:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius;
- (void)removeAllSublayers;

@end
