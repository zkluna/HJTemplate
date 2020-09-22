//
//  HJAOPManager.h
//  HKProject
//
//  Created by rubick on 2018/5/5.
//  Copyright © 2018年 hjkl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  当你需要使用多个对象来承接一些方法的实现，
 *  1、初始化 HJAOPManager实例，
 *  2、将这些对象实例添加到HJAOPManager 实例中(addTarget)，
 *  3、最后将 YBAOPManager 实例作为这些方法的第一承接者。。
 */

@interface HJAOPManager : NSObject

@property (strong, nonatomic, readonly) NSPointerArray *targets;
- (void)addTarget:(id)target;
- (void)removeTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
