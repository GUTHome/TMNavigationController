//
//  UIViewController+TMNavigationController.h
//  TMNavigationControllerDemo
//
//  Created by cocomanber on 2019/2/16.
//  Copyright © 2019 cocomanber. All rights reserved.
//  此类用户获取方便开发，用户不必关心
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TMWrapViewController, TMNavigationController;

@interface UIViewController (TMNavigationController)

/**
 控制器对应的包装后的控制器
 */
@property (nonatomic, weak) TMWrapViewController *tm_wrapViewController;

/**
 控制器的根控制器
 */
@property (nonatomic, weak, readonly) TMNavigationController *tm_navigationController;

@end

NS_ASSUME_NONNULL_END
