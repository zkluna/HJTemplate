//
//  UIImage+Image.h
//  Handy_APP_Frame
//
//  Created by Handy on 18/10/9.
//  Copyright © 2018年 Handy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)
// instancetype默认会识别当前是哪个类或者对象调用，就会转换成对应的类的对象
// UIImage *

// 加载最原始的图片，没有渲染
+ (instancetype)imageWithOriginalName:(NSString *)imageName;

+ (instancetype)imageWithStretchableName:(NSString *)imageName;

@end
