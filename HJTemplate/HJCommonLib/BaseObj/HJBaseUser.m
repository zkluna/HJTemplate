//
//  LPBUserInfo.m
//  LianPeiBao
//
//  Created by zhaoke on 2019/2/4.
//  Copyright © 2019 kl. All rights reserved.
//

#import "HJBaseUser.h"
//#import <Realm/Realm.h>

@implementation HJBaseUser

//+ (HJBaseUser *)hj_shareUserInfo {
//    static dispatch_once_t onceToken;
//    static HJBaseUser *_userInfo = nil;
//    dispatch_once(&onceToken, ^{
//        _userInfo = [[HJBaseUser alloc] init];
//    });
//    return _userInfo;
//}
//// 主键
//+ (NSString *)primaryKey {
//    return @"primaryKey";
//}
//// 需要添加索引的属性
//+ (NSArray<NSString *> *)indexedProperties {
//    return @[@"userId"];
//}
//// 默认属性值
//+ (NSDictionary *)defaultPropertyValues {
//    return @{@"remark":@"无备注"};
//}
//// 忽略的字段
//+ (NSArray<NSString *> *)ignoredProperties {
//    return @[];
//}
//
///** realm DB example */
//- (void)realmEditExample {
//    HJBaseUser *userInfo = [[HJBaseUser alloc] init];
//    userInfo.primaryKey = @"11";
//    userInfo.userId = @"user_id_0001";
//    userInfo.userTypeCode = @"code1";
//
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    NSLog(@"%@", realm.configuration.fileURL.absoluteString);
//
//    [realm beginWriteTransaction];
//    [realm addObject:userInfo]; // 增
////    [realm addOrUpdateObject:userInfo]; //添加或者更新
////    [realm deleteObject:userInfo]; //删
//    [realm commitWriteTransaction];
//    //    [realm transactionWithBlock:^{
//    //    }];
//    // 异步 查&改
//    dispatch_async(dispatch_queue_create("background", 0), ^{
//        @autoreleasepool {
//            HJBaseUser *userInfo2 = [[HJBaseUser objectsWhere:@"primaryKey == 11"] firstObject];
//            RLMRealm *realm = [RLMRealm defaultRealm];
//            [realm beginWriteTransaction];
//            userInfo2.remark = @"0003";
//            [realm commitWriteTransaction];
//        }
//    });
//    // 查
//    RLMResults<HJBaseUser *> *userInfos = [HJBaseUser allObjects];
//    RLMResults<HJBaseUser *> *tanUserInfos = [HJBaseUser objectsWhere:@"color = 'tan' AND name BEGINSWITH 'B'"];
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"color = %@ AND name BEGINSWITH %@",
//                         @"tan", @"B"];
//    tanUserInfos = [HJBaseUser objectsWithPredicate:pred];
//
//}

@end
