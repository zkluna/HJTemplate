//
//  NSArray+Extend.m
//  kActivity
//
//  Created by rubick on 16/10/24.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import "NSArray+Extend.h"

@implementation NSArray (Extend)

- (NSString *)toString {
    if(self == nil || self.count == 0) return @"";
    NSMutableString *str = [NSMutableString string];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [str appendFormat:@"%@",obj];
    }];
    NSString *strForRight = [str substringWithRange:NSMakeRange(0, str.length-1)];
    return strForRight;
}
- (BOOL)compareIgnoreOrderWithArray:(NSArray *)array {
    NSSet *set1 = [NSSet setWithArray:self];
    NSSet *set2 = [NSSet setWithArray:self];
    return [set1 isEqualToSet:set2];
}
- (NSArray *)arrayForIntersectionWithOtherArray:(NSArray *)otherArr {
    NSMutableArray *intersectionArray=[NSMutableArray array];
    if(self.count==0) return nil;
    if(otherArr==nil) return nil;
    for (id obj in self) {
        if(![otherArr containsObject:obj]) continue;
        [intersectionArray addObject:obj];
    }
    
    return intersectionArray;
}
- (NSArray *)arrayForMinusWithOtherArray:(NSArray *)otherArr {
    if(self==nil) return nil;
    if(otherArr==nil) return self;
    NSMutableArray *minusArray=[NSMutableArray arrayWithArray:self];
    for (id obj in otherArr) {
        if(![self containsObject:obj]) continue;
        [minusArray removeObject:obj];
    }
    return minusArray;
}
+ (NSArray *)arrayWithPlistData:(NSData *)plist {
    if(!plist) return nil;
    NSArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListImmutable format:NULL error:NULL];
    if([array isKindOfClass:[NSArray class]]) return array;
    return nil;
}
+ (NSArray *)arrayWithPlistString:(NSString *)plist {
    if(!plist) return nil;
    NSData *data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self arrayWithPlistData:data];
}
- (NSData *)plistData {
    return [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:kNilOptions error:NULL];
}
- (NSString *)plistString {
    NSData *xmlData = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListXMLFormat_v1_0 options:kNilOptions error:NULL];
    if(xmlData) return [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
    return nil;
}
@end


@implementation NSMutableArray (Extend)

- (id)popFirstObject {
    id obj = nil;
    if (self.count) {
        obj = self.firstObject;
        [self removeObjectAtIndex:0];
    }
    return obj;
}
- (id)popLastObject {
    id obj = nil;
    if (self.count) {
        obj = self.lastObject;
        [self removeLastObject];
    }
    return obj;
}
- (void)reverse {
    NSUInteger count = self.count;
    int mid = floor(count/2.0);
    for (NSUInteger i = 0; i < mid; i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:(count-(i+1))];
    }
}
- (void)shuffle {
    for (NSUInteger i = self.count; i > 1; i--) {
        [self exchangeObjectAtIndex:(i - 1)
                  withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
}

@end
