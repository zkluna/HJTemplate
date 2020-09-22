//
//  HJNetworkTool.m
//  HKProject
//
//  Created by rubick on 2018/7/29.
//  Copyright © 2018年 hjkl. All rights reserved.
//

#import "HJNetworkTool.h"
#import "HJBaseRequest.h"

@implementation HJNetworkTool

+ (BOOL)validateJSON:(id)json withValidator:(id)jsonValidator {
    if ([json isKindOfClass:[NSDictionary class]] &&
        [jsonValidator isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = json;
        NSDictionary *validator = jsonValidator;
        BOOL result = YES;
        NSEnumerator *enumerator = [validator keyEnumerator];
        NSString *key;
        while ((key = [enumerator nextObject]) != nil) {
            id value = dict[key];
            id format = validator[key];
            if ([value isKindOfClass:[NSDictionary class]]
                || [value isKindOfClass:[NSArray class]]) {
                result = [self validateJSON:value withValidator:format];
                if (!result) {
                    break;
                }
            } else {
                if ([value isKindOfClass:format] == NO &&
                    [value isKindOfClass:[NSNull class]] == NO) {
                    result = NO;
                    break;
                }
            }
        }
        return result;
    } else if ([json isKindOfClass:[NSArray class]] &&
               [jsonValidator isKindOfClass:[NSArray class]]) {
        NSArray *validatorArray = (NSArray *)jsonValidator;
        if (validatorArray.count > 0) {
            NSArray *array = json;
            NSDictionary *validator = jsonValidator[0];
            for (id item in array) {
                BOOL result = [self validateJSON:item withValidator:validator];
                if (!result) {
                    return NO;
                }
            }
        }
        return YES;
    } else if ([json isKindOfClass:jsonValidator]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSStringEncoding)stringEncodingWithRequest:(HJBaseRequest *)request {
    NSStringEncoding stringEncoding = NSUTF8StringEncoding;
    if (request.response.textEncodingName) {
        CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)request.response.textEncodingName);
        if (encoding != kCFStringEncodingInvalidId) {
            stringEncoding = CFStringConvertEncodingToNSStringEncoding(encoding);
        }
    }
    return stringEncoding;
}

+ (BOOL)validateResumeData:(NSData *)data {
    if(!data || [data length] < 1) return NO;
    NSError *error;
    NSDictionary *resumeDictionary = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:&error];
    if (!resumeDictionary || error) return NO;
#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED < 90000)\
|| (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED < 101100)
    NSString *localFilePath = [resumeDictionary objectForKey:@"NSURLSessionResumeInfoLocalPath"];
    if ([localFilePath length] < 1) return NO;
    return [[NSFileManager defaultManager] fileExistsAtPath:localFilePath];
#endif
    return YES;
}

@end
