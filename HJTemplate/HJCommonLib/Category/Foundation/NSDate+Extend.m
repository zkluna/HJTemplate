//
//  NSDate+Extend.m
//  kActivity
//
//  Created by rubick on 16/10/25.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import "NSDate+Extend.h"

@implementation NSDate (Extend)

- (NSString *)timestamp {
    NSTimeInterval timeIntercal = [self timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f",timeIntercal];
    return [timeString copy];
}
- (NSString *)currentTimeWithFormat:(NSString *)format {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}
- (NSDateComponents *)components {
    //创建日历
    NSCalendar *calendar=[NSCalendar currentCalendar];
    //定义成分
    NSCalendarUnit unit=NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self];
}
- (NSUInteger)day {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"dd"];
    NSString *dayString = [formater stringFromDate:self];
    return [dayString integerValue];
}

- (NSUInteger)hour {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"HH"];
    NSString *hourString = [formater stringFromDate:self];
    return [hourString integerValue];
}

- (NSUInteger)minite {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"mm"];
    NSString *hourString = [formater stringFromDate:self];
    return [hourString integerValue];
}

- (NSTimeInterval)second {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"ss"];
    NSString *hourString = [formater stringFromDate:self];
    return [hourString integerValue];
}

- (BOOL)isSameDateWithData:(NSDate *)date {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formater stringFromDate:self];
    NSString *dateStr1 = [formater stringFromDate:date];
    return [dateStr isEqualToString:dateStr1];
}
- (BOOL)isToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}
- (BOOL)isYesterday {
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    NSDate *selfDate = [self dateWithYMD];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}
- (NSDate *)dateWithYMD {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}
- (BOOL)isThisYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return nowCmps.year == selfCmps.year;
}
- (NSDateComponents *)deltaWithNow {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}

@end
