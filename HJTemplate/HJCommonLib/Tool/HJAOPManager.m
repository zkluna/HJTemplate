//
//  HJAOPManager.m
//  HKProject
//
//  Created by rubick on 2018/5/5.
//  Copyright © 2018年 hjkl. All rights reserved.
//

#import "HJAOPManager.h"
#import <pthread.h>

@interface HJAOPManager(){
    pthread_mutex_t lock;
}
@property (strong, nonatomic) NSPointerArray *targets;
@end

@implementation HJAOPManager

- (instancetype)init {
    self = [super init];
    if(self){
        pthread_mutex_init(&lock, NULL);
        _targets = [NSPointerArray weakObjectsPointerArray];
    }
    return self;
}
- (void)addTarget:(id)target {
    pthread_mutex_lock(&lock);
    for (id temp in _targets) {
        if(temp == target){
            pthread_mutex_unlock(&lock);
            return;
        }
    }
    [_targets addPointer:(__bridge void * _Nullable)(target)];
    pthread_mutex_unlock(&lock);
}
- (void)removeTarget:(id)target {
    pthread_mutex_lock(&lock);
    for (int i=0; i<_targets.count; i++) {
        if([_targets pointerAtIndex:i] == (__bridge void * _Nullable)(target)) {
            [_targets removePointerAtIndex:i];
            break;
        }
    }
    pthread_mutex_unlock(&lock);
}
#pragma mark - forwarding methods
- (BOOL)respondsToSelector:(SEL)aSelector {
    for(id temp in _targets) {
        if([temp respondsToSelector:aSelector]){
            return YES;
        }
    }
    return [super respondsToSelector:aSelector];
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature;
    for (id target in _targets) {
        signature = [target methodSignatureForSelector:aSelector];
        if(signature){
            break;
        }
    }
    return signature;
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    for (id target in _targets) {
        if([target respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:target];
        }
    }
}
- (void)dealloc {
    pthread_mutex_destroy(&lock);
}

@end
