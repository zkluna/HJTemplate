//
//  BasicModel.h
//  Fghdgjnfjhgfjhm
//
//  Created by rubick on 16/10/28.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YYModel.h"
#import "HJConfig.h"

@interface BasicModel : NSObject<NSCoding, NSCopying>

@property (copy, nonatomic) hj_resultValueBlock resultBlock; 
@property (copy, nonatomic) hj_failureBlock failureBlock;
@property (copy, nonatomic) hj_errorCodeBlock errorBlock;

@end
