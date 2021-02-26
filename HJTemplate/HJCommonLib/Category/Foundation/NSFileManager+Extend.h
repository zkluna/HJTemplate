//
//  NSFileManager+Extend.h
//  HJTemplate
//
//  Created by zl on 2020/12/24.
//  Copyright © 2020 hhh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (Extend)

- (NSString *)temporaryDirectoryWithTemplateString:(NSString *)templateString;

@end

NS_ASSUME_NONNULL_END
