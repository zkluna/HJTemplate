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

#import "AppleSignInVC.h"
#import <pthread.h>

@interface HomeVC () <UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) BOOL isShow;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.dataSource = @[@"Sign In with Apple",@"主动显示|隐藏TabBar",@"test vc"];
    self.isShow = YES;
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
        if(self.isShow) {
            self.tabBarController.tabBar.hidden = YES;
            [self.tableView setFrame:CGRectMake(0, 0, _kScreenWidth, _kScreenHeight)];
        } else {
            self.tabBarController.tabBar.hidden = NO;
             [self.tableView setFrame:CGRectMake(0, 0, _kScreenWidth, _kScreenHeight-kTabBarHeight-SafeAreaBottomHeight)];
        }
        self.isShow = !_isShow;
    } else if(indexPath.row == 2) {
        CustomVC *vc = [[CustomVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
