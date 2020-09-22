//
//  UIImage+Extend.h
//  kActivity
//
//  Created by rubick on 16/10/24.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>

typedef NS_ENUM(NSUInteger, WaterDirect) {
    TopLeft,
    TopRight,
    BottomLeft,
    BottomRight,
    Center,
};

@interface UIImage (Extend)

+ (UIImage *)imageWithColor:(UIColor *)color;
#pragma mark --z 滤镜效果 --
/**  从给定的View中截图 */
+ (UIImage *)cutFromView:(UIView *)view;

/**  直接截屏  */
+ (UIImage *)cutScreen;

/**  从给定的UIImage和frame截图  */
- (UIImage *)cutWithFrame:(CGRect)frame;

#pragma mark  change frame
/**  裁剪圆角  */
- (UIImage *)circleImageWithImage:(UIImage *)img;

/**  将图片裁剪为正方形  */
- (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize;

/**  改变图片大小  */
- (UIImage *)imageWithSize:(CGSize)newSize;

/**  修剪图片  */
- (UIImage *)croppedImage:(CGRect)rect;

#pragma mark   water -
/**  生成水印  文字/图片 */
- (UIImage *)waterWithText:(NSString *)text direction:(WaterDirect)direction fontColor:(UIColor *)color fontPoint:(CGFloat)point marginXY:(CGPoint)marginXY;
- (UIImage *)waterWithWaterImage:(UIImage *)waterImage direction:(WaterDirect)direction waterSize:(CGSize)size marginXY:(CGPoint)marginXY;
#pragma mark --z video ---
/**  获取视频的第几帧  */
+ (UIImage *)thumbnailImageForVideo:(NSURL *)videoUrl atTime:(NSTimeInterval)time;

@end
