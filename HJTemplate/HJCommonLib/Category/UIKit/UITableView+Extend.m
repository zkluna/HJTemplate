//
//  UITableView+Extend.m
//  kActivity
//
//  Created by rubick on 16/10/26.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import "UITableView+Extend.h"
#import "NSObject+categoryProperty.h"
#import "UILabel+Extend.h"
#import "UIView+kSimpleUI.h"
#import "UIView+HJExtension.h"
#import "UIColor+Extend.h"

#define HeightHeader 60
#define HeightTailer 60
#define DefaultDelegateKey @"refreshDegault"
#define HeaderRefreshKey @"HeaderRefreshKey"
#define TailerRefreshKey @"TailerRefreshKey"
#define OriginInsetsKey  @"OriginInsetsKey"
#define WindowSize ([UIScreen mainScreen].bounds.size)


@implementation UITableView (Extend)

- (void)clearWhenDealloc {
    [self clearPropertyValue];
}
- (id<TableViewRefreshDefaultDelegate>)getRefreshDefault {
    id<TableViewRefreshDefaultDelegate> delegate = [self objectPropertyValueForKey:DefaultDelegateKey];
    if (!delegate) {
        delegate = [[RefreshDefault alloc]init];
        [self setObjectPropertyValue:delegate forKey:DefaultDelegateKey];
    }
    return delegate;
}
- (void)setNeedHeaderRefresh {
    id<TableViewRefreshDefaultDelegate> delegate = [self getRefreshDefault];
    UIView *headerView = [delegate refreshHeaderView];
    [self addSubview:headerView];
    [self sendSubviewToBack:headerView];
    headerView.hj_y = 0-headerView.hj_height;
    [delegate setRefreshView:headerView withState:StateNormal];
    [self setOriginEdgeInsets:self.contentInset];
    [self setObjectPropertyValue:@"" forKey:HeaderRefreshKey];
}
- (void)setNeedTailerRefresh {
    id<TableViewRefreshDefaultDelegate> delegate = [self getRefreshDefault];
    UIView *tailerView = [delegate refreshTailerView];
    [self addSubview:tailerView];
    [self sendSubviewToBack:tailerView];
    [delegate setRefreshView:tailerView withState:StateNormal];
    [self setObjectPropertyValue:@"" forKey:TailerRefreshKey];
    [self reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([delegate refreshTailerView].superview) {
            UIView *view = [delegate refreshTailerView];
            view.hj_y = self.contentSize.height;
        }
    });
}
- (void)removeRefresh {
    id<TableViewRefreshDefaultDelegate> delegate = [self getRefreshDefault];
    UIView *headerView = [delegate refreshHeaderView];
    [headerView removeFromSuperview];
    UIView *tailerView = [delegate refreshTailerView];
    [tailerView removeFromSuperview];
    if ([self objectPropertyValueForKey:OriginInsetsKey]) {
        UIEdgeInsets insets = [self originEdgeInsets];
        [UIView animateWithDuration:0.5 animations:^{
            self.contentInset = insets;
        } completion:^(BOOL finished) {
        }];
        [delegate setRefreshView:headerView withState:StateNormal];
        [delegate setRefreshView:tailerView withState:StateNormal];
        [self removePropertyValueForKey:TailerRefreshKey];
        [self removePropertyValueForKey:HeaderRefreshKey];
    }
    
}
- (void)setOriginEdgeInsets:(UIEdgeInsets)insets {
    if (![self objectPropertyValueForKey:OriginInsetsKey]) {
        [self setObjectPropertyValue:[NSValue valueWithUIEdgeInsets:insets] forKey:OriginInsetsKey];
    }
}
- (UIEdgeInsets)originEdgeInsets {
    [self setOriginEdgeInsets:self.contentInset];
    NSValue *value = [self  objectPropertyValueForKey:OriginInsetsKey];
    return [value UIEdgeInsetsValue];
}
- (void)refreshTableViewDidScroll {
    id<TableViewRefreshDefaultDelegate> delegate = [self getRefreshDefault];
    if ([delegate headerState] == StateInRefresh || [delegate tailerState] == StateInRefresh) {
        return;
    }
    CGFloat headerToggleHeight = [delegate refreshheaderViewStateToggleBorder];
    CGFloat tailerToggleHeight = [delegate refreshTailerViewStateToggleBorder];
    UIView *view = nil;
    TableRefreshState state = StateNormal;
    UIEdgeInsets insets = self.contentInset;
    if ([self objectPropertyValueForKey:OriginInsetsKey]) {
        insets = [self originEdgeInsets];
    }
    if (self.contentOffset.y <= -1*(insets.top+headerToggleHeight)) {
        if ([self objectPropertyValueForKey:HeaderRefreshKey]) {
            view = [delegate refreshHeaderView];
            state = statePreRefresh;
        }
    } else if (ceil(self.contentOffset.y) >= floor(self.contentSize.height - self.hj_height + tailerToggleHeight)) {
        if ([self objectPropertyValueForKey:TailerRefreshKey]) {
            view = [delegate refreshTailerView];
            state = statePreRefresh;
            view.hj_y = self.contentSize.height;
        }
    } else {
        if ([self objectPropertyValueForKey:HeaderRefreshKey] && [delegate headerState] != StateNormal) {
            view = [delegate refreshHeaderView];
        }
        if ([self objectPropertyValueForKey:TailerRefreshKey] && [delegate tailerState] != StateNormal) {
            view = [delegate refreshTailerView];
        }
    }
    BOOL isHeader = [[delegate refreshHeaderView] isEqual:view];
    BOOL needCallDeleaget = YES;
    if (isHeader) {
        needCallDeleaget = ([delegate headerState] != state);
    } else {
        needCallDeleaget = ([delegate tailerState] != state);
    }
    if (needCallDeleaget) {
        SEL selector = @selector(tableView:willSetRefreshState:isHeader:);
        if ([self.delegate respondsToSelector:selector]) {
            if (selector) {
                IMP imp = [(NSObject *)self.delegate methodForSelector:selector];
                if (imp) {
                    void (*func)(id, SEL, UITableView*, TableRefreshState, BOOL) = (void *)imp;
                    func(self.delegate, selector, self, state, isHeader);
                }
            }
        }
    }
    [delegate setRefreshView:view withState:state];
    if (needCallDeleaget) {
        SEL selector = @selector(tableView:didSetRefreshState:isHeader:);
        if ([self.delegate respondsToSelector:selector]) {
            if (selector) {
                IMP imp = [(NSObject *)self.delegate methodForSelector:selector];
                if (imp) {
                    void (*func)(id, SEL,   UITableView*, TableRefreshState, BOOL) = (void *)imp;
                    func(self.delegate, selector, self, state, isHeader);
                }
            }
        }
    }
}

- (void)refreshTableViewDidEndDrag {
    //    使用下拉刷新，第一次没有数据的时候，如果有下面代码会不能下拉刷新//
    //    if (self.contentSize.height <= 0) {
    //        return;
    //    }
    id<TableViewRefreshDefaultDelegate> delegate = [self objectPropertyValueForKey:DefaultDelegateKey];
    UIView *view = nil;
    if (self.contentOffset.y < 0) {
        view = [delegate refreshHeaderView];
    } else {
        view = [delegate refreshTailerView];
    }
    BOOL isHeader = [[delegate refreshHeaderView] isEqual:view];
    BOOL needCallDeleaget = YES;
    if (isHeader) {
        [self setOriginEdgeInsets:self.contentInset];
        needCallDeleaget = ([delegate headerState] == statePreRefresh);
    } else {
        [self setOriginEdgeInsets:self.contentInset];
        needCallDeleaget = ([delegate tailerState] == statePreRefresh);
    }
    if (needCallDeleaget) {
        if (isHeader) {
            CGFloat headerToggleHeight = [delegate refreshheaderViewStateToggleBorder];
            UIEdgeInsets insets = [self originEdgeInsets];
            insets.top += headerToggleHeight;
            self.contentInset = insets;
        } else {
            CGFloat tailerToggleHeight = [delegate refreshTailerViewStateToggleBorder];
            UIEdgeInsets insets = [self originEdgeInsets];
            insets.bottom += tailerToggleHeight;
            self.contentInset = insets;
        }
    }
    if (needCallDeleaget) {
        SEL selector = @selector(tableView:willSetRefreshState:isHeader:);
        if ([self.delegate respondsToSelector:selector]) {
            if (selector) {
                IMP imp = [(NSObject *)self.delegate methodForSelector:selector];
                if (imp) {
                    void (*func)(id, SEL, UITableView*, TableRefreshState, BOOL) = (void *)imp;
                    func(self.delegate, selector, self, StateInRefresh, isHeader);
                }
            }
        }
        [delegate setRefreshView:view withState:StateInRefresh];
        selector = @selector(tableView:didSetRefreshState:isHeader:);
        if ([self.delegate respondsToSelector:selector]) {
            if (selector) {
                IMP imp = [(NSObject *)self.delegate methodForSelector:selector];
                if (imp) {
                    void (*func)(id, SEL, UITableView*, TableRefreshState, BOOL) = (void *)imp;
                    func(self.delegate, selector, self, StateInRefresh, isHeader);
                }
            }
        }
    }
}

- (void)setRefreshState:(TableRefreshState)state isHeader:(BOOL)isHeader {
    id<TableViewRefreshDefaultDelegate> delegate = [self getRefreshDefault];
    UIEdgeInsets insets = [self originEdgeInsets];
    if (state == StateNormal) {
        self.contentInset = insets;
    } else if (state == StateInRefresh) {
        if (isHeader) {
            [delegate setRefreshView:[delegate refreshHeaderView] withState:StateInRefresh];
            CGFloat headerToggleHeight = [delegate refreshheaderViewStateToggleBorder];
            UIEdgeInsets insets = [self originEdgeInsets];
            insets.top += headerToggleHeight;
            self.contentInset = insets;
        } else {
            [delegate setRefreshView:[delegate refreshTailerView] withState:StateInRefresh];
            CGFloat tailerToggleHeight = [delegate refreshTailerViewStateToggleBorder];
            UIEdgeInsets insets = [self originEdgeInsets];
            insets.bottom += tailerToggleHeight;
            self.contentInset = insets;
        }
    }
    __weak UITableView *weakSelf = self;
    CGFloat tailerToggleHeight = [delegate refreshTailerViewStateToggleBorder];
    [UIView animateWithDuration:0.25 animations:^{
        if (isHeader) {
            weakSelf.contentOffset = CGPointMake(0, -1*weakSelf.contentInset.top);
        } else {
            weakSelf.contentOffset = CGPointMake(0, weakSelf.contentSize.height - weakSelf.hj_height + tailerToggleHeight);
        }
    }];
}
@end


@interface RefreshDefault()
@property (nonatomic, strong) UIView    *headerView;
@property (nonatomic, strong) UIView    *tailerView;
@property (nonatomic, assign) TableRefreshState headerState;
@property (nonatomic, assign) TableRefreshState tailerState;
@end
@implementation RefreshDefault
- (UIView *)refreshHeaderView {
    if (!self.headerView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WindowSize.width, HeightHeader)];
        UILabel *label = [UILabel labelWithFont:10.f textColor:RGBColor(102, 102, 102)];
        label.text = @"下拉刷新页面数据";
        label.frame = view.bounds;
        [view addSubview:label];
        label.tag = 1;
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.frame = CGRectMake((WindowSize.width-30)/2, (HeightHeader-30)/2, 30, 30);
        [view addSubview:indicatorView];
        indicatorView.hidden = YES;
        indicatorView.tag = 2;
        
        self.headerView = view;
    }
    return self.headerView;
}
- (CGFloat)refreshheaderViewStateToggleBorder {
    return HeightHeader;
}
- (UIView *)refreshTailerView {
    if (!self.tailerView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WindowSize.width, HeightTailer)];
        
        UILabel *label = [UILabel labelWithFont:10.f textColor:RGBColor(102, 102, 102)];
        label.text = @"上拉刷新页面数据";
        label.frame = view.bounds;
        [view addSubview:label];
        label.tag = 1;
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.frame = CGRectMake((WindowSize.width-30)/2, (HeightHeader-30)/2, 30, 30);
        [view addSubview:indicatorView];
        indicatorView.hidden = YES;
        indicatorView.tag = 2;
        
        self.tailerView = view;
    }
    return self.tailerView;
}
- (CGFloat)refreshTailerViewStateToggleBorder {
    return HeightTailer;
}
- (TableRefreshState)headerState {
    return _headerState;
}
- (TableRefreshState)tailerState {
    return _tailerState;
}

- (void)setRefreshView:(UIView *)refreshView withState:(TableRefreshState)state {
    UILabel *label = (UILabel  *)[refreshView viewWithTag:1];
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[refreshView viewWithTag:2];
    BOOL isHeader = [self.headerView isEqual:refreshView];
    if (state == StateNormal) {
        label.text = (isHeader?@"下拉刷新页面数据":@"上拉刷新页面数据");
        label.hidden = NO;
        indicator.hidden = YES;
        [indicator stopAnimating];
    } else if (state == statePreRefresh) {
        label.text = @"松开刷新页面数据";
        label.hidden = NO;
        indicator.hidden = YES;
        [indicator stopAnimating];
    } else if (state == StateInRefresh) {
        label.hidden = YES;
        indicator.hidden = NO;
        [indicator startAnimating];
    }
    if ([refreshView isEqual:self.headerView]) {
        self.headerState = state;
    } else if ([refreshView isEqual:self.tailerView]) {
        self.tailerState = state;
    }
}
@end
