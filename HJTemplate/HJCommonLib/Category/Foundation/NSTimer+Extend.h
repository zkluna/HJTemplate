//
//  NSTimer+Extend.h
//  HJTemplate
//
//  Created by zl on 2020/12/24.
//  Copyright © 2020 hhh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TimerFireBlock)(void);

@interface NSTimer (Extend)

+ (id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval firing:(TimerFireBlock)fireBlock;
+ (id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval repeating:(BOOL)repeat firing:(TimerFireBlock)fireBlock;

@end

NS_ASSUME_NONNULL_END
