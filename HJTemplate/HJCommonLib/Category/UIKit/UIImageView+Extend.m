//
//  UIImageView+Extend.m
//  kActivity
//
//  Created by rubick on 16/10/26.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import "UIImageView+Extend.h"

@implementation UIImageView (Extend)

- (void)setImageShadowColor:(UIColor *)color radius:(CGFloat)radius offset:(CGSize)offset opacity:(CGFloat)opacity {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowRadius = radius;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.clipsToBounds = NO;
}
- (void)setMaskImage:(UIImage *)image {
    CALayer *mask = [CALayer layer];
    mask.contents = (id)[image CGImage];
    mask.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.layer.mask = mask;
    self.layer.masksToBounds = YES;
}

@end
