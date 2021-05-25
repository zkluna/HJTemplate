//
//  HJPermenantThread.m
//  HJTemplate
//
//  Created by 曼殊 on 2021/5/25.
//  Copyright © 2021 hhh. All rights reserved.
//

#import "HJPermenantThread.h"
#import "HJThread.h"

@interface HJPermenantThread()

@property (strong, nonatomic) HJThread *myThread;
@property (assign, nonatomic, getter=isStopped) BOOL stopped;

@end
@implementation HJPermenantThread

- (instancetype)init {
    self = [super init];
    if (self) {
        __weak typeof(self) weakSelf = self;
        self.myThread = [[HJThread alloc] initWithBlock:^{
            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
            while (weakSelf && !weakSelf.isStopped) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
        }];
        [self.myThread start];
    }
    return self;
}
- (void)executeTask:(PermenantThreadTask)task {
    if (!self.myThread || !task) return;
    [self performSelector:@selector(privateExecuteTask:) onThread:self.myThread withObject:task waitUntilDone:NO];
}
- (void)stop {
    if (!self.myThread) return;
    [self performSelector:@selector(privateStopAction) onThread:self.myThread withObject:nil waitUntilDone:YES];
}
- (void)dealloc {
    [self stop];
}
- (void)privateExecuteTask:(PermenantThreadTask)task {
    task();
}
- (void)privateStopAction {
    self.stopped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.myThread = nil;
}

@end
