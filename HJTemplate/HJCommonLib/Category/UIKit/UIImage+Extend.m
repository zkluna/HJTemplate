//
//  UIImage+Extend.m
//  kActivity
//
//  Created by rubick on 16/10/24.
//  Copyright © 2016年 hjkl. All rights reserved.
//

#import "UIImage+Extend.h"

@implementation UIImage (Extend)
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 500, 500);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (UIImage *)circleImageWithImage:(UIImage *)img {
    UIGraphicsBeginImageContextWithOptions(img.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, img.size.width, img.size.height));
    CGContextClip(ctx);
    [img drawAtPoint:CGPointZero];
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImg;
}
+ (UIImage *)cutFromView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 在新建的图片上下文中渲染view的layer
    [view.layer renderInContext:context];
    [[UIColor clearColor] setFill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)cutScreen {
    return [self cutFromView:[UIApplication sharedApplication].keyWindow];
}
- (UIImage *)cutWithFrame:(CGRect)frame {
    CGImageRef cgimg = CGImageCreateWithImageInRect(self.CGImage, frame);
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    return newImage;
}
- (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize {
    CGAffineTransform scaleTransform;
    CGPoint origin;
    if(image.size.width > image.size.height){
        if(newSize == 0){
            newSize = image.size.height;
        }
        CGFloat scaleRatio = newSize / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        origin = CGPointMake(-(image.size.width-image.size.height)/2.0f, 0);
    } else {
        if(newSize == 0){
            newSize = image.size.width;
        }
        CGFloat scaleRatio = newSize/image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);;
        origin = CGPointMake(0, -(image.size.height-image.size.width));
    }
    CGSize size = CGSizeMake(newSize, newSize);
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(ctx, scaleTransform);
    [image drawAtPoint:origin];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (UIImage *)imageWithSize:(CGSize)newSize {
    // 比例相差在5%内的使用原图
    CGFloat ratio1 = self.size.width/self.size.height, ratio2 = newSize.width/newSize.height;
    if(fabs(ratio1-ratio2) <= 0.05f){
        return self;
    }
    CGFloat factor = newSize.width/newSize.height, newWidth = self.size.height*factor;
    CGRect rect = CGRectZero;
    if(newWidth < self.size.width){
        rect = CGRectMake((self.size.width-newWidth)/2, 0, newWidth, self.size.height);
    } else {
        newWidth = self.size.width;
        CGFloat height = self.size.width/factor;
        rect = CGRectMake(0, (self.size.height-height)/2, self.size.width, height);
    }
    UIImage *image = [self croppedImage:rect];
    return image;
}
- (UIImage *)croppedImage:(CGRect)rect {
    rect = CGRectMake(rect.origin.x*self.scale, rect.origin.y*self.scale, rect.size.width*self.scale, rect.size.height*self.scale);
    CGFloat top = rect.origin.y, left = rect.origin.x;
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
        {
            rect.origin.x = self.size.width - rect.size.width - left;
            rect.origin.y = self.size.height - rect.size.height - top;
        }
            break;
        case UIImageOrientationRightMirrored:
        case UIImageOrientationLeft:
        {
            rect.origin.x = self.size.height - rect.size.height - top;
            rect.origin.y = left;
            CGFloat tem = rect.size.width;
            rect.size.width = rect.size.height;
            rect.size.height = tem;
        }
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        {
            rect.origin.x = top;
            rect.origin.y = self.size.width - rect.size.width - left;
            CGFloat tem = rect.size.height;
            rect.size.width = rect.size.height;
            rect.size.height = tem;
        }
            break;
        default:
            break;
    }
    CGImageRef ref = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *croppedImage = [UIImage imageWithCGImage:ref scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(ref);
    return croppedImage;
}
- (UIImage *)waterWithText:(NSString *)text direction:(WaterDirect)direction fontColor:(UIColor *)color fontPoint:(CGFloat)point marginXY:(CGPoint)marginXY {
    CGSize size = self.size;
    CGRect rect = (CGRect){CGPointZero, size};
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    [self drawInRect:rect];
    NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:point], NSForegroundColorAttributeName:color};
    CGRect strRect = [self calWidth:text attr:attr direction:direction rect:rect marginXY:marginXY];
    [text drawInRect:strRect withAttributes:attr];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (CGRect)rectWithRect:(CGRect)rect size:(CGSize)size direction:(WaterDirect)direction marginXY:(CGPoint)marginXY {
    CGPoint point = CGPointZero;
    if(TopRight == direction){
        point = CGPointMake(rect.size.width-size.width, 0);
    }
    if(BottomLeft == direction){
        point = CGPointMake(0, rect.size.height-size.height);
    }
    if(BottomRight == direction){
        point = CGPointMake(rect.size.width-size.width, rect.size.height-size.height);
    }
    if(Center == direction){
        point = CGPointMake((rect.size.width-size.width)*.5f, (rect.size.height-size.height)*.5f);
    }
    point.x += marginXY.x;
    point.y += marginXY.y;
    CGRect calRect = (CGRect){point, size};
    return calRect;
}
- (CGRect)calWidth:(NSString *)str attr:(NSDictionary *)attr direction:(WaterDirect)direction rect:(CGRect)rect marginXY:(CGPoint)marginXY {
    CGSize size = [str sizeWithAttributes:attr];
    CGRect calRect = [self rectWithRect:rect size:size direction:direction marginXY:marginXY];
    return calRect;
}
- (UIImage *)waterWithWaterImage:(UIImage *)waterImage direction:(WaterDirect)direction waterSize:(CGSize)size marginXY:(CGPoint)marginXY {
    CGSize size1 = self.size;
    CGRect rect = (CGRect){CGPointZero, size1};
    UIGraphicsBeginImageContextWithOptions(size1, NO, 0.0f);
    [self drawInRect:rect];
    CGSize waterIamgeSize = CGSizeEqualToSize(size, CGSizeZero)?waterImage.size:size;
    CGRect calRect = [self rectWithRect:rect size:waterIamgeSize direction:direction marginXY:marginXY];
    [waterImage drawInRect:calRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+ (UIImage *)thumbnailImageForVideo:(NSURL *)videoUrl atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    if(!thumbnailImageRef){
        NSLog(@"thumbanailImageGenetationError %@",thumbnailImageGenerationError);
    }
    UIImage *image = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    return image;
}

@end
