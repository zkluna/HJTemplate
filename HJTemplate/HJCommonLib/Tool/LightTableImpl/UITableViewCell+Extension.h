//
//  UITableViewCell+Extension.h
//  OCVMDemo1
//
//  Created by rubick on 2018/11/1.
//  Copyright © 2018 linggao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (Extension)

/** 通过类名获取nib, 默认identifier为类名 */
+ (UINib *)nib;

/** 注册cell，默认identifier为类名 */
+ (void)registerCellWithTableView:(UITableView *)tableView;
+ (void)registerNibCellWithTableView:(UITableView *)tableView;

/** 设置cell数据 */
- (void)setupCellDataWithObj:(id)obj indexPath:(NSIndexPath *)indexPath;

/** 设置cell高度 */
+ (CGFloat)setupCellHeightWithObj:(id)obj indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
