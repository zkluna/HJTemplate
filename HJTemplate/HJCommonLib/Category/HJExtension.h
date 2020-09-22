//
//  HJSearch.h
//  HJSearch
//
//  Created by rubick on 2018/3/6.
//  Copyright © 2018年 Accentrix. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSString+HJExtension.h"

#define HJLocalizbleStr(key) HJLocalizbleStrWithLan((key),nil)
#define HJLocalizbleStrWithLan(key,lan) [(key) hj_localizedStringOfLanguage:(lan)]
