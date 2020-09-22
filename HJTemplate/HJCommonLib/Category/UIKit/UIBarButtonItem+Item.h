//
//  UIBarButtonItem+Item.m
//  Handy_APP_Frame
//
//  Created by Handy on 18/10/9.
//  Copyright © 2018年 Handy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)


+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
