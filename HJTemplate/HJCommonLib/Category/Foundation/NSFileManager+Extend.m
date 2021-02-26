//
//  NSFileManager+Extend.m
//  HJTemplate
//
//  Created by zl on 2020/12/24.
//  Copyright © 2020 hhh. All rights reserved.
//

#import "NSFileManager+Extend.h"

@implementation NSFileManager (Extend)

- (NSString *)temporaryDirectoryWithTemplateString:(NSString *)templateString {
    NSString *mkdTemplate = [NSTemporaryDirectory() stringByAppendingPathComponent:templateString];
    const char *templateCString = [mkdTemplate fileSystemRepresentation];
    char *buffer = (char *)malloc(strlen(templateCString) + 1);
    strcpy(buffer, templateCString);
    NSString *directoryPath = nil;
    char *result = mkdtemp(buffer);
    if (result) {
        directoryPath = [self stringWithFileSystemRepresentation:buffer length:strlen(result)];
    }
    return directoryPath;
}

@end
