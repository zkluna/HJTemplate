//
//  HJPermenantThread.h
//  HJTemplate
//
//  Created by 曼殊 on 2021/5/25.
//  Copyright © 2021 hhh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PermenantThreadTask)(void);

@interface HJPermenantThread : NSObject

- (void)executeTask:(PermenantThreadTask)task;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
