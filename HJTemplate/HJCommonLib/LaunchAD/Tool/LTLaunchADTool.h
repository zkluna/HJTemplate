//
//  LTLaunchADTool.h
//  LaoTieWallet
//
//  Created by rubick on 2018/11/7.
//  Copyright © 2018 LG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/** 广告业Tool */
@interface LTLaunchADTool : NSObject

// 切换rootVC
+ (void)switchRootControllerToMainVCAnimation:(BOOL)isAnimation;

// 下载广告图片
+ (void)downloadADImage;

// 获取缓存图片
+ (UIImage *)getCacheADImage;

// schushichushi
+ (void)checkIfShowADController;

@end

NS_ASSUME_NONNULL_END
