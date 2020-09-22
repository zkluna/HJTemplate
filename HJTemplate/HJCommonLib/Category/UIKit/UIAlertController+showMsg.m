//
//  UIAlertController+showMsg.m
//  Basic_Category...
//
//  Created by rubick on 16/7/27.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import "UIAlertController+showMsg.h"

@implementation UIAlertController (showMsg)

+ (void)showWithMsg:(NSString *)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
