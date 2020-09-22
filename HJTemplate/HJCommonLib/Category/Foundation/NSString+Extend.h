//
//  NSString+Extend.h
//  kActivity
//
//  Created by rubick on 16/8/28.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extend)

/**
 *  --z 字符串判断
 */
- (BOOL)validEmail;
- (BOOL)allSpaceInString;
- (BOOL)checkPhoneNumInput;
- (NSString *)validMobile;
- (NSString *)stringByTrim;
- (BOOL)validateByRegex:(NSString *)regexStr;
/**
 *  --z 编码，加密
 */
- (NSString *)urlEncode;
- (NSString *)urlDecode;
- (NSString *)md5;
- (NSString *)SHA1;
- (NSString *)SHA256;
- (NSString *)SHA512;
// [json] to Java
- (NSString *)utf8Str;
/**
 *  --z 转换
 */
- (NSNumber *)numberValue;
- (NSData *)dataValue;
- (NSRange)rangeOfAll;
- (id)jsonValueDecoded;
- (NSString *)thisYear;
- (NSString *)thisMonth;
- (NSString *)thisDay;
+ (NSString *)weekdayStringFromDate:(NSDate *)inputDate;
- (NSDate *)dateFromString;
- (NSString *)timestampToTimeStringWithFormatString:(NSString *)formatString;
/**
 *  --z 其他
 */
- (CGFloat)autoHeight:(UIFont *)font width:(CGFloat)width;
- (CGFloat)autoWidth:(UIFont *)font height:(CGFloat)height;

@end
