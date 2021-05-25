//
//  HJButton.h
//  HJTemplate
//
//  Created by 曼殊 on 2021/5/21.
//  Copyright © 2021 hhh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^hjClickBlock)(void);

@interface HJButton : UIButton

@property (copy, nonatomic) hjClickBlock click;

@end

NS_ASSUME_NONNULL_END
