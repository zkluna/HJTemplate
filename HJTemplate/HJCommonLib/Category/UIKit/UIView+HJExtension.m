//
//  UIView+HJExtension.m
//  HKProject
//
//  Created by rubick on 2018/3/5.
//  Copyright © 2018年 hhh. All rights reserved.
//

#import "UIView+HJExtension.h"

@implementation UIView (HJExtension)

- (CGFloat)hj_x {
    return self.hj_origin.x;
}
- (void)setHj_x:(CGFloat)hj_x {
    CGRect frame = self.frame;
    frame.origin.x = hj_x;
    self.frame = frame;
}
- (CGFloat)hj_y {
    return self.hj_origin.y;
}
- (void)setHj_y:(CGFloat)hj_y {
    CGRect frame = self.frame;
    frame.origin.y = hj_y;
    self.frame = frame;
}
- (CGFloat)hj_centerX {
    return self.center.x;
}
- (void)setHj_centerX:(CGFloat)hj_centerX {
    CGPoint center = self.center;
    center.x = hj_centerX;
    self.center = center;
}
- (CGFloat)hj_centerY {
    return self.center.y;
}
- (void)setHj_centerY:(CGFloat)hj_centerY {
    CGPoint center = self.center;
    center.y = hj_centerY;
    self.center = center;
}
- (CGSize)hj_size {
    return self.frame.size;
}
- (void)setHj_size:(CGSize)hj_size {
    CGRect frame = self.frame;
    frame.size = hj_size;
    self.frame = frame;
}
- (void)setHj_height:(CGFloat)hj_height{
    CGRect frame = self.frame;
    frame.size.height = hj_height;
    self.frame = frame;
}
- (CGFloat)hj_height {
    return self.frame.size.height;
}
- (void)setHj_width:(CGFloat)hj_width{
    CGRect frame = self.frame;
    frame.size.width = hj_width;
    self.frame = frame;
}
-(CGFloat)hj_width {
    return self.frame.size.width;
}
- (void)setHj_origin:(CGPoint)hj_origin {
    CGRect frame = self.frame;
    frame.origin = hj_origin;
    self.frame = frame;
}
- (CGPoint)hj_origin{
    return self.frame.origin;
}

@end
