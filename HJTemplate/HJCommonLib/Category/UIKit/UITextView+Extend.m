//
//  UITextView+Extend.m
//  kActivity
//
//  Created by rubick on 16/10/26.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import "UITextView+Extend.h"
#import <objc/runtime.h>

@implementation UITextView (Extend)

static const char *phTextView = "placeHolderTextView";

- (UITextView *)placeHolderTextView {
    return objc_getAssociatedObject(self, phTextView);
}
- (void)setPlaceHolderTextView:(UITextView *)placeHolderTextView {
    objc_setAssociatedObject(self, phTextView, placeHolderTextView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)addPlaceHolder:(NSString *)placeHolder {
    if(![self placeHolderTextView]) {
        self.delegate = self;
        UITextView *textView = [[UITextView alloc] initWithFrame:self.bounds];
        textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        textView.backgroundColor = [UIColor clearColor];
        textView.textColor = [UIColor grayColor];
        textView.userInteractionEnabled = NO;
        textView.text = placeHolder;
        [self addSubview:textView];
        [self setPlaceHolderTextView:textView];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.placeHolderTextView.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if(textView.text && [textView.text isEqualToString:@""]){
        self.placeHolderTextView.hidden = NO;
    }
}

@end
