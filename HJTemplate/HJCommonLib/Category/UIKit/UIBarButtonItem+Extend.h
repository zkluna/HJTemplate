//
//  UIBarButtonItem+Extend.h
//  kActivity
//
//  Created by rubick on 16/10/26.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extend)

- (void)setBarButtonActionBlock:(void(^)(id))block;

@end
