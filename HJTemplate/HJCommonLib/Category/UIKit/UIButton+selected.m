//
//  UIButton+selected.m
//  LaoTieWallet
//
//  Created by rubick on 2018/11/8.
//  Copyright © 2018 LG. All rights reserved.
//

#import "UIButton+selected.h"

@implementation UIButton (selected)

- (void)setBtnStyleWithTitle:(NSString *)title normalColor:(UIColor *)normalColor normalFont:(UIFont *)normalFont selectedColor:(UIColor *)selectedColor selectedFont:(UIFont *)selectedFont {
    NSAttributedString *normalAttr = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:normalFont,NSForegroundColorAttributeName:normalColor}];
    [self setAttributedTitle:normalAttr forState:UIControlStateNormal];
    NSAttributedString *selectedAttr = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:selectedFont,NSForegroundColorAttributeName:selectedColor}];
    [self setAttributedTitle:selectedAttr forState:UIControlStateSelected];
}

@end
