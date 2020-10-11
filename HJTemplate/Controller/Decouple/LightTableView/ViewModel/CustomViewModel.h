//
//  CustomViewModel.h
//  HJTemplate
//
//  Created by zhaoke on 2020/10/11.
//  Copyright © 2020 hhh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CustomVMCallback) (NSArray *array);

@interface CustomViewModel : NSObject

- (void)headerRefreshRequestWithCallback:(CustomVMCallback)callback;
- (void)footerRefreshRequestWithCallback:(CustomVMCallback)callback;

@end

NS_ASSUME_NONNULL_END
