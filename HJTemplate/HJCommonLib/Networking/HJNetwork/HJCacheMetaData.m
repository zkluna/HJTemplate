//
//  HJCacheMetaData.m
//  HKProject
//
//  Created by rubick on 2018/7/29.
//  Copyright © 2018年 hjkl. All rights reserved.
//

#import "HJCacheMetaData.h"

@implementation HJCacheMetaData

+ (BOOL)supportsSecureCoding {
    return YES;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.version) forKey:NSStringFromSelector(@selector(version))];
    [aCoder encodeObject:self.sensitiveDataString forKey:NSStringFromSelector(@selector(sensitiveDataString))];
    [aCoder encodeObject:@(self.stringEncoding) forKey:NSStringFromSelector(@selector(stringEncoding))];
    [aCoder encodeObject:self.creationDate forKey:NSStringFromSelector(@selector(creationDate))];
    [aCoder encodeObject:self.appVersion forKey:NSStringFromSelector(@selector(appVersion))];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.version = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(version))] integerValue];
    self.sensitiveDataString = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(sensitiveDataString))];
    self.stringEncoding = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(stringEncoding))] integerValue];
    self.creationDate = [aDecoder decodeObjectOfClass:[NSDate class] forKey:NSStringFromSelector(@selector(creationDate))];
    self.appVersion = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(appVersion))];
    return self;
}

@end
