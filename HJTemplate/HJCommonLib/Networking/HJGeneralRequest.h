//
//  HJGeneralRequest.h
//  newRn
//
//  Created by rubick on 2019/7/10.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "HJRequest.h"
#import "HJNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJGeneralRequest : HJRequest

- (id)initWithRequestMethod:(NSString *)method param:(NSDictionary *)dict requestUrl:(NSString *)url isNeedCache:(BOOL)isNeed;

@end

NS_ASSUME_NONNULL_END
