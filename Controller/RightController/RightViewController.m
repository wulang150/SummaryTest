//
//  RightViewController.m
//  SummaryTest
//
//  Created by  Tmac on 2017/7/17.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "RightViewController.h"
#import "MJRefresh.h"
#import "TestViewController.h"
#import "LayoutTestController.h"
#import "runLoopController.h"
#import "OtherViewController.h"
#import "SimpleViewController.h"
#import "AlgorithmViewController.h"
#import "PerformanceViewController.h"
#import "CollectionViewController.h"
#import "CollectionViewController1.h"
#import "TestViewController1.h"
#import "AnimateViewController.h"

@interface RightViewController ()
<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *titleArr;
    
}
@property(nonatomic) NSArray *vcArr;
@property(nonatomic) UITableView *tableView;
@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavWithTitle:@"右边" leftImage:nil leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
    titleArr = @[@"消息传递测试",@"layout",@"runLoop",@"其他",@"简单测试",@"算法测试",@"性能测试",@"collection",@"tableView",@"动画测试",@"音频测试",@"OpenGL"];
    
    [self.view addSubview:self.tableView];
    
    _vcArr = @[@"TestViewController",@"LayoutTestController",@"runLoopController",@"OtherViewController",@"SimpleViewController",@"AlgorithmViewController",@"PerformanceViewController",@"CollectionViewController1",@"TestViewController1",@"AnimateViewController",@"AudioViewController",@"OpenGLViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateOpt
{
    NSLog(@"updateOpt");
    
    [_tableView.mj_header endRefreshing];
}

- (void)endFoot
{
    NSLog(@"endFoot");
    
    [_tableView.mj_footer endRefreshing];
}

- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationBar_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            NSLog(@"MJRefreshNormalHeader");
            
            [self performSelector:@selector(updateOpt) withObject:nil afterDelay:4];
        }];
        
//        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            
//            NSLog(@"MJRefreshAutoNormalFooter");
//            
//            [self performSelector:@selector(endFoot) withObject:nil afterDelay:4];
//        }];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            NSLog(@"MJRefreshBackNormalFooter");
            
            [self performSelector:@selector(endFoot) withObject:nil afterDelay:4];
        }];
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [titleArr objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *vcName = _vcArr[indexPath.row];
    UIViewController *vc = [NSClassFromString(vcName) new];
    [self.navigationController pushViewController:vc animated:YES];
    
//    switch (indexPath.row) {
//        case 0:
//        {
//            TestViewController *rc = [TestViewController new];
//            [self.navigationController pushViewController:rc animated:YES];
//            break;
//        }
//        case 1:
//        {
//            LayoutTestController *rc = [LayoutTestController new];
//            [self.navigationController pushViewController:rc animated:YES];
//            break;
//        }
//        case 2:
//        {
//            runLoopController *rc = [runLoopController new];
//            [self.navigationController pushViewController:rc animated:YES];
//            break;
//        }
//        case 3:
//        {
//            OtherViewController *rc = [OtherViewController new];
//            [self.navigationController pushViewController:rc animated:YES];
//            break;
//        }
//        case 4:
//        {
//            SimpleViewController *rc = [SimpleViewController new];
//            [self.navigationController pushViewController:rc animated:YES];
//            break;
//        }
//        case 5:
//        {
//            AlgorithmViewController *rc = [AlgorithmViewController new];
//            [self.navigationController pushViewController:rc animated:YES];
//            break;
//        }
//        case 6:
//        {
//            PerformanceViewController *rc = [PerformanceViewController new];
//            [self.navigationController pushViewController:rc animated:YES];
//            break;
//        }
//        case 7:
//        {
//            CollectionViewController1 *rc = [CollectionViewController1 new];
//            [self.navigationController pushViewController:rc animated:YES];
//            break;
//        }
//        case 8:
//        {
//            TestViewController1 *rc = [TestViewController1 new];
//            [self.navigationController pushViewController:rc animated:YES];
//            break;
//        }
//        case 9:
//        {
//
//        }
//        default:
//            break;
//    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__FUNCTION__);
}
@end
