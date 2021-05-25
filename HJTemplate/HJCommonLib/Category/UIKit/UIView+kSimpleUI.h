//
//  UIView+kSimpleUI.h
//  kActivity
//
//  Created by rubick on 16/8/18.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJCommonLib.h"

@interface UIView (kSimpleUI)<CAAnimationDelegate>

- (nullable UIViewController *)superVC;
/**
 *  --z load view
 */
+ (nullable instancetype)initViewFromXibAtIndex:(NSInteger)index;
- (void)setBorder:(nullable UIColor *)color width:(CGFloat)width;
- (void)setLayerShadow:(nullable UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;
- (void)createCornerRadiusShadowWithCornerRadius:(CGFloat)cornerRadius offset:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius;
- (void)shakeView;

- (void)removeAllSubviews;
- (nullable UIImage *)capetureImage; // 截屏图片
- (nullable NSData *)capeturePDF;
/**
 *  --z Animation
 */
- (void)rotateViewIndefinitelyInDurationPerLoop:(NSTimeInterval)duration isClockWise:(BOOL)isClockWise;
- (void)removeRotateAnimtion;

- (void)duangShowAnimation:(void(^ _Nullable)(void))finishAction;
- (void)duangHideAnimation:(void(^ _Nullable)(void))finishAction;
- (void)shakeAnimation:(void(^ _Nullable)(void))finishAction;

@end
