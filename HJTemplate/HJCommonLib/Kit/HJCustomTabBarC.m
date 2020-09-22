//
//  HJCustomTabBarC.m
//  HJTemplate
//
//  Created by rubick on 2018/11/16.
//  Copyright © 2018 hjkl. All rights reserved.
//

#import "HJCustomTabBarC.h"
#import "HJNavigationController.h"
#import "UIColor+Extend.h"

@interface HJCustomTabBarC ()

@end

@implementation HJCustomTabBarC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        [self setUpChildrenVCs];
    }
    return self;
}
- (instancetype)init {
    self = [super init];
    if(self){
        [self setUpChildrenVCs];
    }
    return self;
}
- (void)setUpChildrenVCs {
    NSArray *className = @[@"HomeVC",@"SecondVC",@"ThirdVC",@"MIneVC"];
    NSArray *titles = @[@"首页",@"分类",@"其它",@"我的"];
    NSArray *unselectImgs = @[@"icon1_tabbar_normal",@"icon2_tabbar_normal",@"icon3_tabbar_normal",@"icon4_tabbar_normal"];
    NSArray *selecImgs = @[@"icon1_tabbar_sel",@"icon2_tabbar_sel",@"icon3_tabbar_sel",@"icon4_tabbar_sel"];
    NSMutableArray *vcArrs = [NSMutableArray arrayWithCapacity:0];
    UIFont *font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
    for (int i=0; i < 4; i++) {
        UIViewController *vc = [[NSClassFromString([className objectAtIndex:i]) alloc] init];
        vc.title = titles[i];
        HJNavigationController *navi = [[HJNavigationController alloc] initWithRootViewController:vc];
        navi.hidesBottomBarWhenPushed = YES;
        
        navi.tabBarItem = [[UITabBarItem alloc] initWithTitle:titles[i] image:[UIImage imageNamed:unselectImgs[i]] selectedImage:[UIImage imageNamed:selecImgs[i]]];
        [navi.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:RGBColor(114, 114, 114)} forState:UIControlStateNormal];
        [navi.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:RGBColor(46, 46, 46)} forState:UIControlStateSelected];
        [vcArrs addObject:navi];
    }
    self.viewControllers = [vcArrs copy];
}
#pragma mark - TabBarDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    // TODO CODE
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    // TODO CODE
}

@end
