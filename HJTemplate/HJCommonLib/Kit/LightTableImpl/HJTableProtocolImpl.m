
//
//  HJTableDataDelegate.m
//  OCVMDemo1
//
//  Created by rubick on 2018/11/1.
//  Copyright © 2018 linggao. All rights reserved.
//

#import "HJTableProtocolImpl.h"
#import "UITableViewCell+Extension.h"

@interface HJTableProtocolImpl()

@property (weak, nonatomic) UITableView *tableView;

@property (copy, nonatomic) NSString *cellIdentifier;
@property (copy, nonatomic) HJTableViewCellConfigureBlock configureCellBlock;
@property (copy, nonatomic) HJCellHeightBlock heightConfigureBlock;
@property (copy, nonatomic) HJDidSelectCellBlock didSelectCellBlock;

@end

@implementation HJTableProtocolImpl

- (id)initWithTableView:(UITableView *)tableView
                  items:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(HJTableViewCellConfigureBlock)aConfigureCellBlock
    cellHeightBlock:(HJCellHeightBlock)aHeightBlock
     didSelectBlock:(HJDidSelectCellBlock)didSelectBlock {
    self = [super init];
    if(self){
        self.dataSource = anItems;
        self.cellIdentifier = aCellIdentifier;
        self.configureCellBlock = aConfigureCellBlock;
        self.heightConfigureBlock = aHeightBlock;
        self.didSelectCellBlock = didSelectBlock;
        self.tableView = tableView;
        tableView.delegate = self;
        tableView.dataSource = self;
    }
    return self;
}
- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataSource[indexPath.row];
}
#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self itemAtIndexPath:indexPath];
    return self.heightConfigureBlock(indexPath, item);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self itemAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    self.configureCellBlock(indexPath, item, cell);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id item = [self itemAtIndexPath:indexPath];
    self.didSelectCellBlock(indexPath, item);
}

@end
