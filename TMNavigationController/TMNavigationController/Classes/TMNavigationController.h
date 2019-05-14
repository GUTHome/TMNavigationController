//
//  TMNavigationController.h
//  TMNavigationControllerDemo
//
//  Created by cocomanber on 2019/2/16.
//  Copyright © 2019 cocomanber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+TMCategory.h"
#import "UIViewController+TMNavigationController.h"

NS_ASSUME_NONNULL_BEGIN
/**
 根导航控制器
 */
@interface TMNavigationController : UINavigationController

/** 获取当前显示的控制器中的contentViewController */
@property (nonatomic, weak, readonly) UIViewController *tm_visibleViewController;

/** 获取当前栈顶的控制器中的contentViewController */
@property (nonatomic, weak, readonly) UIViewController *tm_topViewController;

/** 获取所有的contentViewController */
@property (nonatomic, weak, readonly) NSArray <__kindof UIViewController *> *tm_viewControllers;

/** 移除栈中的某个控制器（contentViewController） */
- (void)removeViewControllerWithClass:(Class)className;

@end

NS_ASSUME_NONNULL_END
