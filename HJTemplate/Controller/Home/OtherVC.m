//
//  OtherVC.m
//  HKProject
//
//  Created by rubick on 2016/11/25.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import "OtherVC.h"
#import "HJCommonLib.h"
#import "DZNEmptyDataSet.h"
#import "UIImage+BFKit.h"
#import "UIColor+Extend.h"
#import "UIImage+Extend.h"

@interface OtherVC ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSMutableArray *dataSource;

@end

@implementation OtherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataSource = [NSMutableArray array];
    [self subViewSetup];
    [self.tableView reloadData];
}
- (void)subViewSetup {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor orangeColor];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"testCellIdentifier"];
}
#pragma mark -- TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testCellIdentifier"];
    cell.textLabel.text = [NSString stringWithFormat:@"%---------- ld", indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_dataSource removeAllObjects];
    [self.tableView reloadData];
}


@end
