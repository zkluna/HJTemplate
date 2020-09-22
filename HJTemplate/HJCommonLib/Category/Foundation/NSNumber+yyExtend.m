//
//  NSNumber+yyExtend.m
//  kActivity
//
//  Created by rubick on 16/10/24.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import "NSNumber+yyExtend.h"
#import "NSString+Extend.h"

@implementation NSNumber (yyExtend)

+ (NSNumber *)numberWithString:(NSString *)string {
    NSString *str = [[string stringByTrim] lowercaseString];
    if(!str || !str.length) {
        return nil;
    }
    static NSDictionary *tempDic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tempDic = @{@"true":@(YES),@"yes":@(YES),@"false":@(NO),@"no":@(NO),@"nil":[NSNull null],@"null":[NSNull null],@"<null>":[NSNull null]};
    });
    NSNumber *num = tempDic[str];
    if(num) {
        if(num == (id)[NSNull null]){
            return nil;
        }
        return num;
    }
    // hex number
    int sign = 0;
    if([str hasPrefix:@"0x"]){
        sign = 1;
    } else if([str hasPrefix:@"-0x"]){
        sign = -1;
    }
    if(sign != 0){
        NSScanner *scan = [NSScanner scannerWithString:str];
        unsigned num = -1;
        BOOL suc = [scan scanHexInt:&num];
        if(suc){
            return [NSNumber numberWithLong:((long)num*sign)];
        } else {
            return nil;
        }
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter numberFromString:string];
}

@end
