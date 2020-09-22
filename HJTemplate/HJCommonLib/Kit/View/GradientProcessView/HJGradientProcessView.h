//
//  HJGradientProcessView.h
//  HJTemplate
//
//  Created by rubick on 2018/12/3.
//  Copyright © 2018 LG. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJGradientProcessView : UIView

@property (nonatomic) CGFloat percent; // 0 - 100

- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
