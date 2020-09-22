//
//  UITextView+Extend.h
//  kActivity
//
//  Created by rubick on 16/10/26.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Extend)<UITextViewDelegate>

- (UITextView *)placeHolderTextView;
- (void)addPlaceHolder:(NSString *)placeHolder;

@end
