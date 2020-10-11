//
//  HJTableCell.m
//  HJTemplate
//
//  Created by zl on 2019/10/28.
//  Copyright © 2019 LG. All rights reserved.
//

#import "HJTableCell.h"

@implementation HJTableCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self setupChildView];
    }
    return self;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
         [self setupChildView];
    }
    return self;
}
- (void)setupChildView {
    if (@available(iOS 13.0, *)) {
        self.contentView.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    _leftImageV = [[UIImageView alloc] initWithFrame:CGRectMake(16, 15, 60, 60)];
    _leftImageV.layer.cornerRadius = 5;
    _leftImageV.layer.masksToBounds = YES;
    [self.contentView addSubview:self.leftImageV];
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(90, 30, 200, 30)];
    _nameLab.textColor = [UIColor darkTextColor];
    _nameLab.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.nameLab];

}

@end
