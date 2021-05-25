//
//  HomeVC.m
//  HKProject
//
//  Created by rubick on 2016/11/25.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import "HomeVC.h"
#import "OtherVC.h"
#import "HJCommonLib.h"
#import "CustomVC.h"
#import "HJTableCell.h"
#import "BleDeviceListVC.h"
#import "AppleSignInVC.h"

@interface HomeVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.dataSource = @[@"Sign In with Apple",@"xxx",@"Test VC", @"蓝牙"];
    [self customSet];
    [self setUpTableView];
}
- (void)setUpTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[HJTableCell class] forCellReuseIdentifier:NSStringFromClass([HJTableCell class])];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}
- (void)customSet {
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"other" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    self.navigationItem.rightBarButtonItem = right;
}
- (void)rightAction {
    OtherVC *otherVC = [[OtherVC alloc] init];
    otherVC.title = @"other";
    otherVC.index = 0;
    [self.navigationController pushViewController:otherVC animated:YES];
}
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HJTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJTableCell class])];
    cell.leftImageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%ld", indexPath.row % 10]];
    cell.nameLab.text = self.dataSource[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0) {
        AppleSignInVC *vc = [[AppleSignInVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if(indexPath.row == 1) {
      
    } else if(indexPath.row == 2) {
        CustomVC *vc = [[CustomVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if(indexPath.row == 3) {
        BleDeviceListVC *vc = [[BleDeviceListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
