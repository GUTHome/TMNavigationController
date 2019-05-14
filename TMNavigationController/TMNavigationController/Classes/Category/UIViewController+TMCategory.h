//
//  UIViewController+TMCategory.h
//  TMNavigationControllerDemo
//
//  Created by cocomanber on 2019/2/16.
//  Copyright © 2019 cocomanber. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const TMViewControllerPropertyChangedNotification;

@class TMNavigationController, TMWrapViewController;

@interface UIViewController (TMCategory)

/** 是否禁止当前控制器的滑动返回(包括全屏返回和边缘返回) */
@property (nonatomic, assign) BOOL tm_interactivePopDisabled;

/** 是否禁止当前控制器的全屏滑动返回 */
@property (nonatomic, assign) BOOL tm_fullScreenPopDisabled;

/** 全屏滑动时，滑动区域距离屏幕左边的最大位置，默认是0，表示全屏都可滑动 */
@property (nonatomic, assign) CGFloat tm_popMaxAllowedDistanceToLeftEdge;

/** 设置导航栏的透明度 */
@property (nonatomic, assign) CGFloat tm_navBarAlpha;

/** 自定义返回item */
- (UIBarButtonItem *)tm_customBackItemWithTarget:(id)target action:(SEL)action;

@end

@interface UINavigationController (TMCategory)

- (void)tm_setNavBarAlpha:(CGFloat)alpha;

@end
