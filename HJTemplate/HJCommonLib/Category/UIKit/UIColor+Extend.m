//
//  UIColor+Extend.m
//  kActivity
//
//  Created by rubick on 16/10/26.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import "UIColor+Extend.h"

@implementation UIColor (Extend)

+ (instancetype)hj_colorWithHexStr:(NSString *)hexStr {
    NSString *colorString = [[hexStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if(colorString.length < 6){
        return [UIColor clearColor];
    }
    if ([colorString hasPrefix:@"0X"]) {
        colorString = [colorString substringFromIndex:2];
    }
    if ([colorString hasPrefix:@"#"]) {
        colorString = [colorString substringFromIndex:1];
    }
    if (colorString.length != 6) {
        return [UIColor clearColor];
    }
    NSRange range;
    range.location = 0;
    range.length = 2;
    // r
    NSString *rString = [colorString substringWithRange:range];
    // g
    range.location = 2;
    NSString *gString = [colorString substringWithRange:range];
    // b
    range.location = 4;
    NSString *bString = [colorString substringWithRange:range];
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:1.0];
}
+ (instancetype)hj_colorWithHexStr:(NSString *)hexStr alpha:(CGFloat)alpha {
    return [[self hj_colorWithHexStr:hexStr] colorWithAlphaComponent:alpha];
}
+ (instancetype)hj_randomColor {
    return [UIColor colorWithRed:arc4random_uniform(256)/255.0f green:arc4random_uniform(256)/255.0f blue:arc4random_uniform(256)/255.0f alpha:1.0f];
}

@end
