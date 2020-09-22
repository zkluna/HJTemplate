//
//  NSObject+Extend.h
//  kActivity
//
//  Created by rubick on 16/10/25.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extend)

/**
 *   -- Property
 */

- (NSDictionary *)allPropertyNames;

/**
 *   -- KVO
 */
- (void)addObserverBlockForKeyPath:(NSString *)keyPath block:(void(^)(id obj, id oldValue, id newValue))block;
- (void)removeObserBlocksForKeyPath:(NSString *)keyPath;
- (void)removeObserverBlocks;

@end
