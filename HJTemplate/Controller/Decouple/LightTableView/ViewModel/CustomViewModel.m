//
//  CustomViewModel.m
//  HJTemplate
//
//  Created by zhaoke on 2020/10/11.
//  Copyright © 2020 hhh. All rights reserved.
//

#import "CustomViewModel.h"
#import "UIColor+Extend.h"
#import "CustomModel.h"

@implementation CustomViewModel

- (instancetype)init {
    if (self = [super init]) {
        ;
    }
    return self;
}
- (void)headerRefreshRequestWithCallback:(CustomVMCallback)callback {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *array = [NSMutableArray array];
        for (int i=0; i < 16; i++) {
            CustomModel *model = [[CustomModel alloc] init];
            int x = arc4random() % 100;
            NSString *string = [NSString stringWithFormat:@"random number : %d", x];
            model.title = string;
            model.color = [UIColor hj_randomColor];
            [array addObject:model];
        }
        callback(array);
    });
}
- (void)footerRefreshRequestWithCallback:(CustomVMCallback)callback {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *array = [NSMutableArray array];
        for (int i=0; i < 16; i++) {
            CustomModel *model = [[CustomModel alloc] init];
            int x = arc4random() % 100;
            NSString *string = [NSString stringWithFormat:@"random number : %d", x];
            model.title = string;
            model.color = [UIColor hj_randomColor];
            [array addObject:model];
        }
        callback(array);
    });
}

@end
