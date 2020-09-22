//
//  TestTableViewClickConfig.m
//  YbAOPCuttingModule
//
//  Created by 杨少 on 2018/3/30.
//  Copyright © 2018年 杨波. All rights reserved.
//

#import "TestTableViewClickConfig.h"
#import "TestVC.h"

@implementation TestTableViewClickConfig

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TestVC *vc = [[TestVC alloc] init];
    vc.title = @"test";
    UITabBarController *tabBarVC =  (UITabBarController *)UIApplication.sharedApplication.delegate.window.rootViewController;
    
    UIViewController *rootVC = tabBarVC.selectedViewController;
    if([rootVC isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)rootVC pushViewController:vc animated:YES]   ;
    } else {
        [rootVC.navigationController pushViewController:vc animated:YES];
    }
}

@end
