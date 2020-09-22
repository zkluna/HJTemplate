//
//  HJGeneralRequest.m
//  newRn
//
//  Created by rubick on 2019/7/10.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "HJGeneralRequest.h"

@interface HJGeneralRequest()

@property (assign, nonatomic) NSInteger hj_requestMethod;
@property (strong, nonatomic) NSString *hj_requestUrl;
@property (strong, nonatomic) NSDictionary *hj_requestParam;

@end

@implementation HJGeneralRequest

- (id)initWithRequestMethod:(NSString *)method param:(NSDictionary *)dict requestUrl:(NSString *)url isNeedCache:(BOOL)isNeed {
    self = [super init];
    if(self) {
        if([method isEqualToString:@"GET"]) {
            self.hj_requestMethod = HJRequestMethodGET;
        } else if([method isEqualToString:@"POST"]) {
            self.hj_requestMethod = HJRequestMethodPOST;
        } else if([method isEqualToString:@"PUT"]) {
            self.hj_requestMethod = HJRequestMethodPUT;
        } else if([method isEqualToString:@"DELETE"]) {
            self.hj_requestMethod = HJRequestMethodDELETE;
        } else if([method isEqualToString:@"HEAD"]) {
            self.hj_requestMethod = HJRequestMethodHEAD;
        } else if([method isEqualToString:@"PATCH"]) {
            self.hj_requestMethod = HJRequestMethodPATCH;
        }
        self.hj_requestUrl = url;
        self.hj_requestParam = dict;
        self.isNeedCache = isNeed;
    }
    return self;
}

- (NSString *)requestUrl {
    return self.hj_requestUrl;
}
- (NSTimeInterval)requestTimeoutInterval {
    return self.isNeedCache ? 10 : 60;
}
- (id)requestArgument {
    return self.hj_requestParam;
}
- (HJRequestMethod)requestMethod {
    return self.hj_requestMethod;
}
- (HJRequestSerializer)requestSerializerType {
    return HJRequestSerializerJSON;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return nil;
}
- (NSInteger)cacheTimeInSeconds {
    return 60 * 3;
}

@end
