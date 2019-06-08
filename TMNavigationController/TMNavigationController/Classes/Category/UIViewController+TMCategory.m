//
//  UIViewController+TMCategory.m
//  TMNavigationControllerDemo
//
//  Created by cocomanber on 2019/2/16.
//  Copyright © 2019 cocomanber. All rights reserved.
//

#import "UIViewController+TMCategory.h"
#import "UIImage+TMCategory.h"
#import <objc/runtime.h>
#import "TMNavigationController.h"
#import "TMWrapViewController.h"

NSString *const TMViewControllerPropertyChangedNotification = @"TMViewControllerPropertyChangedNotification";

static const void* TMInteractivePopKey = @"TMInteractivePopKey";
static const void* TMFullScreenPopKey  = @"TMFullScreenPopKey";
static const void* TMPopMaxDistanceKey = @"TMPopMaxDistanceKey";
static const void* TMNavBarAlphaKey    = @"TMNavBarAlphaKey";

@implementation UIViewController (TMCategory)

- (BOOL)tm_interactivePopDisabled {
    return [objc_getAssociatedObject(self, TMInteractivePopKey) boolValue];
}

- (void)setTm_interactivePopDisabled:(BOOL)disabled {
    objc_setAssociatedObject(self, TMInteractivePopKey, @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 当属性改变是，发送通知，告诉TMNavigationController，让其做出相应处理
    [[NSNotificationCenter defaultCenter] postNotificationName:TMViewControllerPropertyChangedNotification object:@{@"viewController": self}];
}

- (BOOL)tm_fullScreenPopDisabled {
    return [objc_getAssociatedObject(self, TMFullScreenPopKey) boolValue];
}

- (void)setTm_fullScreenPopDisabled:(BOOL)disabled {
    objc_setAssociatedObject(self, TMFullScreenPopKey, @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 当属性改变是，发送通知，告诉TMNavigationController，让其做出相应处理
    [[NSNotificationCenter defaultCenter] postNotificationName:TMViewControllerPropertyChangedNotification object:@{@"viewController": self}];
}

- (CGFloat)tm_popMaxAllowedDistanceToLeftEdge {
    return [objc_getAssociatedObject(self, TMPopMaxDistanceKey) floatValue];
}

- (void)setTm_popMaxAllowedDistanceToLeftEdge:(CGFloat)distance {
    objc_setAssociatedObject(self, TMPopMaxDistanceKey, @(distance), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 当属性改变是，发送通知，告诉TMNavigationController，让其做出相应处理
    [[NSNotificationCenter defaultCenter] postNotificationName:TMViewControllerPropertyChangedNotification object:@{@"viewController": self}];
}


- (CGFloat)tm_navBarAlpha {
    return [objc_getAssociatedObject(self, TMNavBarAlphaKey) floatValue];
}

- (void)setTm_navBarAlpha:(CGFloat)tm_navBarAlpha {
    objc_setAssociatedObject(self, TMNavBarAlphaKey, @(tm_navBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    //改变透明度
    [self.navigationController tm_setNavBarAlpha:tm_navBarAlpha];
}

// 自定义返回item
- (UIBarButtonItem *)tm_customBackItemWithTarget:(id)target action:(SEL)action {
    UIButton *btn = [UIButton new];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    //[btn setImage:[UIImage imageNamed:@"btn_back_white"] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
    [btn sizeToFit];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end

@implementation UINavigationController (TMCategory)

// 设置导航栏透明度
- (void)tm_setNavBarAlpha:(CGFloat)alpha {
    UIView *barBackgroundView = [self.navigationBar.subviews objectAtIndex:0]; // _UIBarBackground
    UIImageView *backgroundImageView = [barBackgroundView.subviews objectAtIndex:0]; // UIImageView
    
    if (self.navigationBar.isTranslucent) {
        if (backgroundImageView != nil && backgroundImageView.image != nil) {
            barBackgroundView.alpha = alpha;
        }else {
            UIView *backgroundEffectView = [barBackgroundView.subviews objectAtIndex:1]; // UIVisualEffectView
            if (backgroundEffectView != nil) {
                backgroundEffectView.alpha = alpha;
            }
        }
    }else {
        barBackgroundView.alpha = alpha;
    }
    // 底部分割线
    self.navigationBar.clipsToBounds = alpha == 0.0;
}

@end
