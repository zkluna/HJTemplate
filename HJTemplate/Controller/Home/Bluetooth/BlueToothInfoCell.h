//
//  BlueToothInfoCell.h
//  BluetoothDemo
//
//  Created by zhaoke on 2017/9/14.
//  Copyright © 2017年 hhh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlueToothInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *idStr;
@property (weak, nonatomic) IBOutlet UILabel *name;

+ (UINib *)nib;

@end
