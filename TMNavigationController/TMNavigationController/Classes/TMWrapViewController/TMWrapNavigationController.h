//
//  TMWrapNavigationController.h
//  TMNavigationControllerDemo
//
//  Created by cocomanber on 2019/2/16.
//  Copyright © 2019 cocomanber. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMWrapNavigationController : UINavigationController

/**
 用于包装导航控制器的控制器
 */
@property (nonatomic, weak) UIViewController *tm_wrapViewContorller;

+ (instancetype)wrapNavigationControllerWithViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
