//
//  UIControl+Extend.m
//  kActivity
//
//  Created by rubick on 16/10/26.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import "UIControl+Extend.h"
#import <objc/runtime.h>

static const int block_key;

@interface _YYControlBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);
@property (nonatomic, assign) UIControlEvents events;

- (id)initWithBlock:(void(^)(id sender))block events:(UIControlEvents)events;
- (void)invoke:(id)sender;

@end

@implementation _YYControlBlockTarget

- (id)initWithBlock:(void (^)(id))block events:(UIControlEvents)events {
    self = [super init];
    if(self){
        _block = [block copy];
        _events = events;
    }
    return self;
}
- (void)invoke:(id)sender {
    if(_block) _block(sender);
}
@end

@implementation UIControl (Extend)

- (void)removeAllTargets {
    __weak typeof(self) weakself = self;
    [[self allTargets] enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        [weakself removeTarget:obj action:NULL forControlEvents:UIControlEventAllEvents];
    }];
    [[self _yy_allControlBlockTargets] removeAllObjects];
}
- (void)setTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    if(!target || !action || !controlEvents) return;
    NSSet *targets = [self allTargets];
    for (id currentTarget in targets) {
        NSArray *actions = [self actionsForTarget:currentTarget forControlEvent:controlEvents];
        for (NSString *currentAction in actions) {
            [self removeTarget:currentTarget action:NSSelectorFromString(currentAction) forControlEvents:controlEvents];
        }
    }
    [self addTarget:target action:action forControlEvents:controlEvents];
}
- (void)addBlockForControlEvents:(UIControlEvents)controlEvents block:(void(^)(id sender))block {
    if(!controlEvents) return;
    _YYControlBlockTarget *target = [[_YYControlBlockTarget alloc] initWithBlock:block events:controlEvents];
    [self addTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
    NSMutableArray *targets = [self _yy_allControlBlockTargets];
    [targets addObject:target];
}
- (void)setBlcokforControlEvents:(UIControlEvents)controlEvents block:(void(^)(id sender))block {
    [self removeAllBlocksforControlEvents:UIControlEventAllEvents];
    [self addBlockForControlEvents:controlEvents block:block];
}
- (void)removeAllBlocksforControlEvents:(UIControlEvents)controlEvents {
    if(!controlEvents) return;
    NSMutableArray *targets = [self _yy_allControlBlockTargets];
    NSMutableArray *removes = [NSMutableArray array];
    for (_YYControlBlockTarget *target in targets) {
        if(target.events & controlEvents) {
            UIControlEvents newEvents = target.events & (~controlEvents);
            if(newEvents) {
                [self removeTarget:target action:@selector(invoke:) forControlEvents:target.events];
                target.events = newEvents;
                [self addTarget:target action:@selector(invoke:) forControlEvents:target.events];
            } else {
                [self removeTarget:target action:@selector(invoke:) forControlEvents:target.events];
                [removes addObject:target];
            }
        }
    }
    [targets removeObjectsInArray:removes];
}
- (NSMutableArray *)_yy_allControlBlockTargets {
    NSMutableArray *targets = objc_getAssociatedObject(self, &block_key);
    if(!targets) {
        targets = [NSMutableArray array];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}
@end
