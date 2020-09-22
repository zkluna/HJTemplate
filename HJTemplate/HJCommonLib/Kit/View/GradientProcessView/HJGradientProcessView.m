//
//  HJGradientProcessView.m
//  HJTemplate
//
//  Created by rubick on 2018/12/3.
//  Copyright © 2018 LG. All rights reserved.
//

#import "HJGradientProcessView.h"
#import "UIView+HJExtension.h"
#import "UIColor+Extend.h"

#define kProcessHeight 10.0
#define kTopSpaces 5.0
#define kNumberMarkWidth 60.0
#define kNumberMarkHeight 20.0
#define kAnimationTime 3.0

@interface HJGradientProcessView()

@property (strong, nonatomic) CALayer *maskLayer;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (strong, nonatomic) UIButton *numberMark;
@property (strong, nonatomic) NSTimer *numberChangeTimer;
@property (nonatomic) CGFloat numberPercent;
@property (strong, nonatomic) NSArray *colorArray;
@property (strong, nonatomic) NSArray *colorLocationArray;

@end

@implementation HJGradientProcessView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        self.colorArray = @[
                            (id)[UIColor hj_colorWithHexStr:@"0XFF6347"],
                            (id)[UIColor hj_colorWithHexStr:@"0XFFEC8B"],
                            (id)[UIColor hj_colorWithHexStr:@"0X98FB98"],
                            (id)[UIColor hj_colorWithHexStr:@"0X00B2EE"],
                            (id)[UIColor hj_colorWithHexStr:@"0X9400D3"]];
        self.colorLocationArray = @[@0.1, @0.3, @0.5, @0.7, @1];
        self.numberMark.frame = CGRectMake(0, kTopSpaces, kNumberMarkWidth, kNumberMarkHeight);
//        self.numberMark.backgroundColor = [UIColor purpleColor];
//        [self addSubview:self.numberMark];
//        [self setNUmberMarkLayer];
        [self getGradientLayer];
        self.numberPercent = 0;
    }
    return self;
}
// 提示文字设置渐变色
- (void)setNUmberMarkLayer {
    CAGradientLayer *numberGradientLayer = [CAGradientLayer layer];
    numberGradientLayer.frame = CGRectMake(0, kTopSpaces, self.hj_width, kNumberMarkHeight);
    [numberGradientLayer setColors:self.colorArray];
    [numberGradientLayer setLocations:self.colorLocationArray];
    [numberGradientLayer setStartPoint:CGPointMake(0, 0)];
    [numberGradientLayer setEndPoint:CGPointMake(1, 0)];
    [self.layer addSublayer:numberGradientLayer];
    [numberGradientLayer setMask:self.numberMark.layer];
    self.numberMark.frame = numberGradientLayer.bounds;
}
// 进度条设置渐变色
- (void)getGradientLayer {
    // 灰色进度条背景
    CALayer *bgLayer = [CALayer layer];
    bgLayer.frame = CGRectMake(kNumberMarkWidth / 2, self.hj_height - kProcessHeight - kTopSpaces, self.hj_width - kNumberMarkWidth / 2, kProcessHeight);
    bgLayer.backgroundColor = [UIColor hj_colorWithHexStr:@"0XF5F5F5"].CGColor;
    bgLayer.masksToBounds = YES;
    bgLayer.cornerRadius = kProcessHeight / 2;
    [self.layer addSublayer:bgLayer];
    
    self.maskLayer = [CALayer layer];
    _maskLayer.frame = CGRectMake(0, 0, (self.hj_width - kNumberMarkWidth / 2) * self.percent / 100.f, kProcessHeight);
    _maskLayer.borderWidth = self.hj_height / 2;
    
    self.gradientLayer =  [CAGradientLayer layer];
    _gradientLayer.frame = CGRectMake(kNumberMarkWidth / 2, self.hj_height - kProcessHeight - kTopSpaces, self.hj_width - kNumberMarkWidth / 2, kProcessHeight);
    _gradientLayer.masksToBounds = YES;
    _gradientLayer.cornerRadius = kProcessHeight / 2;
    [_gradientLayer setColors:self.colorArray];
    [_gradientLayer setLocations:self.colorLocationArray];
    [_gradientLayer setStartPoint:CGPointMake(0, 0)];
    [_gradientLayer setEndPoint:CGPointMake(1, 0)];
    [_gradientLayer setMask:self.maskLayer];
    [self.layer addSublayer:self.gradientLayer];
}
- (void)setPercent:(CGFloat)percent {
    [self setPercent:percent animated:YES];
}
- (void)setPercent:(CGFloat)percent animated:(BOOL)animated {
    _percent = percent;
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(circleAnimation) userInfo:nil repeats:NO];
//    // 文字动画
//    __weak typeof(self)weakSelf = self;
//    [UIView animateWithDuration:kAnimationTime animations:^{
//        weakSelf.numberMark.frame = CGRectMake((weakSelf.hj_width - kNumberMarkWidth) * percent / 100, 0, kNumberMarkWidth, kNumberMarkHeight);
//        //        [weakSelf.numberMark setTitle:[NSString stringWithFormat:@"%.1f分",percent / 20.f] forState:UIControlStateNormal];
//    }];
    self.numberChangeTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeNumber) userInfo:nil repeats:YES];
}
// 每0.1秒改变百分比文字
- (void)changeNumber {
    if (!self.percent) {
        [self.numberChangeTimer invalidate];
        self.numberChangeTimer = nil;
    }
    self.numberPercent += (self.percent / (kAnimationTime * 10.f));
    if (self.numberPercent > self.percent) {
        [self.numberChangeTimer invalidate];
        self.numberChangeTimer = nil;
        self.numberPercent = self.percent;
    }
    [self.numberMark setTitle:[NSString stringWithFormat:@"%.1f",self.numberPercent] forState:UIControlStateNormal];
}
// 进度条动画
- (void)circleAnimation {
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [CATransaction setAnimationDuration:kAnimationTime];
    self.maskLayer.frame = CGRectMake(0, 0, (self.hj_width - kNumberMarkWidth / 2) * _percent / 100.f, kProcessHeight);
    [CATransaction commit];
}
- (UIButton *)numberMark {
    if (nil == _numberMark) {
        _numberMark = [UIButton buttonWithType:UIButtonTypeCustom];
        [_numberMark setTitle:@"0分" forState:UIControlStateNormal];
        [_numberMark setTitleColor:[UIColor hj_colorWithHexStr:@"0XFF6347"] forState:UIControlStateNormal];
        [_numberMark setBackgroundImage:[UIImage imageNamed:@"user_score_bubble"] forState:UIControlStateNormal];
        _numberMark.titleLabel.font = [UIFont systemFontOfSize:13.f];
        _numberMark.enabled = NO;
    }
    return _numberMark;
}

@end
