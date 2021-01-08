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

#import <dlfcn.h>
#import <fishhook/fishhook.h>

@interface OtherVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSMutableArray *dataSource;

@end

@implementation OtherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self subViewSetup];
//    [self testRebindLog];
}
//- (void)testRebindLog {
//    // 这里必须要先加载一次NSLog，如果不写NSLog，符号表里面根本就不会出现NSLog的地址
//    NSString *temp = @"hjkl";
//    NSLog(@"123");
//    NSLog(@"%@", temp);
//    // 定义rebinding结构体
//    struct rebinding nslogBind;
//    nslogBind.name = "NSLog";
//    nslogBind.replacement = myLog;
//    nslogBind.replaced = (void *)&old_nslog;
//
//    struct rebinding rebs[] = {nslogBind};
//    rebind_symbols(rebs, 1);
//    
//}
//static void (*old_nslog)(NSString *format, ...);
//void myLog(NSString *format, ...) {
////    va_list va = {0};
////    mode_t mode = 0;
////    va_start(va, format);
////    mode = va_arg(va, int);
//    printf("done my nslog ... \n");
//    format = [format stringByAppendingString:@"\n 勾上了！！"];
////    old_nslog(format, mode);
//    old_nslog(format);
////    va_end(va);
//}

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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"your click the cell.");
}


@end
