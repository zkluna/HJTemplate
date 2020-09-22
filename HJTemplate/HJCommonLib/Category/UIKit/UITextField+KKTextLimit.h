//
//  UITextField+KKTextLimit.h
//  InputLimit
//
//  Created by rubick on 2017/6/20.
//  Copyright © 2017年 hhh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (KKTextLimit)

@property (nonatomic, strong) NSString *limitLenStr;

- (void)limitTextLength:(NSInteger)length;

@end
