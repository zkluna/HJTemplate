//
//  NSTimer+Extend.m
//  HJTemplate
//
//  Created by zl on 2020/12/24.
//  Copyright © 2020 hhh. All rights reserved.
//

#import "NSTimer+Extend.h"

@implementation NSTimer (Extend)

+ (void)executeTimerBlock:(NSTimer *)timer {
    TimerFireBlock block = [timer userInfo];
    block();
}
+ (id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval firing:(TimerFireBlock)fireBlock {
    return [self scheduledTimerWithTimeInterval:inTimeInterval repeating:NO firing:fireBlock];
}
+ (id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval repeating:(BOOL)repeat firing:(TimerFireBlock)fireBlock {
    id block = [fireBlock copy];
    return [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(executeTimerBlock:) userInfo:block repeats:repeat];
}

@end
