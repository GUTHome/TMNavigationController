//
//  TMWrapViewController.m
//  TMNavigationControllerDemo
//
//  Created by cocomanber on 2019/2/16.
//  Copyright © 2019 cocomanber. All rights reserved.
//

#import "TMWrapViewController.h"
#import "TMWrapNavigationController.h"

static NSValue *tm_wrapTabBarRectValue;

@interface TMWrapViewController ()

@property (nonatomic, weak) __kindof UIViewController *contentViewController;

@property (nonatomic, weak) TMWrapNavigationController *wrapNavigationController;

@end

@implementation TMWrapViewController

+ (instancetype)wrapViewControllerWithViewController:(UIViewController *)viewController {
    return [[self alloc] initWithViewController:viewController];
}

// 包装过程
- (instancetype)initWithViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        // 1. 第一次包装
        self.wrapNavigationController = [TMWrapNavigationController wrapNavigationControllerWithViewController:viewController];
        
        // 2. 再次包装
        [self addChildViewController:self.wrapNavigationController];
        [self.wrapNavigationController didMoveToParentViewController:self];
        
        // 3. 记录控制器
        self.contentViewController = viewController;
        
        self.wrapNavigationController.tm_wrapViewContorller = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加视图
    [self.view addSubview:self.wrapNavigationController.view];
    self.wrapNavigationController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.wrapNavigationController.view.frame = self.view.bounds;
}

- (void)dealloc {
    [self.wrapNavigationController removeFromParentViewController];
    self.wrapNavigationController = nil;
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    if (parent == nil) {
        
        [self.wrapNavigationController removeFromParentViewController];
        self.wrapNavigationController = nil;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.tabBarController && !tm_wrapTabBarRectValue) {
        tm_wrapTabBarRectValue = [NSValue valueWithCGRect:self.tabBarController.tabBar.frame];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.translucent = YES;
    if (self.tabBarController && !self.tabBarController.tabBar.hidden && tm_wrapTabBarRectValue) {
        self.tabBarController.tabBar.frame = tm_wrapTabBarRectValue.CGRectValue;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.tabBarController && self.contentViewController.hidesBottomBarWhenPushed) {
        self.tabBarController.tabBar.frame = CGRectZero;
    }
}

- (BOOL)shouldAutorotate {
    return self.contentViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.contentViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.contentViewController.preferredInterfaceOrientationForPresentation;
}

- (BOOL)becomeFirstResponder {
    return [self.contentViewController becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return [self.contentViewController canBecomeFirstResponder];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.contentViewController.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    return self.contentViewController.prefersStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return self.contentViewController.preferredStatusBarUpdateAnimation;
}

- (BOOL)hidesBottomBarWhenPushed {
    return self.contentViewController.hidesBottomBarWhenPushed;
}

- (NSString *)title {
    return self.contentViewController.title;
}

- (UITabBarItem *)tabBarItem {
    return self.contentViewController.tabBarItem;
}

@end
