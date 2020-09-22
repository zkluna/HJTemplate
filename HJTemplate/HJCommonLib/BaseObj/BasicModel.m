//
//  BasicModel.m
//  Fghdgjnfjhgfjhm
//
//  Created by rubick on 16/10/28.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import "BasicModel.h"

@implementation BasicModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self yy_modelInitWithCoder:aDecoder];
}
- (NSUInteger)hash {
    return [self yy_modelHash];
}
- (BOOL)isEqual:(id)object {
    return [self yy_modelIsEqual:object];
}
- (id)copyWithZone:(nullable NSZone *)zone {
    return [self yy_modelCopy];
}

@end
/*
 *
 键值与属性名不同
 + (NSDictionary *)modelCustomPropertyMapper {
 return @{@"userId" : @"id",
          @"ID":@[@"id",@"p_id"]};
 }
 *
 *
 容器模型
 + (NSDictionary *)modelContainerPropertyGenericClass{
 return @{@"books":[Book class]};
 }
 *
 *
 白名单\黑名单
 + (NSArray *)modelPropertyWhitelist {
 return @[@"name"];
 }
 + (NSArray *)modelPropertyBlacklist {
 return @[@"uid"];
 }
 *
 *
 数据校验\转换
 - (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
 NSNumber *timestamp = dic[@"timestamp"];
 if(![timestamp isKindOfClass:[NSNumber class]]) return NO;
 _createdTime = [NSDate dateWithTimeIntervalSince1970:timestamp.floatValue];
 return YES;
 }
 - (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
 if(!_createdTime)return NO;
 dic[@"timestamp"] = @(n.timeIntervalSince1970);
 return YES;
 }
 *
 */

