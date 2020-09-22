//
//  NSDate+Extend.h
//  kActivity
//
//  Created by rubick on 16/10/25.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extend)

- (NSString *)timestamp; // 时间戳
- (NSString *)currentTimeWithFormat:(NSString *)format;
- (NSDateComponents *)components; // 时间成分
- (NSDate *)dateWithYMD; // 年月日时间
- (NSDateComponents *)deltaWithNow; //与当前时差
//
- (NSUInteger)day;
- (NSUInteger)hour;
- (NSUInteger)minite;
- (NSTimeInterval)second;
- (BOOL)isSameDateWithData:(NSDate *)date;
//
- (BOOL)isToday;
- (BOOL)isYesterday;
- (BOOL)isThisYear;

@end
