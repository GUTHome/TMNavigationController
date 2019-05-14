//
//  TMNavigationController.m
//  TMNavigationControllerDemo
//
//  Created by cocomanber on 2019/2/16.
//  Copyright © 2019 cocomanber. All rights reserved.
//

#import "TMNavigationController.h"
#import "TMWrapViewController.h"
#import "TMWrapNavigationController.h"
#import "TMFullScreenPanGestureRecognizerDelegate.h"

// 使用static inline创建静态内联函数，方便调用
static inline UIViewController *TMUnWrapViewController(UIViewController *viewController) {
    if ([viewController isKindOfClass:[TMWrapViewController class]]) {
        return ((TMWrapViewController *)viewController).contentViewController;
    }
    return viewController;
}

@interface TMNavigationController ()
<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) id<UINavigationControllerDelegate> tm_delegate;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, weak) id popGestureTarget;

@property (nonatomic, strong) TMFullScreenPanGestureRecognizerDelegate *panGestureDelegate;

@end

@implementation TMNavigationController

// 重写构造方法，将控制器先进行包装，再入栈
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        TMWrapViewController *wrapViewController = [TMWrapViewController wrapViewControllerWithViewController:rootViewController];
        self.viewControllers = @[wrapViewController];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        TMWrapViewController *wrapViewController = [TMWrapViewController wrapViewControllerWithViewController:self.viewControllers.firstObject];
        self.viewControllers = @[wrapViewController];
    }
    return self;
}

#pragma mark - Private Method

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        
        _panGesture = [[UIPanGestureRecognizer alloc] init];
        
        _panGesture.maximumNumberOfTouches = 1;
    }
    return _panGesture;
}

- (TMFullScreenPanGestureRecognizerDelegate *)panGestureDelegate {
    if (!_panGestureDelegate) {
        _panGestureDelegate = [TMFullScreenPanGestureRecognizerDelegate new];
        _panGestureDelegate.navigationController = self;
        _panGestureDelegate.popGestureTarget = self.popGestureTarget;
    }
    return _panGestureDelegate;
}

#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setDelegate:self];
    [super setNavigationBarHidden:YES animated:NO];
    
    // 记录系统返回手势的target
    self.popGestureTarget = self.interactivePopGestureRecognizer.delegate;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerPropertyChanged:) name:TMViewControllerPropertyChangedNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TMViewControllerPropertyChangedNotification object:nil];
}

- (UIViewController *)tm_visibleViewController {
    return TMUnWrapViewController([super visibleViewController]);
}

- (UIViewController *)tm_topViewController {
    return TMUnWrapViewController([super topViewController]);
}

- (NSArray<UIViewController *> *)tm_viewControllers {
    NSMutableArray *viewControllers = [NSMutableArray new];
    for (UIViewController *vc in [super viewControllers]) {
        [viewControllers addObject:TMUnWrapViewController(vc)];
    }
    return viewControllers;
}

- (void)removeViewControllerWithClass:(Class)className {
    [self.tm_viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:className]) {
            NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
            [viewControllers removeObjectAtIndex:idx];
            self.viewControllers = viewControllers;
        }
    }];
}

#pragma mark - Notification
- (void)viewControllerPropertyChanged:(NSNotification *)notify {
    
    UIViewController *vc = (UIViewController *)notify.object[@"viewController"];
    [self handlePopGestureRecognizer:vc];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    return [super popViewControllerAnimated:animated];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([self.tm_delegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
        [self.tm_delegate navigationController:navigationController willShowViewController:viewController animated:animated];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 处理手势
    [self handlePopGestureRecognizer:viewController];
    
    [TMNavigationController attemptRotationToDeviceOrientation];
    
    if ([self.tm_delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
        [self.tm_delegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
}

- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController {
    if ([self.tm_delegate respondsToSelector:@selector(navigationControllerSupportedInterfaceOrientations:)]) {
        return [self.tm_delegate navigationControllerSupportedInterfaceOrientations:navigationController];
    }
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController {
    if ([self.tm_delegate respondsToSelector:@selector(navigationControllerPreferredInterfaceOrientationForPresentation:)]) {
        return [self.tm_delegate navigationControllerPreferredInterfaceOrientationForPresentation:navigationController];
    }
    return UIInterfaceOrientationPortrait;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    if ([self.tm_delegate respondsToSelector:@selector(navigationController:interactionControllerForAnimationController:)]) {
        [self.tm_delegate navigationController:navigationController interactionControllerForAnimationController:animationController];
    }
    
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    [self handlePopGestureRecognizer:toVC];
    
    if ([self.tm_delegate respondsToSelector:@selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)]) {
        return [self.tm_delegate navigationController:navigationController animationControllerForOperation:operation fromViewController:fromVC toViewController:toVC];
    }
    
    return nil;
}

// 处理手势操作
- (void)handlePopGestureRecognizer:(UIViewController *)viewController {
    BOOL isRootVC = (viewController == self.viewControllers.firstObject);
    viewController = TMUnWrapViewController(viewController);
    
    if (isRootVC) return;
    
    // 移除全屏滑动手势，重新处理手势
    if ([self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.panGesture]) {
        [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.panGesture];
    }
    
    if (viewController.tm_interactivePopDisabled) {  // 禁止滑动返回
        self.interactivePopGestureRecognizer.delegate = nil;
        self.interactivePopGestureRecognizer.enabled  = NO;
    }else if (viewController.tm_fullScreenPopDisabled) {  // 禁止全屏滑动返回，使用系统滑动返回
        self.interactivePopGestureRecognizer.delaysTouchesBegan = YES;
        self.interactivePopGestureRecognizer.delegate = self;
        self.interactivePopGestureRecognizer.enabled  = !isRootVC;
    }else {   // 全屏滑动返回
        if (!isRootVC) {
            [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.panGesture];
        }
        
        // 设置代理
        self.panGesture.delegate = self.panGestureDelegate;
        
        self.interactivePopGestureRecognizer.delegate = nil;
        self.interactivePopGestureRecognizer.enabled  = NO;
    }
}

@end
