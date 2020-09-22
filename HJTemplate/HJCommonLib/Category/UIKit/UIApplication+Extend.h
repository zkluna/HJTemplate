//
//  UIApplication+Extend.h
//  kActivity
//
//  Created by rubick on 16/10/26.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIApplication (Extend)

/**
 *  --z path for document/cache/library
 */
- (NSURL *)documentsURL;
- (NSString *)documentsPath;

- (NSURL *)cachesURL;
- (NSString *)cachesPath;

- (NSURL *)libraryURL;
- (NSString *)libraryPath;

/**
 *  --z app infos
 */
- (NSString *)appBundleName;
- (NSString *)appBundleID;

@end
