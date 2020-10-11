//
//  CustomVC.m
//  HJTemplate
//
//  Created by zhaoke on 2020/10/11.
//  Copyright © 2020 hhh. All rights reserved.
//

#import "CustomVC.h"
#import <MJRefresh.h>
#import "CustomModel.h"
#import "CustomViewModel.h"
#import "CustomTableProtocol.h"
#import "HJCommonLib.h"

@interface CustomVC ()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) CustomViewModel *customVM;
@property (strong, nonatomic) CustomTableProtocol *tableProtocol;


@end

@implementation CustomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"CutomVC";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTableView];
}
- (void)setupTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _customVM = [[CustomViewModel alloc] init];
    _tableProtocol = [[CustomTableProtocol alloc] init];
    _tableView.delegate = _tableProtocol;
    _tableView.dataSource = _tableProtocol;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.view addSubview:_tableView];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self headerRefreshAction];
    }];
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self footerRefreshAction];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)headerRefreshAction {
    WeakS(weakSelf);
    [self.customVM headerRefreshRequestWithCallback:^(NSArray * _Nonnull array) {
        weakSelf.tableProtocol.dataSource = [array mutableCopy];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}
- (void)footerRefreshAction {
    WeakS(weakSelf);
    [self.customVM footerRefreshRequestWithCallback:^(NSArray * _Nonnull array) {
        [weakSelf.tableProtocol.dataSource addObjectsFromArray:array];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}


@end
