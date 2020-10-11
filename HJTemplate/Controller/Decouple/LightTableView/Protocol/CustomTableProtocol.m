//
//  CustomTableProtocol.m
//  HJTemplate
//
//  Created by zhaoke on 2020/10/11.
//  Copyright © 2020 hhh. All rights reserved.
//

#import "CustomTableProtocol.h"
#import "MBProgressHUD+JJ.h"
#import "UIImage+Extend.h"
#import "CustomModel.h"

@implementation CustomTableProtocol

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    CustomModel *model = self.dataSource[indexPath.row];
    UIImage *image = [UIImage imageWithColor:model.color];
    cell.imageView.image = image;
    cell.textLabel.text = model.title;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CustomModel *model = self.dataSource[indexPath.row];
    [MBProgressHUD showMessage:model.title];
}
@end
