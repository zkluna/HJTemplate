//
//  NSObject+Extend.m
//  kActivity
//
//  Created by rubick on 16/10/25.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import "NSObject+Extend.h"
#import <objc/objc.h>
#import <objc/runtime.h>

static const int block_key;

@interface _YYObjectKVOBlockTarget : NSObject
@property (nonatomic, copy) void(^block)(id obj, id oldValue, id newValue);
- (id)initWithBlock:(void(^)(id obj, id oldValue, id newValue))block;
@end

@implementation _YYObjectKVOBlockTarget

- (id)initWithBlock:(void (^)(id, id, id))block {
    self = [super self];
    if(self) {
        self.block = block;
    }
    return self;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if(!self.block) return;
    BOOL isPrior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
    if(isPrior) return;
    NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
    if(changeKind != NSKeyValueChangeSetting) return;
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    if(oldValue == [NSNull null]) oldValue = nil;
    id newValue = [change objectForKey:NSKeyValueChangeNewKey];
    if(newValue == [NSNull null]) newValue = nil;
    self.block(object, oldValue, newValue);
}

@end

@implementation NSObject (Extend)

- (NSArray *)allPropertyNames {
    NSMutableDictionary *allProperty = [[NSMutableDictionary alloc] init];
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList([self class], &propertyCount);
    for (int i = 0; i < propertyCount; i++) {
        objc_property_t property = propertys[i];
        const char * propertyName = property_getName(property);
        id value = [self valueForKey:@(propertyName)]?:@"nil";
        [allProperty setObject:value forKey:@(propertyName)];
    }
    free(propertys);
    return [allProperty copy];
}

- (void)addObserverBlockForKeyPath:(NSString *)keyPath block:(void(^)(id obj, id oldValue, id newValue))block {
    if(!keyPath || !block) return;
    _YYObjectKVOBlockTarget *target = [[_YYObjectKVOBlockTarget alloc] initWithBlock:block];
    NSMutableDictionary *dic = [self _yy_allObejctObserverBlocks];
    NSMutableArray *arr = dic[keyPath];
    if(!arr) {
        arr = [NSMutableArray arrayWithCapacity:0];
        dic[keyPath] = arr;
    }
    [arr addObject:target];
    [self addObserver:target forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}
- (void)removeObserBlocksForKeyPath:(NSString *)keyPath {
    if(!keyPath) return;
    NSMutableDictionary *dic = [self _yy_allObejctObserverBlocks];
    NSMutableArray *arr = dic[keyPath];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeObserver:obj forKeyPath:keyPath];
    }];
    [dic removeObjectForKey:keyPath];
}
- (void)removeObserverBlocks {
    NSMutableDictionary *dic = [self _yy_allObejctObserverBlocks];
    [dic enumerateKeysAndObjectsUsingBlock: ^(NSString *key, NSArray *arr, BOOL *stop) {
        [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
            [self removeObserver:obj forKeyPath:key];
        }];
    }];
    [dic removeAllObjects];
}
- (NSMutableDictionary *)_yy_allObejctObserverBlocks {
    NSMutableDictionary *targets = objc_getAssociatedObject(self, &block_key);
    if(!targets) {
        targets = [NSMutableDictionary dictionaryWithCapacity:0];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}
@end
