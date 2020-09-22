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


#import "UIView+AnimationExtensions.h"


@implementation UIView (AnimationExtensions)


- (void)shakeHorizontally
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 0.5;
    animation.values = @[@(-12), @(12), @(-8), @(8), @(-4), @(4), @(0) ];
    
    [self.layer addAnimation:animation forKey:@"shake"];
}


- (void)shakeVertically
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 0.5;
    animation.values = @[@(-12), @(12), @(-8), @(8), @(-4), @(4), @(0) ];
    
    [self.layer addAnimation:animation forKey:@"shake"];
}


- (void)applyMotionEffects
{
    // Motion effects are available starting from iOS 7.
    if (([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending))
    {
        
        UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                        type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalEffect.minimumRelativeValue = @(-10.0f);
        horizontalEffect.maximumRelativeValue = @( 10.0f);
        UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                      type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        verticalEffect.minimumRelativeValue = @(-10.0f);
        verticalEffect.maximumRelativeValue = @( 10.0f);
        UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
        motionEffectGroup.motionEffects = @[horizontalEffect, verticalEffect];
        
        [self addMotionEffect:motionEffectGroup];
    }
}


- (void)pulseToSize:(CGFloat)scale
           duration:(NSTimeInterval)duration
             repeat:(BOOL)repeat
{
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    pulseAnimation.duration = duration;
    pulseAnimation.toValue = [NSNumber numberWithFloat:scale];
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulseAnimation.autoreverses = YES;
    pulseAnimation.repeatCount = repeat ? HUGE_VALF : 0;
    
    [self.layer addAnimation:pulseAnimation
                      forKey:@"pulse"];
}


- (void)flipWithDuration:(NSTimeInterval)duration
               direction:(UIViewAnimationFlipDirection)direction
             repeatCount:(NSUInteger)repeatCount
             autoreverse:(BOOL)shouldAutoreverse
{
    NSString *subtype = nil;
    
    switch (direction)
    {
        case UIViewAnimationFlipDirectionFromTop:
            subtype = @"fromTop";
            break;
        case UIViewAnimationFlipDirectionFromLeft:
            subtype = @"fromLeft";
            break;
        case UIViewAnimationFlipDirectionFromBottom:
            subtype = @"fromBottom";
            break;
        case UIViewAnimationFlipDirectionFromRight:
        default:
            subtype = @"fromRight";
            break;
    }
    
    CATransition *transition = [CATransition animation];
    
    transition.startProgress = 0;
    transition.endProgress = 1.0;
    transition.type = @"flip";
    transition.subtype = subtype;
    transition.duration = duration;
    transition.repeatCount = repeatCount;
    transition.autoreverses = shouldAutoreverse;
    
    [self.layer addAnimation:transition
                      forKey:@"spin"];
}


- (void)rotateToAngle:(CGFloat)angle
             duration:(NSTimeInterval)duration
            direction:(UIViewAnimationRotationDirection)direction
          repeatCount:(NSUInteger)repeatCount
          autoreverse:(BOOL)shouldAutoreverse;
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotationAnimation.toValue = @(direction == UIViewAnimationRotationDirectionRight ? angle : -angle);
    rotationAnimation.duration = duration;
    rotationAnimation.autoreverses = shouldAutoreverse;
    rotationAnimation.repeatCount = repeatCount;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.layer addAnimation:rotationAnimation
                      forKey:@"transform.rotation.z"];
}


- (void)stopAnimation{
    [CATransaction begin];
    [self.layer removeAllAnimations];
    [CATransaction commit];
    
    [CATransaction flush];
}


- (BOOL)isBeingAnimated{
    return [self.layer.animationKeys count];
}


- (void)heartbeatViewWithDuration:(CGFloat)duration {
    float maxSize = 1.4f, durationPerBeat = 0.5f;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(0.8, 0.8, 1);
    CATransform3D scale2 = CATransform3DMakeScale(maxSize, maxSize, 1);
    CATransform3D scale3 = CATransform3DMakeScale(maxSize - 0.3f, maxSize - 0.3f, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
    
    NSArray *frameValues = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:scale1], [NSValue valueWithCATransform3D:scale2], [NSValue valueWithCATransform3D:scale3], [NSValue valueWithCATransform3D:scale4], nil];
    
    [animation setValues:frameValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.05], [NSNumber numberWithFloat:0.2], [NSNumber numberWithFloat:0.6], [NSNumber numberWithFloat:1.0], nil];
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.duration = durationPerBeat;
    animation.repeatCount = duration / durationPerBeat;
    
    [self.layer addAnimation:animation forKey:@"heartbeat"];
}

@end
