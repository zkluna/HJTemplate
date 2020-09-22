//
//  UIBarButtonItem+Extend.m
//  kActivity
//
//  Created by rubick on 16/10/26.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import "UIBarButtonItem+Extend.h"

#import <objc/runtime.h>
static const int block_key;

@interface _YYBarBtnItemBlockTarget : NSObject

@property (nonatomic, copy)void(^block)(id sender);

- (id)initWithBlock:(void(^)(id sender))block;
- (void)invoke:(id)sender;

@end

@implementation _YYBarBtnItemBlockTarget

- (id)initWithBlock:(void (^)(id))block {
    self = [super init];
    if(self) {
        _block = [block copy];
    }
    return self;
}
- (void)invoke:(id)sender {
    if(self.block) self.block(sender);
}

@end

@implementation UIBarButtonItem (Extend)

- (void)setBarButtonActionBlock:(void(^)(id))block {
    _YYBarBtnItemBlockTarget *target = [[_YYBarBtnItemBlockTarget alloc] initWithBlock:block];
    objc_setAssociatedObject(self, &block_key, target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setTarget:target];
    [self setAction:@selector(invoke:)];
}
- (void(^)(id))actionBlock {
    _YYBarBtnItemBlockTarget *target = objc_getAssociatedObject(self, &block_key);
    return target.block;
}

@end
