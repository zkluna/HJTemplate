//
//  THAssetsLibrary.h
//  HJTemplate
//
//  Created by zl on 2020/12/24.
//  Copyright © 2020 hhh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface THAssetsLibrary : NSObject

- (void)writeImage:(UIImage *)image;
- (void)writeVideo:(NSURL *)videoURL;

@end

NS_ASSUME_NONNULL_END
