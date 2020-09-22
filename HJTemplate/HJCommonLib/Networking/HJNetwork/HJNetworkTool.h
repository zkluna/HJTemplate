
//
//  HJNetworkTool.h
//  HKProject
//
//  Created by rubick on 2018/7/29.
//  Copyright © 2018年 hjkl. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HJBaseRequest;

@interface HJNetworkTool : NSObject


/** json校验 */
+ (BOOL)validateJSON:(id)json withValidator:(id)jsonValidator;

+ (NSStringEncoding)stringEncodingWithRequest:(HJBaseRequest *)request;

/** 断点缓存判断 */
+ (BOOL)validateResumeData:(NSData *)data;

@end
