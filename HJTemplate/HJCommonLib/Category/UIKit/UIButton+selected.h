//
//  UIButton+selected.h
//  LaoTieWallet
//
//  Created by rubick on 2018/11/8.
//  Copyright © 2018 LG. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (selected)

- (void)setBtnStyleWithTitle:(NSString *)title normalColor:(UIColor *)normalColor normalFont:(UIFont *)normalFont selectedColor:(UIColor *)selectedColor selectedFont:(UIFont *)selectedFont;

@end

NS_ASSUME_NONNULL_END
