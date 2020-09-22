//
//  NSData+Extend.h
//  kActivity
//
//  Created by rubick on 16/10/25.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Extend)

+ (NSData *)hexStringToData:(NSString *)string; //16进制转data
+ (NSString *)dataToHexString:(NSData *)aData ; //data转16进制
- (NSString *)detectImageSuffix;  // 图片类型

/**
 *   --z 压缩/解压
 */
- (NSData *)gzipInflate; //解压
- (NSData *)gzipDeflate; //压缩
- (NSData *)zlibInflate;
- (NSData *)zlibDeflate;

@end
