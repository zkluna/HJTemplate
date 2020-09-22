//
//  TouchIDHelper.h
//  HKProject
//
//  Created by apple on 2017/3/22.
//  Copyright © 2017年 hjkl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

typedef NS_ENUM(NSInteger, TouchIDResult){
    TouchIDResultSuccess = 0,
    TouchIDResultError,
    TouchIDResultAuthenticationFailed,
    TouchIDResultUserCancel,
    TouchIDResultUserFallback,
    TouchIDResultSystemCacel,
    TouchIDResultPwdcodeNotSet,
    TouchIDResultNotAvailable,
    TouchIDResultNotEnrolled
};

@interface TouchIDHelper : NSObject

+ (void)showTouchIDAuthenticationWithReason:(NSString * _Nonnull)reason completion:(void(^ _Nullable)(TouchIDResult result))completion;
+ (void)showTouchIDAuthenticationWithReason:(NSString *_Nullable)reason fallbackTitle:(NSString * _Nullable)fallbackTitle completion:(void (^_Nullable)(TouchIDResult))completion;

@end
