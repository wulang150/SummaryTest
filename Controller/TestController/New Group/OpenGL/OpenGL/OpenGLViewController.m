//
//  OpenGLViewController.m
//  SummaryTest
//
//  Created by  Tmac on 2018/10/16.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "OpenGLViewController.h"

@interface OpenGLViewController ()
<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *titleArr;
}
@property(nonatomic) NSArray *vcArr;
@end

@implementation OpenGLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavWithTitle:@"OpenGL" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
    titleArr = @[@"画三角形",@"渲染图片"];
    _vcArr = @[@"GLTriangleController",@"DrawImageController"];
    
    UITableView *_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH,SCREEN_HEIGHT-NavigationBar_HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *vcName = _vcArr[indexPath.row];
    UIViewController *vc = [NSClassFromString(vcName) new];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
