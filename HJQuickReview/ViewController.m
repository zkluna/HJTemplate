//
//  ViewController.m
//  HJQuickReview
//
//  Created by zl on 2020/9/22.
//  Copyright © 2020 hhh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray *dataArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"AppClips";
    self.dataArr = @[@"葡萄", @"橘子", @"苹果", @"草莓", @"樱桃", @"核桃", @"山竹", @"西瓜", @"香蕉"];
    [self setupTableView];
}
- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
}
#pragma mark  -  TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%ld", indexPath.row % 9 + 1]];
    cell.textLabel.text = self.dataArr[arc4random_uniform(9)];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
