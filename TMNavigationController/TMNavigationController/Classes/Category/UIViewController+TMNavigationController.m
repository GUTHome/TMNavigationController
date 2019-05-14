//
//  UIViewController+TMNavigationController.m
//  TMNavigationControllerDemo
//
//  Created by cocomanber on 2019/2/16.
//  Copyright © 2019 cocomanber. All rights reserved.
//

#import "UIViewController+TMNavigationController.h"
#import "TMNavigationController.h"
#import <objc/runtime.h>

static NSString *const TMWrapViewControllerKey   = @"TMWrapViewControllerKey";
static NSString *const TMNavigationControllerKey = @"TMNavigationControllerKey";

@implementation UIViewController (TMNavigationController)

- (TMWrapViewController *)tm_wrapViewController {
    return objc_getAssociatedObject(self, &TMWrapViewControllerKey);
}

- (void)setTm_wrapViewController:(TMWrapViewController *)tm_wrapViewController {
    objc_setAssociatedObject(self, &TMWrapViewControllerKey, tm_wrapViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TMNavigationController *)tm_navigationController {
    UIViewController *vc = self;
    while (vc && ![vc isKindOfClass:[TMNavigationController class]]) {
        vc = vc.navigationController;
    }
    return (TMNavigationController *)vc;
}

@end
