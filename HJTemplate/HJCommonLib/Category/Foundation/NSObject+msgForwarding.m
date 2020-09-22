//
//  NSObject+msgForwarding.m
//  CrashAvoid
//
//  Created by zl on 2019/4/9.
//  Copyright © 2019 youtil. All rights reserved.
//

#import "NSObject+msgForwarding.h"
#import <objc/runtime.h>

#define MethodSignatureForSelKey @"MethodSignatureForSelKey"
#define ForwardInvocationKey @"ForwardInvocationKey"
#define IsCheckedKey @"IsCheckedKey"

@implementation NSObject (msgForwarding)

//+ (void)load {
//    //
//    Class class = [self class];
//    SEL originalSel = @selector(forwardInvocation:);
//    SEL swizzledSel = @selector(safe_forwardInvocation:);
//    Method originalMehtod = class_getInstanceMethod(class, originalSel);
//    Method swizzledMethod = class_getInstanceMethod(class, swizzledSel);
//    BOOL success = class_addMethod(class, swizzledSel, method_getImplementation(originalMehtod), method_getTypeEncoding(originalMehtod));
//    if(success) {
//        class_replaceMethod(class, swizzledSel, method_getImplementation(originalMehtod), method_getTypeEncoding(originalMehtod));
//    } else {
//        method_exchangeImplementations(originalMehtod, swizzledMethod);
//    }
//    
//    SEL originalSel2 = @selector(methodSignatureForSelector:);
//    SEL swizzledSel2 = @selector(safe_methodSignatureForSelector:);
//    Method originalMethod2 = class_getInstanceMethod(class, originalSel2);
//    Method swizzledMethod2 = class_getInstanceMethod(class, swizzledSel2);
//    BOOL success2 = class_addMethod(class, originalSel2, method_getImplementation(swizzledMethod2), method_getTypeEncoding(swizzledMethod2));
//    if(success2) {
//        class_replaceMethod(class, swizzledSel2, method_getImplementation(originalMethod2), method_getTypeEncoding(originalMethod2));
//    } else {
//        method_exchangeImplementations(originalMethod2, swizzledMethod2);
//    }
//}
- (NSArray *)getAllMethodArray {
    u_int count;
    NSMutableArray *arrayM = [NSMutableArray array];
    Method *methodList = class_copyMethodList([self class], &count);
    for(int i=0; i<count; i++) {
        Method tMethod = methodList[i];
        SEL sel_f = method_getName(tMethod);
        const char * name_s = sel_getName(sel_f);
        [arrayM addObject:[NSString stringWithUTF8String:name_s]];
    }
    free(methodList);
    return [arrayM copy];
}
// getter&setter
- (BOOL)isOverriForwardInvocation {
    NSNumber *isExchange = objc_getAssociatedObject(self, ForwardInvocationKey);
    return [isExchange boolValue];
}
- (BOOL)isOverriSignatureForSelector {
    NSNumber *isExchange = objc_getAssociatedObject(self, MethodSignatureForSelKey);
    return [isExchange boolValue];
}
- (NSNumber *)isChecked {
    return objc_getAssociatedObject(self, IsCheckedKey);
}
- (void)setIsOverriForwardInvocation:(BOOL)isOverriForwardInvocation {
    objc_setAssociatedObject(self, ForwardInvocationKey, [NSNumber numberWithBool:isOverriForwardInvocation], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setIsOverriSignatureForSelector:(BOOL)isOverriSignatureForSelector {
    objc_setAssociatedObject(self, MethodSignatureForSelKey, [NSNumber numberWithBool:isOverriSignatureForSelector], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setIsChecked:(NSNumber *)isChecked {
    objc_setAssociatedObject(self, IsCheckedKey, isChecked, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMethodSignature *)safe_methodSignatureForSelector:(SEL)aSelector {
    if(!self.isChecked.boolValue) {
        self.isOverriForwardInvocation = NO;
        self.isOverriSignatureForSelector = NO;
        for(NSString *methodName in [self getAllMethodArray]) {
            if([methodName isEqualToString:@"methodSignatureForSelector:"]) {
                self.isOverriSignatureForSelector = YES;
            }
            if([methodName isEqualToString:@"forwardInvocation:"]) {
                self.isOverriForwardInvocation = YES;
            }
        }
        self.isChecked = @(YES);
    }
    if(self.isOverriSignatureForSelector) {
        return [self safe_methodSignatureForSelector:aSelector];
    }
    NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:aSelector];
    if(methodSignature == nil) {
        NSMethodSignature *methodSignatureNew = [NSMethodSignature methodSignatureForSelector:@selector(noFoundMethodWithName:)];
        return methodSignatureNew;
    } else {
        return methodSignature;
    }
}
- (void)safe_forwardInvocation:(NSInvocation *)aInvocation {
    if(self.isOverriForwardInvocation) {
        return [self safe_forwardInvocation:aInvocation];
    }
    if([self respondsToSelector:aInvocation.selector]) {
        [aInvocation invokeWithTarget:self];
    } else {
        NSString *methodName = NSStringFromSelector(aInvocation.selector);
        [aInvocation setSelector:@selector(noFoundMethodWithName:)];
        [aInvocation setArgument:&methodName atIndex:2];
        [aInvocation invokeWithTarget:self];
    }
}
- (void)noFoundMethodWithName:(NSString *)mName {
    NSLog(@"----------------------warn----------------------");
    NSLog(@"Method : %@ not found!!!", mName);
}


@end
