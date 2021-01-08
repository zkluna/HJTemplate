//
//  THCaptureButton.m
//  HJTemplate
//
//  Created by zl on 2020/12/24.
//  Copyright © 2020 hhh. All rights reserved.
//

#import "THCaptureButton.h"

#define LINE_WIDTH 6.0f
#define DEFAULT_FRAME CGRectMake(0.0f, 0.0f, 68.0f, 68.0f)

@interface THPhotoCaptureButton : THCaptureButton
@end

@interface THVideoCaptureButton : THPhotoCaptureButton
@end

@interface THCaptureButton ()
@property (strong, nonatomic) CALayer *circleLayer;
@end

@implementation THCaptureButton


@end
