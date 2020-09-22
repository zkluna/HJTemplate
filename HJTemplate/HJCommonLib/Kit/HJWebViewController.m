//
//  HJWebViewController.m
//  YoutilN
//
//  Created by rubick on 2019/4/16.
//  Copyright © 2019 kl. All rights reserved.
//

#import "HJWebViewController.h"
#import "UIView+HJExtension.h"
#import "UIColor+Extend.h"

#define PayFininshNotification @"PayFininshNotification"

@interface HJWebViewController ()<HJWebViewDelegate>

@property (strong, nonatomic) NSDictionary *pramas;
@property (strong, nonatomic) UIProgressView *progress;
@property (nonatomic) BOOL isShare;
@property (strong, nonatomic) UIButton *shareBtn;

@end

@implementation HJWebViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.hj_webView.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
- (instancetype)initWithPramas:(NSDictionary *)params {
    self = [super init];
    if(self) {
        self.pramas = params;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self preferredStatusBarStyle];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHidden) name:UIKeyboardWillHideNotification object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    _hj_webView = [[HJWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.hj_width, self.view.hj_height)];
    [self.view addSubview:self.hj_webView];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.hj_webView.myDelegate = self;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webViewReload:) name:KeyWebViewReload object:nil];
    
    self.progress = [[UIProgressView alloc] initWithFrame:(CGRect){0, 0, self.view.hj_width, 2}];
    self.progress.progressTintColor = [UIColor hj_colorWithHexStr:@"348AF0"];
    self.progress.trackTintColor = [UIColor whiteColor];
    self.progress.progress = 0;
    self.progress.hidden = YES;
    [self.view addSubview:self.progress];
    self.hj_webView.maxPage = self.maxPage;
    if ([self.pramas[@"name"] length] > 0) {
        self.title = self.pramas[@"name"];
    }
    if ([self.pramas[@"rightTitle"] length] > 0) {
        [self setRightItemTitle:self.pramas[@"rightTitle"]];
    }
    if([self.pramas[@"isShare"] isEqualToString:@"true"]) {
        self.isShare = YES;
        [self setRightItemImage:[UIImage imageNamed:@"general_share_icon"]];
    } else {
        self.isShare = NO;
    }
    if (self.showClose) {
        [self setLeftItemTitle:@"返回"];
    }
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFinishNotification:) name:PayFininshNotification object:nil];
    [self loadWebViewData];
}
- (void)loadWebViewData {
    NSString *params = self.pramas[@"url"];
    if([params hasPrefix:@"http"]){
        [self.hj_webView loadWebViewWithURLString:params];
    } else if([params hasPrefix:@"file//"]){
        params = [params substringFromIndex:6];
        [self.hj_webView loadWebViewWithFilePath:params];
    } else if([params hasPrefix:@"/"]){
        [self.hj_webView loadWebViewWithFilePath:params];
    } else if([params hasPrefix:@"<"]) {
        [self.hj_webView loadWebViewWithHTMLString:params];
    } else  {
        if([params containsString:@"?"]) {
            params = [NSString stringWithFormat:@"%@&token=%@",params,@"xxx"];
        } else {
            params = [NSString stringWithFormat:@"%@?token=%@",params,@"xxx"];
        }
        [self.hj_webView loadWebViewWithURLString:params];
    }
    self.progress.hidden = NO;
    [self.hj_webView.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)payFinishNotification:(NSNotification *)notification {
    [self backAction];
}
- (void)handleDisplayLink {
    [self.hj_webView.webView evaluateJavaScript:@"document.title" completionHandler:^(NSString *titleName, NSError * _Nullable error) {
        if(!error) {
            self.title = titleName;
        }
    }];
}
- (void)shareInfo:(nonnull NSString *)message { }

// WKWebView进度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if(object == self.hj_webView.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newProgress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if(self.progress) {
            self.progress.progress = newProgress;
        }
    }
}
#pragma mark -
- (void)hj_webViewGetAndSetTitle {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self handleDisplayLink];
    });
}
- (void)hj_webViewDidStartLoad {
    self.progress.hidden = NO;
}
- (void)hj_webViewDidFinishLoad {
    self.progress.hidden = YES;
    if ([self.self.pramas[@"name"] length] <= 0) {
        [self.hj_webView.webView evaluateJavaScript:@"document.title" completionHandler:^(NSString *titleName, NSError * _Nullable error) {
            if(!error) {
                self.title = titleName;
            }
        }];
        [self.view layoutIfNeeded];
    }
}
- (void)hj_webViewFailLoad {
    self.progress.hidden = YES;
    self.title = @"加载失败";
}
#pragma mark - NavigationBarItem Action
- (void)backAction {
    if (self.hj_webView.maxPage > 0 && self.hj_webView.nowPage == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.hj_webView.webView.canGoBack) {
        [self.hj_webView.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)rightBtnAction {
   
}
- (void)closeAction {
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)webViewReload:(NSNotification *)notification {
    NSString *object = notification.object;
    NSString *params = self.pramas[@"url"];
    if ([object isEqualToString:params]) {
        [self.hj_webView.webView reload];
    }
}
- (void)keyBoardHidden {
    self.hj_webView.webView .scrollView.contentOffset = CGPointMake(0, 0);
}
@end
