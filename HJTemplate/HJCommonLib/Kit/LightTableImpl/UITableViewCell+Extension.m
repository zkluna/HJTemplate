//
//  UITableViewCell+Extension.m
//  OCVMDemo1
//
//  Created by rubick on 2018/11/1.
//  Copyright © 2018 linggao. All rights reserved.
//

#import "UITableViewCell+Extension.h"

@implementation UITableViewCell (Extension)

+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}
+ (void)registerCellWithTableView:(UITableView *)tableView {
    [tableView registerClass:[self class] forCellReuseIdentifier:NSStringFromClass([self class])];
}
+ (void)registerNibCellWithTableView:(UITableView *)tableView {
    [tableView registerNib:[self nib] forCellReuseIdentifier:NSStringFromClass([self class])];
}
- (void)setupCellDataWithObj:(id)obj indexPath:(NSIndexPath *)indexPath {
    // Rewrite this method is SubClass
}
+ (CGFloat)setupCellHeightWithObj:(id)obj indexPath:(NSIndexPath *)indexPath {
    // Rewrite this method in SubClass if necessary
    return !obj ? 0.0f : 50.0f;
}

@end
