//
//  BlueToothInfoCell.m
//  BluetoothDemo
//
//  Created by zhaoke on 2017/9/14.
//  Copyright © 2017年 hhh. All rights reserved.
//

#import "BlueToothInfoCell.h"

@implementation BlueToothInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (UINib *)nib {
    return [UINib nibWithNibName:@"BlueToothInfoCell" bundle:nil];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
