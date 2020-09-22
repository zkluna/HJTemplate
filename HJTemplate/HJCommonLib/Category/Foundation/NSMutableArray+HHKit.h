//
//  NSMutableArray+HHKit.h
//  HKProject
//
//  Created by apple on 2017/3/22.
//  Copyright © 2017年 hjkl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (HHKit)

+ (NSMutableArray * _Nonnull)sortArrayByKey:(NSString * _Nonnull)key
                                      array:(NSMutableArray * _Nonnull)array
                                  ascending:(BOOL)ascending;

@end
