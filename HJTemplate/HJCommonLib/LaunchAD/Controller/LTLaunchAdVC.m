//
//  LTLaunchAdVC.m
//  LaoTieWallet
//
//  Created by rubick on 2018/11/6.
//  Copyright © 2018 LG. All rights reserved.
//

#import "LTLaunchAdVC.h"
#import "HJCustomTabBarC.h"
#import "LTLaunchADTool.h"
#import "HJCommonLib.h"

@interface LTLaunchAdVC ()

@property (strong, nonatomic) UIImageView *launchImageView;
@property (strong, nonatomic) UIButton *jumpBtn;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) int timeSecond;

@end

@implementation LTLaunchAdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.timeSecond = 0;
    [self setUpSubViewForAd];
    [self setUpTimer];
}
- (void)setUpSubViewForAd {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.backgroundColor = [UIColor whiteColor];
    self.launchImageView = imageView;
    [self.view addSubview:_launchImageView];

    UIButton *skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [skipBtn setFrame:CGRectMake(self.view.frame.size.width-110, SafeAreaTopHeight-44, 90, 40)];
    skipBtn.backgroundColor = [UIColor whiteColor];
    [skipBtn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
    [skipBtn setTitle:@"3S跳过" forState:UIControlStateNormal];
    [skipBtn addTarget:self action:@selector(jumpAction:) forControlEvents:UIControlEventTouchUpInside];
    skipBtn.layer.cornerRadius = 20;
    skipBtn.layer.masksToBounds = YES;
    self.jumpBtn = skipBtn;
    [self.view addSubview:_jumpBtn];
}
- (void)setUpTimer {
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerFlow) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    if(self.launcheImage){
        self.launchImageView.image = self.launcheImage;
    } else {
        [self jumpAction:nil];
    }
}
- (void)timerFlow {
    [self.jumpBtn setTitle:[NSString stringWithFormat:@"%dS跳过",3 - self.timeSecond] forState:UIControlStateNormal];
    self.timeSecond += 1;
    if(self.timeSecond > 3){
        [self jumpAction:nil];
    }
}
- (void)jumpAction:(UIButton *)sender {
    if([self.timer isValid]){
        [self.timer invalidate];
    }
    self.timer = nil;
    if(self.isViewLoaded && self.view.window) {
        [LTLaunchADTool switchRootControllerToMainVCAnimation:YES];
    }
}
@end
