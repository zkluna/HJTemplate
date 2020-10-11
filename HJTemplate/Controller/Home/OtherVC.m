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
#import "MBProgressHUD+JJ.h"

@interface OtherVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSMutableArray *dataSource;

@end

@implementation OtherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self subViewSetup];
    [MBProgressHUD showActivityMessage:@"加载中"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
}
- (void)subViewSetup {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor orangeColor];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"testCellIdentifier"];
}
#pragma mark -- TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testCellIdentifier"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
