//
//  UIGestureRecognizer+Extend.m
//  kActivity
//
//  Created by rubick on 16/10/26.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import "UIGestureRecognizer+Extend.h"
#import <objc/runtime.h>

static const int block_key;

@interface _YYGestureRecognizerBlockTarget : NSObject

@property (nonatomic, copy) void(^block)(id sender);

- (id)initWithBlock:(void(^)(id sender))block;
- (void)invoke:(id)sender;

@end

@implementation _YYGestureRecognizerBlockTarget

- (id)initWithBlock:(void (^)(id))block {
    self = [super init];
    if(self) {
        _block = [block copy];
    }
    return self;
}
- (void)invoke:(id)sender {
    if(_block) _block(sender);
}
@end

@implementation UIGestureRecognizer (Extend)

- (instancetype)initWithActionBlock:(void(^)(id sender))block {
    self = [self init];
    [self addActionBlock:block];
    return self;
}
- (void)addActionBlock:(void(^)(id sender))block {
    _YYGestureRecognizerBlockTarget *target = [[_YYGestureRecognizerBlockTarget alloc] initWithBlock:block];
    [self addTarget:target action:@selector(invoke:)];
    NSMutableArray *targets = [self _yy_allGestureRecognizerBlockTargets];
    [targets addObject:target];
}
- (void)removeAllActionBlocks {
    NSMutableArray *targets = [self _yy_allGestureRecognizerBlockTargets];
    [targets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeTarget:obj action:@selector(invoke:)];
    }];
    [targets removeAllObjects];
}
- (NSMutableArray *)_yy_allGestureRecognizerBlockTargets {
    NSMutableArray *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets) {
        targets = [NSMutableArray array];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end
