//
//  UIImage+TMCategory.h
//  TMNavigationControllerDemo
//
//  Created by cocomanber on 2019/2/16.
//  Copyright © 2019 cocomanber. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (TMCategory)

// 根据颜色创建UIImage
+ (UIImage *)tm_imageWithColor:(UIColor *)color;

+ (UIImage *)tm_imageWithColor:(UIColor *)color size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
