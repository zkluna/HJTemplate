//
//  HJCommonLib.h
//  HKProject
//
//  Created by Rubick on 2017/5/31.
//  Copyright © 2017年 hjkl. All rights reserved.
//

#ifndef HJCommonLib_h
#define HJCommonLib_h



#define HJLog(format, ...) do {\
    fprintf(stderr, "<%s : %d> %s\n",\
    [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
    __LINE__, __func__);\
    (NSLog)((format), ##__VA_ARGS__);\
    fprintf(stderr, "---*---*---*---*---\n");\
} while(0)

#pragma mark - weak & strong

#define WeakS(weakSelf) __weak __typeof(&*self)weakSelf = self;
#define StrongS(weakSelf) __strong __typeof(&*self)strongSelf = weakSelf;
#define WeakObj(o) __weak typeof(o) o##Weak = o;


#pragma mark - frame

// 非横屏
#define _kScreenWidth [UIScreen mainScreen].bounds.size.width
#define _kScreenHeight [UIScreen mainScreen].bounds.size.height
#define isIphone4 _kScreenHeight == 480
#define isIphone5 _kScreenHeight == 568
#define isIphone6 _kScreenHeight == 667
#define isIphone6plus _kScreenHeight == 736
#define isIphoneX _kScreenHeight == 812  // X & Xs
#define isIphoneXM _kScreenHeight == 896  // Xr & XMax
#define isIphoneXS (isIphoneX || isIphoneXM)
#define iphoneXStatusBarHeight 24    //  iphoneX 顶部高度（电池条状态栏）
#define iphoneXNaviHeight 88         //  iphoneX 头部高度（电池条状态栏+navi+空白）
#define iphoneXHomeBarHeight 34      //  iphoneX 底部高度
#define SafeAreaTopHeight (isIphoneXS ? 88 : 64)
#define SafeAreaBottomHeight (isIphoneXS ? 34 : 0)
#define kTabBarHeight 49

#pragma mark - for short

#define _kApplication [UIApplication sharedApplication]
#define _kMyWindow [UIApplication sharedApplication].delegate.window
#define _kAppDelegate [UIApplication sharedApplication].delegate
#define _kUserDefaults [NSUserDefaults standardUserDefaults]
#define _kNotificationCenter [NSNotificationCenter defaultCenter]

#define _kPathTemp NSTemporaryDirectory()
#define _kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define _kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

#endif /* HJCommonLib_h */
