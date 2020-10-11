
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>

@interface MBProgressHUD (JJ)

+ (void)showMessage:(NSString *)message toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (MBProgressHUD *)showActivityMessage:(NSString*)message view:(UIView *)view;

+ (void)showMessage:(NSString *)message;
+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;
+ (MBProgressHUD *)showActivityMessage:(NSString*)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

@end
