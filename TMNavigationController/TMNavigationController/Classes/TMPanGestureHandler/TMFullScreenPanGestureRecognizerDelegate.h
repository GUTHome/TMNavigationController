//
//  TMFullScreenPanGestureRecognizerDelegate.h
//  TMNavigationControllerDemo
//
//  Created by cocomanber on 2019/2/16.
//  Copyright © 2019 cocomanber. All rights reserved.
//  这个类主要用来处理全屏滑动手势的代理方法
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TMNavigationController;

@interface TMFullScreenPanGestureRecognizerDelegate : NSObject<UIGestureRecognizerDelegate>

/**
 根控制器
 */
@property (nonatomic, weak) TMNavigationController *navigationController;

/**
 系统返回手势的target
 */
@property (nonatomic, weak) id popGestureTarget;

@end

NS_ASSUME_NONNULL_END
