//
//  NSArray+Extend.h
//  kActivity
//
//  Created by rubick on 16/10/24.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Extend)

- (NSString *)toString;
// 比较两个数组不考虑次序
- (BOOL)compareIgnoreOrderWithArray:(NSArray *)array;
// 数组的交集
- (NSArray *)arrayForIntersectionWithOtherArray:(NSArray *)otherArr;
// 数组的差集
- (NSArray *)arrayForMinusWithOtherArray:(NSArray *)otherArr;
/**
 *  --z plist 操作
 */
+ (NSArray *)arrayWithPlistData:(NSData *)plist;
+ (NSArray *)arrayWithPlistString:(NSString *)plist;
- (NSData *)plistData;
- (NSString *)plistString;
@end

@interface NSMutableArray (Extend)
/**
 *  --z 基本操作
 */
- (id)popFirstObject;
- (id)popLastObject;
- (void)reverse; // 倒叙排列
- (void)shuffle; // 打乱顺序

@end
