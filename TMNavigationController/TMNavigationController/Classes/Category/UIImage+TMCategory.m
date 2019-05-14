//
//  UIImage+TMCategory.m
//  TMNavigationControllerDemo
//
//  Created by cocomanber on 2019/2/16.
//  Copyright © 2019 cocomanber. All rights reserved.
//

#import "UIImage+TMCategory.h"

@implementation UIImage (TMCategory)

// 根据颜色创建UIImage
+ (UIImage *)tm_imageWithColor:(UIColor *)color{
    return [self.class tm_imageWithColor:color size:CGSizeMake(1.0, 1.0)];
}

+ (UIImage *)tm_imageWithColor:(UIColor *)color size:(CGSize)size{
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
