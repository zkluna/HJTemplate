//
//  HJWebView.h
//  YoutilN
//
//  Created by rubick on 2019/4/16.
//  Copyright © 2019 kl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol HJWebViewDelegate <NSObject>
@optional
- (void)hj_webViewDidStartLoad;
- (void)hj_webViewDidFinishLoad;
- (void)hj_webViewFailLoad;
- (void)hj_webViewGetAndSetTitle;

@end

@interface HJWebView : UIView

@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic) NSInteger maxPage;
@property (nonatomic) NSInteger nowPage;
@property (weak, nonatomic) id<HJWebViewDelegate> myDelegate;

- (void)loadWebViewWithFilePath:(NSString *)filePath;
- (void)loadWebViewWithURLString:(NSString *)urlString;
- (void)loadWebViewWithHTMLString:(NSString *)HTMLString;

@end

NS_ASSUME_NONNULL_END
