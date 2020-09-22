//
//  CacheDataManager.h
//  LaoTieWallet
//
//  Created by rubick on 2018/11/7.
//  Copyright © 2018 LG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CacheDataManager : NSObject

/** 获取当前用户的缓存文件夹 */
+ (NSString *)getUserDefaultFolderWithUserId:(nullable NSString *)userId;

+ (NSString *)offLineImageFileFolder;

/** 广告图片路径 */
+ (NSString *)cacheADImagePath;


@end

NS_ASSUME_NONNULL_END
