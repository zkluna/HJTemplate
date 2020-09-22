//
//  NSObject+msgForwarding.h
//  CrashAvoid
//
//  Created by zl on 2019/4/9.
//  Copyright © 2019 youtil. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (msgForwarding)

// 是否重写le methodSignatureForSelector
@property (assign, nonatomic) BOOL isOverriSignatureForSelector;

// 是否重写le forwardInvocation
@property (assign, nonatomic) BOOL isOverriForwardInvocation;

@property (strong, nonatomic) NSNumber *isChecked;

@end

NS_ASSUME_NONNULL_END
