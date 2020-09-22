//
//  Created by Rafal Sroka
//
//  License CC0.
//  This is free and unencumbered software released into the public domain.
//
//  Anyone is free to copy, modify, publish, use, compile, sell, or
//  distribute this software, either in source code form or as a compiled
//  binary, for any purpose, commercial or non-commercial, and by any means.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 @brief Direction of flip animation.
 */
typedef NS_ENUM(NSUInteger, UIViewAnimationFlipDirection)
{
    UIViewAnimationFlipDirectionFromTop = 0,
    UIViewAnimationFlipDirectionFromLeft,
    UIViewAnimationFlipDirectionFromRight,
    UIViewAnimationFlipDirectionFromBottom,
};


/**
 @brief Direction of rotation animation.
 */
typedef NS_ENUM(NSUInteger, UIViewAnimationRotationDirection)
{
    UIViewAnimationRotationDirectionRight = 0,
    UIViewAnimationRotationDirectionLeft
};
typedef NS_ENUM(NSInteger, UIViewLinearGradientDirection) {
    UIViewLinearGradientDirectionVertical = 0,
    UIViewLinearGradientDirectionHorizontal,
    UIViewLinearGradientDirectionDiagonalFromLeftToRightAndTopToDown,
    UIViewLinearGradientDirectionDiagonalFromLeftToRightAndDownToTop,
    UIViewLinearGradientDirectionDiagonalFromRightToLeftAndTopToDown,
    UIViewLinearGradientDirectionDiagonalFromRightToLeftAndDownToTop
};

@interface UIView (AnimationExtensions)


- (void)shakeHorizontally;
- (void)shakeVertically;

- (void)applyMotionEffects;

- (void)pulseToSize:(CGFloat)scale
           duration:(NSTimeInterval)duration
             repeat:(BOOL)repeat;

- (void)flipWithDuration:(NSTimeInterval)duration
               direction:(UIViewAnimationFlipDirection)direction
             repeatCount:(NSUInteger)repeatCount
             autoreverse:(BOOL)shouldAutoreverse;

- (void)rotateToAngle:(CGFloat)angle
             duration:(NSTimeInterval)duration
            direction:(UIViewAnimationRotationDirection)direction
          repeatCount:(NSUInteger)repeatCount
          autoreverse:(BOOL)shouldAutoreverse;

- (void)stopAnimation;

- (BOOL)isBeingAnimated;

/**  --z BFKit Extension  **/
- (void)heartbeatViewWithDuration:(CGFloat)duration;

@end
