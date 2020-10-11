//
//  CustomTableProtocol.h
//  HJTemplate
//
//  Created by zhaoke on 2020/10/11.
//  Copyright © 2020 hhh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTableProtocol : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

NS_ASSUME_NONNULL_END
