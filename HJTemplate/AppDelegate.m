//
//  AppDelegate.m
//  HJTemplate
//
//  Created by rubick on 2018/11/16.
//  Copyright © 2018 LG. All rights reserved.
//

#import "AppDelegate.h"
#import "HJCustomTabBarC.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "UncaughtExceptionHandler.h"
//#import "MatrixHandler.h"
//#import <KSCrash/KSCrash.h>
//#import <KSCrash/KSCrashInstallation+Alert.h>
//#import <KSCrash/KSCrashInstallationStandard.h>
//#import <KSCrash/KSCrashInstallationConsole.h>


@interface AppDelegate ()

@end

@implementation AppDelegate

static BOOL g_crashInHandler = NO;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
//    [UncaughtExceptionHandler startCaughtExceptionHandler];
//    [[MatrixHandler sharedInstance] installMatrix];
//    [self installCrashHandler];
    [[UITabBar appearance] setTranslucent:NO];
    HJCustomTabBarC *tabBar = [[HJCustomTabBarC alloc] init];
    self.window.rootViewController = tabBar;
    [self.window makeKeyAndVisible];
    return YES;
}
#pragma mark  -  KSCrash Method
//- (void)installCrashHandler {
//    KSCrashInstallation *installation = [self makeConsoleInstallation];
//    [installation install];
//    [self configureAdvancedSettings];
//    [KSCrash sharedInstance].deleteBehaviorAfterSendAll = KSCDeleteOnSucess;
//    [installation sendAllReportsWithCompletion:^(NSArray *filteredReports, BOOL completed, NSError *error) {
//        if(completed) {
//            NSLog(@"Sent %d reports", (int)[filteredReports count]);
//        } else {
//            NSLog(@"Failed to send reports: %@", error);
//        }
//    }];
//}
//- (KSCrashInstallation *)makeEmailInstallation {
//    NSString *emailAddress = @"911680675@qq.com";
//    KSCrashInstallationEmail *email = [KSCrashInstallationEmail sharedInstance];
//    email.recipients = @[emailAddress];
//    email.subject = @"Crash Report";
//    email.message = @"This is a crash report";
//    email.filenameFmt = @"crash-report-%d.txt.gz";
//    [email addConditionalAlertWithTitle:@"Crash Detected" message:@"The app crashed last time it was launched. Send a crash report?" yesAnswer:@"Sure!" noAnswer:@"No thanks"];
//    [email setReportStyle:KSCrashEmailReportStyleApple useDefaultFilenameFormat:YES];
//    return email;
//}
//- (KSCrashInstallation *)makeStandardInstallation {
//    NSURL *url = [NSURL URLWithString:@"https://simuapi.youtil.cn/api/"];
//    KSCrashInstallationStandard *standard = [KSCrashInstallationStandard sharedInstance];
//    standard.url = url;
//    return standard;
//}
//- (KSCrashInstallation *)makeConsoleInstallation {
//    return [[KSCrashInstallationConsole alloc] init];
//}
//#pragma mark  -  Advanced Crash Handling (optional)
//static void advanced_crash_callback(const KSCrashReportWriter *writer) {
//    // You can add extra user data at crash time if you want.
//    if(g_crashInHandler) {
//        // do something custom
//    }
//    writer -> addBooleanElement(writer, "some_bool_value", NO);
//    writer -> addStringElement(writer, "some_key", "some_string_value");
//    NSLog(@"*** advanced crash callback");
//}
//- (void)configureAdvancedSettings {
//    KSCrash *handler = [KSCrash sharedInstance];
//    handler.deadlockWatchdogInterval = 8;
//    handler.userInfo = @{@"someKey": @"someValue"};
//    handler.onCrash = advanced_crash_callback;
//    handler.monitoring = KSCrashMonitorTypeProductionSafe;
//    // Do not introspect class SensitiveInfo (see MainVC)
//    // When added to the "do not introspect" list, the Objective-C introspector
//    // will only record the class name, not its contents.
//    handler.doNotIntrospectClasses = @[@"SensitiveInfo"];
//}
// --> End

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
