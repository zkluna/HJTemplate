////
////  UncaughtExceptionHandler.m
////  GeneralTest
////
////  Created by zhaoke on 2020/6/8.
////  Copyright © 2020 hhh. All rights reserved.
////
//
//#import "UncaughtExceptionHandler.h"
//#import <libkern/OSAtomic.h>
//#include <execinfo.h>
//
//NSString * const UncaughtExceptionHandlerSingnalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
//NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
//NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";
//
//volatile int32_t UncaughtExceptionCount = 0;
//const int32_t UncaughtExceptionMaximum = 10;
////const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
////const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;
//
//void installUncaughtExceptionHandler();
//
//static NSUncaughtExceptionHandler *previousUncaughtExceptionHandler = NULL;
//
//@implementation UncaughtExceptionHandler
//+ (void)startCaughtExceptionHandler {
//    installUncaughtExceptionHandler();
//}
//+ (void)registerHandler {
//    previousUncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
//    NSSetUncaughtExceptionHandler(&DoraemonUncaughtExceptionHandler);
//}
//void DoraemonUncaughtExceptionHandler(NSException *exception) {
//    NSArray *stackArray = [exception callStackSymbols];
//    NSString *reason = [exception reason];
//    NSString *name = [exception name];
//     NSString * exceptionInfo = [NSString stringWithFormat:@"=uncaughtException异常错误报告=\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@", name, reason, [stackArray componentsJoinedByString:@"\n"]];
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:exceptionInfo preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *quitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        // 还原exceptionHandler
//        if(previousUncaughtExceptionHandler) {
//            previousUncaughtExceptionHandler(exception);
//        }
//    }];
//    [alert addAction:quitAction];
//    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
//}
//void installUncaughtExceptionHandler() {
//    signal(SIGABRT, mySignalHandler);
//    signal(SIGILL, mySignalHandler);
//    signal(SIGSEGV, mySignalHandler);
//    signal(SIGFPE, mySignalHandler);
//    signal(SIGBUS, mySignalHandler);
//    signal(SIGPIPE, mySignalHandler);
////    signal(SIGTRAP, mySignalHandler);
////    signal(SIGEMT, mySignalHandler);
////    signal(SIGSYS, mySignalHandler);
//}
//void mySignalHandler(int signal) {
//    // 递增一个全局计数器, 防止并发数太大
//    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
//    if(exceptionCount > UncaughtExceptionMaximum) { return; }
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:@(signal) forKey:UncaughtExceptionHandlerSignalKey];
//    NSArray *callStack = [UncaughtExceptionHandler backtrace];
//    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
//    NSException *exception = [NSException exceptionWithName:UncaughtExceptionHandlerSingnalExceptionName reason:[NSString stringWithFormat:@"Signal %d was raised.", signal] userInfo:userInfo];
//    [[[UncaughtExceptionHandler alloc] init] performSelectorOnMainThread:@selector(handleException:) withObject:exception waitUntilDone:YES];
//}
//+ (NSArray *)backtrace {
//    void* callstack[128];
//    int frames = backtrace(callstack, 128);
//    char **strs = backtrace_symbols(callstack, frames);
//    int i;
//    NSMutableArray *backtrace = [NSMutableArray array];
//    for(i = 1; i < NSThread.callStackSymbols.count; i++) {
//        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
//    }
//    free(strs);
//    return backtrace;
//}
//- (void)handleException:(NSException *)exception {
//    NSString *msg = [NSString stringWithFormat:@"You can try to continue but the application may be unstable. /n %@ %@",[exception reason], [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]];
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Unhandled exception", nil) message:msg preferredStyle:UIAlertControllerStyleAlert];
//    __weak typeof(self) weakSelf = self;
//    UIAlertAction *quitAction = [UIAlertAction actionWithTitle:@"Quit" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        //
//        weakSelf.dismissed = YES;
//    }];
//    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //
//    }];
//    [alert addAction:quitAction];
//    [alert addAction:continueAction];
//    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
//    // ----------
//    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
//    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
//    while(!_dismissed) {
//        for(NSString *mode in (__bridge NSArray *)allModes) {
//            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
//        }
//    }
//    CFRelease(allModes);
//    NSSetUncaughtExceptionHandler(NULL);
//    signal(SIGABRT,  SIG_DFL);
//    signal(SIGILL, SIG_DFL);
//    signal(SIGSEGV, SIG_DFL);
//    signal(SIGFPE, SIG_DFL);
//    signal(SIGBUS, SIG_DFL);
//    signal(SIGPIPE, SIG_DFL);
//    if([[exception name] isEqual:UncaughtExceptionHandlerSingnalExceptionName]) {
//        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
//    } else {
//        [exception raise];
//    }
//}
//
//
//@end
