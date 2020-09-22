//
//  UIColor+Extend.h
//  kActivity
//
//  Created by rubick on 16/10/26.
//  Copyright © 2016年 hhh. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBColor(a, b, c) [UIColor colorWithRed:(a)/255.0 green:(b)/255.0 blue:(c)/255.0 alpha:1]
#define RGBAColor(a, b, c, d) [UIColor colorWithRed:(a)/255.0 green:(b)/255.0 blue:(c)/255.0 alpha:(d)]

@interface UIColor (Extend)

+ (instancetype)hj_colorWithHexStr:(NSString *)hexStr;
+ (instancetype)hj_colorWithHexStr:(NSString *)hexStr alpha:(CGFloat)alpha;

+ (instancetype)hj_randomColor;

@end

