//
//  UITextField+KKTextLimit.m
//  InputLimit
//
//  Created by rubick on 2017/6/20.
//  Copyright © 2017年 hhh. All rights reserved.
//

#import "UITextField+KKTextLimit.h"
#import <objc/runtime.h>

static void *limitLenStrKey = &limitLenStrKey;

@implementation UITextField (KKTextLimit)

- (NSString *)limitLenStr {
    return objc_getAssociatedObject(self, &limitLenStrKey);
}
- (void)setLimitLenStr:(NSString *)limitLenStr {
    objc_setAssociatedObject(self, &limitLenStrKey, limitLenStr, OBJC_ASSOCIATION_COPY);
}
- (void)limitTextLength:(NSInteger)length {
    self.limitLenStr = [NSString stringWithFormat:@"%ld",(long)length];
    [self addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textFieldEditChanged:(id)obj {
    NSString *toBeString = self.text;
    NSInteger limitLength = [self.limitLenStr integerValue];
    // 获取高亮部分
    UITextRange *selectedRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    if(!position) {
        if(toBeString.length > limitLength) {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:limitLength];
            if(rangeIndex.length == 1){
                self.text = [toBeString substringToIndex:limitLength];
            } else {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, limitLength)];
                self.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

@end
