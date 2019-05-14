//
//  ViewController.m
//  TMNavigationController
//
//  Created by cocomanber on 2019/5/14.
//  Copyright © 2019 cocomanber. All rights reserved.
//

#import "ViewController.h"

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = randomColor;
    
    
    NSLog(@"--->%ld", self.navigationController.viewControllers.count);
    NSLog(@"--->%ld", self.tm_navigationController.tm_viewControllers.count);
    NSLog(@"--->%@", NSStringFromClass([self.navigationController class]));
    
    
    if (self.tm_navigationController.tm_viewControllers.count % 2 == 0) {
        self.navigationController.navigationBar.hidden = YES;
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:randomColor] forBarMetrics:(UIBarMetricsDefault)];
    }
    
    UIButton *button = [UIButton new];
    [button setTitle:@"PUSH" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
    button.frame = CGRectMake(0, 0, 200, 100);
    [self.view addSubview:button];
    button.center = self.view.center;
    [button addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
}

- (void)push{
    ViewController *vc = [ViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIImage*)createImageWithColor:(UIColor*)color{
    CGRect rect=CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
