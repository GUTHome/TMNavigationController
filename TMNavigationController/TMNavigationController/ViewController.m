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
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.    
    
    NSLog(@"--->%ld", self.navigationController.viewControllers.count);
    NSLog(@"--->%ld", self.tm_navigationController.tm_viewControllers.count);
    NSLog(@"--->%@", NSStringFromClass([self.navigationController class]));
    
    if (self.hiddenNavigationBar) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
    
    if (self.showHead) {
        [self setTm_navBarAlpha:0];
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
        headView.backgroundColor = [UIColor orangeColor];
        self.tableView.tableHeaderView = headView;
        self.tableView.contentInset = UIEdgeInsetsMake(-88, 0, 0, 0);
    }
    
}

#pragma mark - tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"---> %ld", (long)indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ViewController *vc = [ViewController new];
    vc.showHead = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.showHead) {
        CGFloat y = scrollView.contentOffset.y;
        NSLog(@"-- %f", y);
        y = (y)/(300-88.f);
        [self setTm_navBarAlpha:y];
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tableView;
}

@end
