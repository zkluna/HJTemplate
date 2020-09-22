//
//  NSDictionary+Extend.h
//  kActivity
//
//  Created by rubick on 16/10/25.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extend)
/**
 *  --z plist 操作
 */
+ (NSDictionary *)dictionaryWithPlistData:(NSData *)plist;
+ (NSDictionary *)dictionaryWithPlistString:(NSString *)plist;
- (NSData *)plistData;
- (NSString *)plistString;
/**
 *  --z 基本操作
 */
- (NSArray *)allkeysSorted;
- (NSArray *)allValuesSortedByKeys;
- (BOOL)containsObjectForKey:(id)key;
- (NSDictionary *)entriesForKeys:(NSArray *)keys;
/**
 *  --z 编码
 */
- (NSString *)jsonStringEncoded;
- (NSString *)jsonPrettyStringEncoded;

@end

@interface NSMutableDictionary (Extend)

- (id)popObjectForKey:(id)aKey;
- (NSDictionary *)popEntriesForKeys:(NSArray *)keys;

@end

