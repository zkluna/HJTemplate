//
//  NSString+HJExtension.m
//  HJSearch
//
//  Created by rubick on 2018/3/5.
//  Copyright © 2018年 Accentrix. All rights reserved.
//

#import "NSString+HJExtension.h"

@implementation NSString (HJExtension)

- (NSString *)hj_localizedStringOfLanguage:(NSString *)language {
    NSString *lan = nil;
    if(language){
        lan = language;
    } else {
        lan = [NSLocale preferredLanguages].firstObject;
    }
    if([lan hasPrefix:@"en"]) {
        lan = @"en";
    } else if([language hasPrefix:@"fr"]) {
        lan = @"fr";
    } else if([lan hasPrefix:@"zh"]) {
        if([lan rangeOfString:@"Hans"].location != NSNotFound) {
            lan = @"zh-Hans";
        } else {
            lan = @"zh-Hant";
        }
    }
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:lan ofType:@"lproj"]];
    return [bundle localizedStringForKey:self value:nil table:@"HJLocalizable"];
}

@end
