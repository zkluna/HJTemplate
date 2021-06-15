//
//  OtherVC.m
//  HKProject
//
//  Created by rubick on 2016/11/25.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import "OtherVC.h"
#import "HJCommonLib.h"
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
    self.title = [NSString stringWithFormat:@"%ld", self.index];
    [self subViewSetup];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor hj_randomColor]] forBarMetrics:UIBarMetricsDefault];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"hhh" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction)];
}
- (void)subViewSetup {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.separatorColor = [UIColor orangeColor];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"testCellIdentifier"];
}
#pragma mark -- TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testCellIdentifier"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OtherVC *vc = [[OtherVC alloc] init];
    vc.index = self.index + 1;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
