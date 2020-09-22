//
//  HJWebViewController.h
//  YoutilN
//
//  Created by rubick on 2019/4/16.
//  Copyright © 2019 kl. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>
#import "HJWebView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJWebViewController : BaseViewController

@property (strong, nonatomic) HJWebView *hj_webView;
@property (nonatomic) BOOL showClose;
@property (nonatomic) NSInteger maxPage;

- (instancetype)initWithPramas:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
