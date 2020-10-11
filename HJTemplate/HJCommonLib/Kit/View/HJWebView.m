//
//  HJWebView.m
//  YoutilN
//
//  Created by rubick on 2019/4/16.
//  Copyright © 2019 kl. All rights reserved.
//

#import "HJWebView.h"
#import "HJCommonLib.h"
#import "MBProgressHUD+JJ.h"

#define MySchemeString @"'xxx.xxx.com.cn"

@interface HJWebView()<WKUIDelegate, WKScriptMessageHandler, WKNavigationDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIImageView *historyView;
@property (nonatomic) BOOL viewLoaded;
@property (strong, nonatomic) NSMutableArray *historyStack;
@property (strong, nonatomic) UIPanGestureRecognizer *popGesture;
@property (nonatomic) CGFloat panStartX;
@property (nonatomic) BOOL beginBack;

@end

@implementation HJWebView

- (void)dealloc {
    if (_historyView) {
        [_historyView removeFromSuperview];
        _historyView = nil;
    }
}
- (instancetype)init {
    self = [super init];
    if(self) {
        [self setUpWebView];
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
         [self setUpWebView];
        [self commonInit];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if(!self.viewLoaded) {
        [self commonInit];
        self.viewLoaded = YES;
    }
    self.historyView.frame = self.bounds;
}
- (void)commonInit {
    self.historyStack = [NSMutableArray array];
    self.popGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    self.popGesture.delegate = self;
    [self.webView addGestureRecognizer:self.popGesture];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.maxPage > 0 && self.nowPage == 1){
        return NO;
    }
    if (!self.webView.canGoBack || self.historyStack.count == 0) {
        return NO;
    }
    CGPoint point = [touch locationInView:self];
    if (point.x > 50) {
        return NO;
    }
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isEqual:self.popGesture]) {
        return YES;
    } else if ([otherGestureRecognizer isEqual:self.popGesture]) {
        return NO;
    }
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
- (void)panGesture:(UIPanGestureRecognizer *)sender {
    if (self.maxPage > 0 && self.nowPage == 1) {
        return;
    }
    if (!self.webView.canGoBack || self.historyStack.count == 0) {
        return;
    }
    CGPoint point = [sender translationInView:self];
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.panStartX = point.x;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGFloat deltaX = point.x - self.panStartX;
        if (deltaX > 0) {
            CGRect rc = self.frame;
            rc.origin.x = deltaX;
            self.frame = rc;
            self.historyView.image = [[self.historyStack lastObject] objectForKey:@"preview"];
            rc.origin.x = - self.bounds.size.width/2.0f + deltaX/2.0f;
            self.historyView.frame = rc;
        }
    } else if (sender.state == UIGestureRecognizerStateEnded){
        CGFloat deltaX = point.x - self.panStartX;
        CGFloat duration = .5f;
        if (deltaX > self.bounds.size.width/4.0f) {
            [UIView animateWithDuration:(1.0f - deltaX/self.bounds.size.width) * duration animations:^{
                CGRect rc = self.frame;
                rc.origin.x = self.bounds.size.width;
                self.frame = rc;
                rc.origin.x = 0;
                self.historyView.frame = rc;
                [self.webView goBack];
            } completion:^(BOOL finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    CGRect rc = self.frame;
                    rc.origin.x = 0;
                    self.frame = rc;
                    self.historyView.image = nil;
                });
            }];
        } else{
            [UIView animateWithDuration:(deltaX/self.bounds.size.width) * duration animations:^{
                CGRect rc = self.frame;
                rc.origin.x = 0;
                self.frame = rc;
                rc.origin.x = - self.bounds.size.width/2.0f;
                self.historyView.frame = rc;
            }];
        }
    }
}
- (void)setUpWebView {
    // 设置config
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *wkUserController = [[WKUserContentController alloc] init];
//    NSString *token = [WXAccountModule getToken];
//    NSString *jsSetToken = [NSString stringWithFormat:@"localStorage.setItem(\"jsToken\",'%@');",token];
    config.userContentController = wkUserController;
//    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jsSetToken injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
//    [config.userContentController addUserScript:wkUScript];
    [wkUserController addScriptMessageHandler:self name:@"nativegettitle"];
    // 设置相关属性
    WKPreferences *preference = [[WKPreferences alloc] init];
    [preference setJavaScriptEnabled:YES];
    [preference setMinimumFontSize:4];
    [preference setJavaScriptCanOpenWindowsAutomatically:YES];
    [config setPreferences:preference];
    //
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, _kScreenWidth,self.frame.size.height)  configuration:config];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    _webView.allowsBackForwardNavigationGestures = YES;
    //    _webView.scrollView.scrollEnabled = NO;
    if(@available(iOS 11.0, *)){
        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:self.webView];
    self.backgroundColor = [UIColor whiteColor];
}
- (void)loadWebViewWithURLString:(NSString *)urlString {
    NSString *tempUrl = urlString;
    if([urlString containsString:@"?"]) {
        NSArray *temp = [urlString componentsSeparatedByString:@"?"];
        if(temp.count == 2) {
            NSString *prefixString = [temp firstObject];
            NSString *paramString = [temp lastObject];
            paramString = [paramString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            tempUrl = [NSString stringWithFormat:@"%@?%@", prefixString,  paramString];
        } else {
            [MBProgressHUD showMessage:@"链接参数有误"];
        }
    }
    NSURL *url = [NSURL URLWithString:tempUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    [self.webView loadRequest:request];
}
- (void)loadWebViewWithFilePath:(NSString *)filePath {
    NSString *allowPath = filePath;
    NSURL *url = nil;
    NSURLComponents *urlComponents = nil;
    if([filePath containsString:@"?"]) {
        NSArray *temp = [filePath componentsSeparatedByString:@"?"];
        if(temp.count == 2) {
            NSString *prefixString = [temp firstObject];
            NSString *paramString = [temp lastObject];
            url = [NSURL fileURLWithPath:prefixString];
            urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:[NSURL fileURLWithPath:allowPath]];
            [urlComponents setQuery:paramString];
        }
    } else {
        url = [NSURL fileURLWithPath:filePath];
        urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:[NSURL fileURLWithPath:allowPath]];
    }
    NSLog(@"%@", urlComponents.URL);
    [self.webView loadFileURL:urlComponents.URL allowingReadAccessToURL:[NSURL fileURLWithPath:allowPath]];
}
- (void)loadWebViewWithHTMLString:(NSString *)HTMLString {
    [self.webView loadHTMLString:HTMLString baseURL:nil];
}
#pragma mark - WKUIDelegate
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if(![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
- (void)webViewDidClose:(WKWebView *)webView {
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    [MBProgressHUD showMessage:message];
    completionHandler();
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    [alert addAction:cancel];
    [alert addAction:sure];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:prompt preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(nil);
    }];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UITextField *tf = [alert.textFields firstObject];
        completionHandler(tf.text.length > 0 ? tf.text : nil);
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = defaultText;
    }];
    [alert addAction:cancel];
    [alert addAction:sure];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}
- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo  API_AVAILABLE(ios(10.0)) {
    return YES;
}
- (UIViewController *)webView:(WKWebView *)webView previewingViewControllerForElement:(WKPreviewElementInfo *)elementInfo defaultActions:(NSArray<id<WKPreviewActionItem>> *)previewActions  API_AVAILABLE(ios(10.0)){
    return nil;
}
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL * url = [navigationAction.request URL];
    NSString *scheme = [navigationAction.request.URL scheme];
    NSString *absoluteString = url.absoluteString;
    absoluteString = [absoluteString stringByRemovingPercentEncoding];
    NSString *endPageRedirectUrl = nil;
    if([absoluteString isEqualToString:@"nativegettitle:/"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        if([self.myDelegate respondsToSelector:@selector(hj_webViewGetAndSetTitle)]){
            [self.myDelegate hj_webViewGetAndSetTitle];
        }
        return;
    }
    // 微信支付处理
    if([absoluteString hasPrefix:@"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb"] && ![absoluteString hasSuffix:[NSString stringWithFormat:@"redirect_url=%@://",MySchemeString]]) {
        NSLog(@"------%@", absoluteString);
        NSString *redirectUrl = nil;
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
            decisionHandler(WKNavigationActionPolicyCancel);
        } else {
            decisionHandler(WKNavigationActionPolicyAllow);
            return;
        }
        if([absoluteString containsString:@"redirect_url="]) {
            NSRange redirectRange = [absoluteString rangeOfString:@"redirect_url"];
            endPageRedirectUrl = [absoluteString substringFromIndex:redirectRange.location+redirectRange.length+1];
            redirectUrl = [[absoluteString substringToIndex:redirectRange.location] stringByAppendingString:[NSString stringWithFormat:@"redirect_url=%@://", MySchemeString]];
        } else {
            redirectUrl = [NSString stringWithFormat:@"%@&redirect_url=%@://", absoluteString, MySchemeString];
        }
        NSMutableURLRequest *payRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:redirectUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.5];
        payRequest.allHTTPHeaderFields = navigationAction.request.allHTTPHeaderFields;
        [payRequest setValue:MySchemeString forHTTPHeaderField:@"Referer"];
        payRequest.URL = [NSURL URLWithString:redirectUrl];
        [webView loadRequest:payRequest];
        return;
    }
    if (![scheme isEqualToString:@"https"] && ![scheme isEqualToString:@"http"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        if([scheme isEqualToString:@"weixin"]) {
            if(endPageRedirectUrl) {
                [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:endPageRedirectUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.5 ]];
            }
        }
        BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:navigationAction.request.URL];
        if(canOpen) {
            [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        }
        return;
    }
    // 支付宝支付处理
    if([scheme isEqualToString:@"alipay"]) {
        NSArray * urlBaseArr = [absoluteString componentsSeparatedByString:@"?"];
        NSString * urlBaseStr = urlBaseArr.firstObject;
        NSString * urlLaseString = urlBaseArr.lastObject;
        NSString * afterHandleStr = [urlLaseString stringByReplacingOccurrencesOfString:@"alipays" withString:MySchemeString];
        NSString * finalStr = [NSString stringWithFormat:@"%@?%@",urlBaseStr,afterHandleStr];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:finalStr]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:finalStr]];
            }
        });
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    //  准备加载
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    // 开始加载
    if([self.myDelegate respondsToSelector:@selector(hj_webViewDidStartLoad)]) {
        [self.myDelegate hj_webViewDidStartLoad];
    }
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    // 加载完成
    if([self.myDelegate respondsToSelector:@selector(hj_webViewDidFinishLoad)]) {
        [self.myDelegate hj_webViewDidFinishLoad];
    }
    // 禁止自动识别特定格式并添加下划线
    NSString *jsMeta = [NSString stringWithFormat:@"var meta = document.createElement('meta');meta.content='telephone=no';meta.name='format-detection';document.getElementsByTagName('head')[0].appendChild(meta);"];
    [webView evaluateJavaScript:jsMeta completionHandler:^(id _Nullable res, NSError * _Nullable error) {
    }];
}
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    // 加载失败
    if([self.myDelegate respondsToSelector:@selector(hj_webViewFailLoad)]) {
        [self.myDelegate hj_webViewFailLoad];
    }
//    [MBProgressHUD showError:error.description onView:nil];
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    // 加载失败
    if([self.myDelegate respondsToSelector:@selector(hj_webViewFailLoad)]) {
        [self.myDelegate hj_webViewFailLoad];
    }
}
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    completionHandler(NSURLSessionAuthChallengeUseCredential, nil);
}
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    // >= ios9.0
}
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {  // js 调用 OC方法
    NSLog(@"%@",message.name);
    if([message.name isEqualToString:@"nativegettitle"]) {
        if([self.myDelegate respondsToSelector:@selector(hj_webViewGetAndSetTitle)]) {
            [self.myDelegate hj_webViewGetAndSetTitle];
        }
    }
}

@end
