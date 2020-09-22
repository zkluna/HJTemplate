//
//  CALayer+Extend.m
//  kActivity
//
//  Created by rubick on 16/10/27.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import "CALayer+Extend.h"

@implementation CALayer (Extend)

- (void)setLayerShadow:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius {
    self.shadowColor = color.CGColor;
    self.shadowOffset = offset;
    self.shadowRadius = radius;
    self.shadowOpacity = 1;
    self.shouldRasterize = YES;
    self.rasterizationScale = [UIScreen mainScreen].scale;
}
- (void)removeAllSublayers {
    while (self.sublayers.count) {
        [self.sublayers.lastObject removeAllSublayers];
    }
}

@end
