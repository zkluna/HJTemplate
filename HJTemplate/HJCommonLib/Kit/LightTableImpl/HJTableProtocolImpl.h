//
//  HJTableDataDelegate.h
//  OCVMDemo1
//
//  Created by rubick on 2018/11/1.
//  Copyright © 2018 linggao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HJTableViewCellConfigureBlock)(NSIndexPath *indexPath, id item, UITableViewCell *cell);
typedef CGFloat(^HJCellHeightBlock)(NSIndexPath *indexPath, id item);
typedef void(^HJDidSelectCellBlock)(NSIndexPath *indexPath, id item);

@interface HJTableProtocolImpl : NSObject<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *dataSource;

- (id)initWithTableView:(UITableView *)tableView
                  items:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(HJTableViewCellConfigureBlock)aConfigureCellBlock
    cellHeightBlock:(HJCellHeightBlock)aHeightBlock
     didSelectBlock:(HJDidSelectCellBlock)didSelectBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
