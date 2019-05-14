//
//  TMWrapNavigationController.m
//  TMNavigationControllerDemo
//
//  Created by cocomanber on 2019/2/16.
//  Copyright © 2019 cocomanber. All rights reserved.
//

#import "TMWrapNavigationController.h"
#import "UIViewController+TMNavigationController.h"
#import "UIViewController+TMCategory.h"
#import "TMWrapViewController.h"
#import "TMNavigationController.h"

@interface TMWrapNavigationController ()

@end

@implementation TMWrapNavigationController

+ (instancetype)wrapNavigationControllerWithViewController:(UIViewController *)viewController {
    return [[self alloc] initWithViewController:viewController];
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        self.viewControllers = @[viewController];
        
        if ([viewController isKindOfClass:[UITabBarController class]]) {
            [self setNavigationBarHidden:YES animated:NO];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 禁用包装的控制器的返回手势
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    TMNavigationController *nav = (TMNavigationController *)self.navigationController;
    
    // push一个包装后的控制器
    TMWrapViewController *wrapViewController = [TMWrapViewController wrapViewControllerWithViewController:viewController];
    viewController.tm_wrapViewController = wrapViewController;
    
    if ([viewController respondsToSelector:@selector(tm_customBackItemWithTarget:action:)]) {
        viewController.navigationItem.leftBarButtonItem = [viewController tm_customBackItemWithTarget:self action:@selector(backAction:)];
    }else {
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    }
    
    [nav pushViewController:wrapViewController animated:YES];
}

- (void)backAction:(id)sender {
    [self popViewControllerAnimated:YES];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    if (self.navigationController.viewControllers.count > 1) {
        return [self.navigationController popViewControllerAnimated:animated];
    }else {
        if (self.navigationController.navigationController.navigationController) {
            // 暂时的解决办法，用于处理push到UITabBarController的情况
            return [self.navigationController.navigationController.navigationController popViewControllerAnimated:animated];
        }else if (self.navigationController.navigationController) {
            return [self.navigationController.navigationController popViewControllerAnimated:animated];
        }else {
            return [self.navigationController popViewControllerAnimated:animated];
        }
    }
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // pop到指定控制器时应找到对应的GKWrapViewController
    TMWrapViewController *wrapViewController = viewController.tm_wrapViewController;
    return [self.navigationController popToViewController:wrapViewController animated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    return [self.navigationController popToRootViewControllerAnimated:animated];
}

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate {
    self.navigationController.delegate = delegate;
}

@end
