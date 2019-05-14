//
//  TMWrapViewController.h
//  TMNavigationControllerDemo
//
//  Created by cocomanber on 2019/2/16.
//  Copyright © 2019 cocomanber. All rights reserved.
//
/* 说明：此类是用来将传入的UIViewController 包装一个导航控制器（TMWrapNavigationController),然后再包装一个
 UIViewController(TMWrapViewController),并将包装后的控制器返回
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMWrapViewController : UIViewController

/**
 这里用来记录包装前的控制器
 */
@property (nonatomic, weak, readonly) __kindof UIViewController *contentViewController;

/**
 包装控制器的方法
 
 @param viewController 将要包装的控制器
 @return 包装后的控制器
 */
+ (instancetype)wrapViewControllerWithViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
