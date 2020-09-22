//
//  KLoadingView.m
//  kActivity
//
//  Created by rubick on 16/8/21.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import "KLoadingView.h"

#define TrigNum (180)     //一圈触发次数
#define CicleNum (90)     //半圈步数
#define TrigInterval (1)  //触发间隔
#define IgnoreNum (2)     //忽略步数

@implementation KLoadingView2 {
    CAShapeLayer *layer1;
    CAShapeLayer *layer2;
    CAShapeLayer *layer3;
    CAShapeLayer *layer4;
    CADisplayLink *animationLink;
    BOOL shouldAnimation;
    int times;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame color:[UIColor purpleColor]];
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color {
    self = [super initWithFrame:frame];
    if(self) {
        CGPoint center = CGPointMake(frame.size.width/2, frame.size.height/2);
        CGFloat r = (MIN(frame.size.width, frame.size.height))/2;
        layer1 = [CAShapeLayer layer];
        layer1.frame = self.bounds;
        layer1.fillColor = [UIColor clearColor].CGColor;
        layer1.strokeColor = color.CGColor;
        layer1.lineCap = kCALineCapRound;
        layer1.lineWidth = 3.0;
        UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:center radius:r-3 startAngle:0 endAngle:M_PI_2*4 clockwise:YES];
        layer1.path = path1.CGPath;
        [self.layer addSublayer:layer1];
        
        layer2 = [CAShapeLayer layer];
        layer2.frame = self.bounds;
        layer2.fillColor = [UIColor clearColor].CGColor;
        layer2.strokeColor = color.CGColor;
        layer2.lineCap = kCALineCapRound;
        layer2.lineWidth = 3.0;
        UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:center radius:r-3 startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES];
        layer2.path = path2.CGPath;
        [self.layer addSublayer:layer2];
        
        layer3 = [CAShapeLayer layer];
        layer3.frame = self.bounds;
        layer3.fillColor = [UIColor clearColor].CGColor;
        layer3.strokeColor = color.CGColor;
        layer3.lineCap = kCALineCapRound;
        layer3.lineWidth = 3.0;
        UIBezierPath *path3 = [UIBezierPath bezierPathWithArcCenter:center radius:r-3 startAngle:-M_PI_2*2 endAngle:M_PI_2*2 clockwise:YES];
        layer3.path = path3.CGPath;
        [self.layer addSublayer:layer3];
        
        layer4 = [CAShapeLayer layer];
        layer4.frame = self.bounds;
        layer4.fillColor = [UIColor clearColor].CGColor;
        layer4.strokeColor = color.CGColor;
        layer4.lineCap = kCALineCapRound;
        layer4.lineWidth = 3.0;
        UIBezierPath *path4 = [UIBezierPath bezierPathWithArcCenter:center radius:r-3 startAngle:-M_PI_2*3 endAngle:M_PI_2 clockwise:YES];
        layer4.path = path4.CGPath;
        [self.layer addSublayer:layer4];
        
        [self resetStroken];
        [self setBackgroundColor:[UIColor clearColor]];
        
        animationLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(stepAnimation:)];
        [animationLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        animationLink.frameInterval = TrigInterval;
        animationLink.paused = YES;
        
        [self setHidden:YES];
        times = IgnoreNum+1;
        shouldAnimation = NO;
    }
    return self;
}
- (void)startLoading {
    [self setHidden:NO];
    [self.layer removeAllAnimations];
    [UIView animateWithDuration:0.2 animations:^{
        [self setAlpha:1.0];
        [self setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)];
    } completion:^(BOOL finished) {
        animationLink.paused = NO;
    }];
}
- (void)endLoading {
    animationLink.paused = YES;
    [self.layer removeAllAnimations];
    [UIView animateWithDuration:0.4 animations:^{
        [self setAlpha:0.0];
        [self setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1)];
    } completion:^(BOOL finished) {
        [self setHidden:YES];
    }];
}
- (void)stepAnimation:(CADisplayLink *)link {
    if(times == IgnoreNum) {
        [animationLink setPaused:YES];
        [UIView animateWithDuration:0.1 animations:^{
            [self setAlpha:0];
            [self setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1)];
        } completion:^(BOOL finished) {
            [self resetStroken];
            [UIView animateWithDuration:0.2 animations:^{
                [self setAlpha:1.0];
                [self setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)];
            } completion:^(BOOL finished) {
                [animationLink setPaused:NO];
                times++;
            }];
        }];
        return;
    }
    CGFloat strokeRange = times >= CicleNum ? (0.25*((TrigNum-times)*1.0/CicleNum)) : (0.25*(times*1.0/CicleNum));
    CGFloat maxStrokeRange = 0.22;
    strokeRange = strokeRange >= maxStrokeRange ? maxStrokeRange : strokeRange;
    [UIView animateWithDuration:animationLink.duration animations:^{
        [layer1 setStrokeEnd:(times*1.0/TrigNum)];
        [layer2 setStrokeEnd:(times*1.0/TrigNum)];
        [layer3 setStrokeEnd:(times*1.0/TrigNum)];
        [layer4 setStrokeEnd:(times*1.0/TrigNum)];
        [layer1 setStrokeStart:(times*1.0/TrigNum)-strokeRange];
        [layer2 setStrokeStart:(times*1.0/TrigNum)-strokeRange];
        [layer3 setStrokeStart:(times*1.0/TrigNum)-strokeRange];
        [layer4 setStrokeStart:(times*1.0/TrigNum)-strokeRange];
    }];
    times++;
    if(times == TrigNum-IgnoreNum){
        times = IgnoreNum;
    }
}
- (void)resetStroken {
    [layer1 setStrokeEnd:(IgnoreNum*1.0/TrigNum)];
    [layer2 setStrokeEnd:(IgnoreNum*1.0/TrigNum)];
    [layer3 setStrokeEnd:(IgnoreNum*1.0/TrigNum)];
    [layer4 setStrokeEnd:(IgnoreNum*1.0/TrigNum)];
    CGFloat strokeRange = (0.25*(IgnoreNum*1.0/CicleNum));
    [layer1 setStrokeStart:(IgnoreNum*1.0/TrigNum)-strokeRange];
    [layer2 setStrokeStart:(IgnoreNum*1.0/TrigNum)-strokeRange];
    [layer3 setStrokeStart:(IgnoreNum*1.0/TrigNum)-strokeRange];
    [layer4 setStrokeStart:(IgnoreNum*1.0/TrigNum)-strokeRange];
}

@end

static const CFTimeInterval DURATION = 2;
@interface KLoadingView()

@property (nonatomic, assign) double add;
@property (nonatomic, strong) CATextLayer *textStr;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CABasicAnimation *rotateAnimation;
@property (nonatomic, strong) CABasicAnimation *strokeAnimationStart;
@property (nonatomic, strong) CABasicAnimation *strokeAnimationEnd;
@property (nonatomic, strong) CAAnimationGroup *animationGroup;

@end

@implementation KLoadingView

- (instancetype)init {
    self = [super init];
    if(self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.8;
        self.gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.frame;
        NSArray *colorArr = [NSArray arrayWithObjects:(id)[UIColor redColor].CGColor, (id)[UIColor cyanColor].CGColor, (id)[UIColor orangeColor].CGColor, (id)[UIColor greenColor].CGColor, (id)[UIColor purpleColor].CGColor, (id)[UIColor blueColor].CGColor, (id)[UIColor blackColor].CGColor, (id)[UIColor yellowColor].CGColor, (id)[UIColor magentaColor].CGColor, nil];
        [_gradientLayer setColors:colorArr];
        [_gradientLayer setStartPoint:CGPointMake(0, 0)];
        [_gradientLayer setEndPoint:CGPointMake(1, 1)];
        _gradientLayer.type = kCAGradientLayerAxial;
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath addArcWithCenter:CGPointMake(50, 50) radius:50 startAngle:0 endAngle:2 * M_PI clockwise:YES];
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.path = bezierPath.CGPath;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.strokeColor = [UIColor orangeColor].CGColor;
        _shapeLayer.strokeEnd = 0;
        _shapeLayer.strokeStart = 0;
        _shapeLayer.lineWidth = 2;
        _shapeLayer.bounds = CGRectMake(0, 0, 100, 100);
        _shapeLayer.position = CGPointMake(50, 15);
        
        _textStr = [CATextLayer layer];
        _textStr.string = @"加载中...";
        _textStr.contentsScale = [UIScreen mainScreen].scale;
        _textStr.position = CGPointMake(self.center.x, self.center.y);
        _textStr.bounds = CGRectMake(0, 0, 100, 100);
        _textStr.fontSize = 20;
        _textStr.alignmentMode = kCAAlignmentCenter;
        [_textStr addSublayer:_shapeLayer];
        
        [_gradientLayer setMask:_textStr];
        [self.layer addSublayer:_gradientLayer];
        self.add = 0.1;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(cicleAnimationTypeOne) userInfo:nil repeats:YES];
    }
    return self;
}
- (CABasicAnimation *)rotateAnimation {
    if(!_rotateAnimation) {
        _rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        _rotateAnimation.fromValue = @0;
        _rotateAnimation.toValue = @(2*M_PI);
        _rotateAnimation.duration = DURATION/2;
    }
    return _rotateAnimation;
}
- (CABasicAnimation *)strokeAnimationStart {
    if(!_strokeAnimationStart) {
        _strokeAnimationStart = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        _strokeAnimationStart.duration = DURATION/2;
        _strokeAnimationStart.fromValue = @0;
        _strokeAnimationStart.toValue = @1;
        _strokeAnimationStart.beginTime = 1;
        _strokeAnimationStart.removedOnCompletion = NO;
        _strokeAnimationStart.fillMode = kCAFillModeForwards;
        _strokeAnimationStart.repeatCount = HUGE;
    }
    return _strokeAnimationStart;
}
- (CABasicAnimation *)strokeAnimationEnd {
    if(!_strokeAnimationEnd) {
        _strokeAnimationEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        _strokeAnimationEnd.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        _strokeAnimationEnd.duration = DURATION;
        _strokeAnimationEnd.fromValue = @0;
        _strokeAnimationEnd.toValue = @1;
        _strokeAnimationEnd.removedOnCompletion
        = NO;
        _strokeAnimationEnd.fillMode = kCAFillModeForwards;
        _strokeAnimationEnd.repeatCount = HUGE;
    }
    return _strokeAnimationEnd;
}
- (CAAnimationGroup *)animationGroup {
    if(!_animationGroup) {
        _animationGroup = [CAAnimationGroup animation];
        _animationGroup.animations = @[self.strokeAnimationStart, self.strokeAnimationEnd];
        _animationGroup.repeatCount = HUGE;
        _animationGroup.duration = DURATION;
    }
    return _animationGroup;
}
- (void)startLoadingAnimating {
    [self.shapeLayer addAnimation:self.animationGroup forKey:@"group"];
    [self.shapeLayer addAnimation:self.rotateAnimation forKey:@"rotate"];
}
- (void)cicleAnimationTypeOne {
    NSMutableArray *colorArray = _gradientLayer.colors.mutableCopy;
    UIColor *lostColor = [colorArray lastObject];
    [colorArray removeLastObject];
    [colorArray insertObject:lostColor atIndex:0];
    [UIView animateWithDuration:0.5 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.gradientLayer.colors = colorArray;
    }];
}
- (void)stopLoadAnimating {
    [self.shapeLayer removeAllAnimations];
    [self removeFromSuperview];
}

@end
