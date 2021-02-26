//
//  JTNavigationController.h
//  HJTemplate
//
//  Created by 曼殊 on 2021/2/26.
//  Copyright © 2021 hhh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTNavigationController : UINavigationController

@property (strong, nonatomic) UIImage *backBtnImage;
@property (assign, nonatomic) BOOL screenPopGestureEnabled;
@property (copy, nonatomic, readonly) NSArray *jt_viewControllers;

@end

NS_ASSUME_NONNULL_END
