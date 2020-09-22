//
//  UITableView+Extend.h
//  kActivity
//
//  Created by rubick on 16/10/26.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TableRefreshState) {
    StateNormal,
    statePreRefresh,
    StateInRefresh,
};

@protocol TableViewRefreshDefaultDelegate <NSObject>

- (UIView *)refreshHeaderView;
- (TableRefreshState)headerState;
- (CGFloat)refreshheaderViewStateToggleBorder;
- (UIView *)refreshTailerView;
- (TableRefreshState)tailerState;
- (CGFloat)refreshTailerViewStateToggleBorder;
- (void)setRefreshView:(UIView *)refreshView withState:(TableRefreshState)state;

@end
/*
 被自动调用，target是tableview的delegate
 */
@protocol TableViewRefreshDelegate <NSObject>
@optional
- (void)tableView:(UITableView *)tableView willSetRefreshState:(TableRefreshState)state isHeader:(BOOL)isHeader;
- (void)tableView:(UITableView *)tableView didSetRefreshState:(TableRefreshState)state isHeader:(BOOL)isHeader;
@end

@interface UITableView (Extend)

- (void)setNeedHeaderRefresh;
- (void)setNeedTailerRefresh;

- (void)refreshTableViewDidScroll;
- (void)refreshTableViewDidEndDrag;


- (void)setRefreshState:(TableRefreshState)state isHeader:(BOOL)isHeader;
- (void)clearWhenDealloc;
- (void)removeRefresh;

@end

@interface RefreshDefault : NSObject<TableViewRefreshDefaultDelegate>

@end
