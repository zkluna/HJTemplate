//
//  THCaptureButton.h
//  HJTemplate
//
//  Created by zl on 2020/12/24.
//  Copyright © 2020 hhh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, THCaptureButtonMode) {
    THCaptureButtonModePhoto = 0,
    THCaptureButtonModeVideo,
};

@interface THCaptureButton : UIButton

@property (assign, nonatomic) THCaptureButtonMode captureButtonMode;
+ (instancetype)captureButton;
+ (instancetype)captureButtonWithMode:(THCaptureButtonMode)captureButtonMode;

@end

NS_ASSUME_NONNULL_END
