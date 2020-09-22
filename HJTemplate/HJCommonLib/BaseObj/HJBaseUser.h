//
//  HJBaseUser.h
//  ***
//
//  Created by rubick on 2019/2/4.
//  Copyright © 2019 hjkl. All rights reserved.
//

//#import <Realm/Realm.h>
//#import <Realm/RLMObject.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJBaseUser : NSObject // RLMObject

@property (strong, nonatomic) NSString *primaryKey;

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *userTypeCode;
@property (strong, nonatomic) NSString *userPhoto;
@property (strong, nonatomic) NSString *remark;

+ (HJBaseUser *)hj_shareUserInfo;

@end

NS_ASSUME_NONNULL_END
