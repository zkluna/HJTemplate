//
//  KLoadingView.h
//  kActivity
//
//  Created by rubick on 16/8/21.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJCommonLib.h"

@interface KLoadingView2 : UIImageView

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color;
- (void)startLoading;
- (void)endLoading;

@end

@interface KLoadingView : UIView

- (void)startLoadingAnimating;
- (void)stopLoadAnimating;

@end
