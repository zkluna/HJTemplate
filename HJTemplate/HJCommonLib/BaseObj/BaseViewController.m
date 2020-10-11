//
//  BaseViewController.m
//  HJTemplate
//
//  Created by zhaoke on 2019/1/25.
//  Copyright © 2019 LG. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD+JJ.h"

@interface BaseViewController ()

@property (strong, nonatomic) UIBarButtonItem *rightBtnItem;
@property (strong, nonatomic) UIBarButtonItem *leftBtnItem;
@property (strong, nonatomic) UIBarButtonItem *hideBackItem;

@property (strong, nonatomic) UILabel *cTitleLab;
@property (strong, nonatomic) UIButton *cRightBtn;
@property (strong, nonatomic) UIButton *cLeftBtn;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 隐藏文字
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
}
- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        //        _sessionManager.requestSerializer.timeoutInterval = 90.f;
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/plain",@"text/javascript",@"text/xml",@"image/*", nil];
    }
    return _sessionManager;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if(self.cTitleLab) {
        [self.cTitleLab removeFromSuperview];
        self.cTitleLab = nil;
    }
    if(self.cRightBtn) {
        [self.cRightBtn removeFromSuperview];
        self.cRightBtn = nil;
    }
    if(self.cLeftBtn) {
        [self.cLeftBtn removeFromSuperview];
        self.cLeftBtn = nil;
    }
}
- (void)dealloc {
//    [_sessionManager invalidateSessionCancelingTasks:YES];
    [self setSessionManager:nil];
}
- (void)showErrorPromptActionWithError:(NSError *)error {
    // code for error
    [MBProgressHUD showError:error.localizedDescription];
}
- (BOOL)shouldBePoppedFromNavigation:(UINavigationController *)navigation {
    return YES;
}
- (void)willBePoppedFromNavigation:(UINavigationController *)navigation {
    // code for pop
    [self cancelRequestAction];
}
- (void)cancelRequestAction {
//    [[self sessionManager] invalidateSessionCancelingTasks:YES];
    [[[self sessionManager] tasks] enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cancel];
    }];
    [self setSessionManager:nil];
}
#pragma mark -
- (void)hj_setCustomTitle:(NSString *)title {
    if(!_cTitleLab){
        _cTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(64, 0, self.view.frame.size.width-64*2, 44)];
        _cTitleLab.textAlignment = NSTextAlignmentCenter;
        _cTitleLab.textColor = [UIColor whiteColor];
        _cTitleLab.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        _cTitleLab.textColor = [UIColor whiteColor];
        [self.navigationController.navigationBar addSubview:_cTitleLab];
    }
    [_cTitleLab setText:title];
}
- (void)hj_setCustomRightItemTile:(NSString *)title {
    if(!_cRightBtn){
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [rightBtn setFrame:CGRectMake(self.view.frame.size.width-64, 0, 44, 44)];
        rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [rightBtn setTintColor:[UIColor whiteColor]];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [rightBtn addTarget:self action:@selector(hj_customRightItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addSubview:rightBtn];
        _cRightBtn = rightBtn;
    }
    [_cRightBtn setTitle:title forState:UIControlStateNormal];
}
- (void)hj_setCustomRightItemImage:(UIImage *)image {
    if(!_cRightBtn){
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [rightBtn setFrame:CGRectMake(self.view.frame.size.width-64, 0, 44, 44)];
        rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [rightBtn setTintColor:[UIColor whiteColor]];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [rightBtn addTarget:self action:@selector(hj_customRightItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addSubview:rightBtn];
        _cRightBtn = rightBtn;
    }
    [_cRightBtn setImage:image forState:UIControlStateNormal];
}
- (void)hj_setCustomLeftItemTitle:(NSString *)title {
    if(!_cLeftBtn){
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [rightBtn setFrame:CGRectMake(20, 0, 44, 44)];
        rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [rightBtn setTintColor:[UIColor whiteColor]];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [rightBtn addTarget:self action:@selector(hj_customLeftItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addSubview:rightBtn];
        _cLeftBtn = rightBtn;
    }
    [_cLeftBtn setTitle:title forState:UIControlStateNormal];
}
- (void)hj_setCustomLeftItemImage:(UIImage *)Image {
    if(!_cLeftBtn){
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [rightBtn setFrame:CGRectMake(20, 0, 44, 44)];
        rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [rightBtn setTintColor:[UIColor whiteColor]];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [rightBtn addTarget:self action:@selector(hj_customLeftItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addSubview:rightBtn];
        _cLeftBtn = rightBtn;
    }
    [_cLeftBtn setImage:Image forState:UIControlStateNormal];
}
- (void)hj_customLeftItemAction:(id)sender {
    
}
- (void)hj_customRightItemAction:(id)sender {
    
}
#pragma mark - Method For BarBtnItem
- (void)setLeftItemTitle:(NSString *)title {
    UIButton *button = [self createBarItemButtonWithTitle:title];
    [button addTarget:self action:@selector(leftItemAction:) forControlEvents:UIControlEventTouchUpInside];
    if (_leftBtnItem == nil) {
        _leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    } else {
        [_leftBtnItem setCustomView:button];
    }
    [self.navigationItem setLeftBarButtonItem:_leftBtnItem animated:YES];
}
- (void)setLeftItemImage:(UIImage *)image {
    UIButton *button = [self createBarItemButtonWithImage:image];
    [button addTarget:self action:@selector(leftItemAction:) forControlEvents:UIControlEventTouchUpInside];
    if (_leftBtnItem == nil) {
        _leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    } else {
        [_leftBtnItem setCustomView:button];
    }
    [self.navigationItem setLeftBarButtonItem:_leftBtnItem animated:YES];
}
- (void)setRightItemTitle:(NSString *)title {
    UIButton *button = [self createBarItemButtonWithTitle:title];
    [button addTarget:self action:@selector(rightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    if (_rightBtnItem == nil) {
        _rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    } else {
        [_rightBtnItem setCustomView:button];
    }
    [self.navigationItem setRightBarButtonItem:_rightBtnItem animated:YES];
}
- (void)setRightItemImage:(UIImage *)image {
    UIButton *button = [self createBarItemButtonWithImage:image];
    [button addTarget:self action:@selector(rightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    if (_rightBtnItem == nil) {
        _rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    } else {
        [_rightBtnItem setCustomView:button];
    }
    [self.navigationItem setRightBarButtonItem:_rightBtnItem animated:YES];
}
- (void)leftItemAction:(id)sender {
    
}
- (void)rightItemAction:(id)sender {
    
}
- (void)addLeftItemImage:(UIImage *)image {
    UIButton *button = [self createBarItemButtonWithImage:image];
    [button addTarget:self action:@selector(leftItemAction:) forControlEvents:UIControlEventTouchUpInside];
    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:self.navigationItem.leftBarButtonItems];
    [items addObject:[[UIBarButtonItem alloc] initWithCustomView:button]];
    if ([items count] == 1) {
        self.leftBtnItem = self.navigationItem.leftBarButtonItem;
    }
    [self.navigationItem setLeftBarButtonItems:items];
}
- (void)addLeftItemTitle:(NSString *)title {
    UIButton *button = [self createBarItemButtonWithTitle:title];
    [button addTarget:self action:@selector(leftItemAction:) forControlEvents:UIControlEventTouchUpInside];
    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:self.navigationItem.leftBarButtonItems];
    [items addObject:[[UIBarButtonItem alloc] initWithCustomView:button]];
    if ([items count] == 1) {
        self.leftBtnItem = self.navigationItem.leftBarButtonItem;
    }
    [self.navigationItem setLeftBarButtonItems:items];
}
- (void)addRightItemImage:(UIImage *)image {
    UIButton *button = [self createBarItemButtonWithImage:image];
    [button addTarget:self action:@selector(rightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:self.navigationItem.rightBarButtonItems];
    [items addObject:[[UIBarButtonItem alloc] initWithCustomView:button]];
    if ([items count] == 1) {
        self.rightBtnItem = self.navigationItem.rightBarButtonItem;
    }
    [self.navigationItem setRightBarButtonItems:items];
}
- (void)addRightItemTitle:(NSString *)title {
    UIButton *button = [self createBarItemButtonWithTitle:title];
    [button addTarget:self action:@selector(rightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:self.navigationItem.rightBarButtonItems];
    [items addObject:[[UIBarButtonItem alloc] initWithCustomView:button]];
    if ([items count] == 1) {
        self.rightBtnItem = self.navigationItem.rightBarButtonItem;
    }
    [self.navigationItem setRightBarButtonItems:items];
}
- (UIButton *)createBarItemButtonWithTitle:(NSString *)title {
    UIFont *font = [UIFont systemFontOfSize:14];
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:font];
    [button setExclusiveTouch:YES];
    CGRect btnRect = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine) attributes:@{NSFontAttributeName:font} context:nil];
    [button setFrame:btnRect];
    return button;
}
- (UIButton *)createBarItemButtonWithImage:(UIImage *)image {
    UIButton *button = [[UIButton alloc] init];
    [button setImage:image forState:UIControlStateNormal];
    [button setExclusiveTouch:YES];
    [button setFrame:CGRectMake(0, 0, image.size.width+10, image.size.height+10)];
    return button;
}

@end
