//
//  TouchIDHelper.m
//  HKProject
//
//  Created by apple on 2017/3/22.
//  Copyright © 2017年 hjkl. All rights reserved.
//

#import "TouchIDHelper.h"

@implementation TouchIDHelper

+ (void)showTouchIDAuthenticationWithReason:(NSString *)reason completion:(void (^)(TouchIDResult))completion {
    [self showTouchIDAuthenticationWithReason:reason fallbackTitle:nil completion:^(TouchIDResult result) {
        completion(result);
    }];
}

+ (void)showTouchIDAuthenticationWithReason:(NSString *)reason fallbackTitle:(NSString *)fallbackTitle completion:(void (^)(TouchIDResult))completion {
    LAContext *context = [[LAContext alloc] init];
    [context setLocalizedFallbackTitle:fallbackTitle];
    NSError *error = nil;
    if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]){
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:reason reply:^(BOOL success, NSError * _Nullable error) {
            if(success){
                completion(TouchIDResultSuccess);
            } else {
                switch (error.code) {
                    case LAErrorAuthenticationFailed:
                        completion(TouchIDResultAuthenticationFailed);
                        break;
                    case LAErrorUserCancel:
                        completion(TouchIDResultUserCancel);
                        break;
                    case LAErrorUserFallback:
                        completion(TouchIDResultUserFallback);
                        break;
                    case LAErrorSystemCancel:
                        completion(TouchIDResultSystemCacel);
                        break;
                    default:
                        completion(TouchIDResultError);
                        break;
                }
            }
        }];
    } else {
        switch (error.code) {
            case LAErrorPasscodeNotSet:
                completion(TouchIDResultPwdcodeNotSet);
                break;
            case LAErrorTouchIDNotAvailable:
                completion(TouchIDResultNotAvailable);
                break;
            case LAErrorTouchIDNotEnrolled:
                completion(TouchIDResultNotEnrolled);
                break;
            default:
                completion(TouchIDResultError);
                break;
        }
    }
}

@end
