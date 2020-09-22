//
//  UIFont+FontSize.m
//  kActivity
//
//  Created by rubick on 16/8/28.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import "UIFont+FontSize.h"

@implementation UIFont (FontSize)

+ (UIFont *)fontOfCustomSize:(CGFloat)size {
    if(isIphone6) {
        size += 2;
    } else if(isIphone6plus) {
        size += 3;
    }
    UIFont *font = [UIFont systemFontOfSize:size];
    return font;
}
+ (UIFont *)fontBoldOfSize:(CGFloat)size {
    if(isIphone6) {
        size += 2;
    } else if(isIphone6plus) {
        size += 3;
    }
    UIFont *font = [UIFont boldSystemFontOfSize:size];
    return font;
}

@end
