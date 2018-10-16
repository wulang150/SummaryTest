//
//  LayoutTestController.m
//  SummaryTest
//
//  Created by  Tmac on 2017/12/4.
//  Copyright © 2017年 Tmac. All rights reserved.
//

/*
 layoutSubviews
 ①、直接调用setLayoutSubviews。
 ②、addSubview的时候触发layoutSubviews。
 ③、当view的frame发生改变的时候触发layoutSubviews。
 ④、第一次滑动UIScrollView的时候触发layoutSubviews。
 ⑤、旋转Screen会触发父UIView上的layoutSubviews事件。
 ⑥、改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件。
 
 
 drawRect在以下情况下会被调用：
 
 1、如果在UIView初始化时没有设置rect大小，将直接导致drawRect不被自动调用。drawRect 掉用是在Controller->loadView, Controller->viewDidLoad 两方法之后掉用的.所以不用担心在 控制器中,这些View的drawRect就开始画了.这样可以在控制器中设置一些值给View(如果这些View draw的时候需要用到某些变量 值).
 2、该方法在调用sizeToFit后被调用，所以可以先调用sizeToFit计算出size。然后系统自动调用drawRect:方法。
 3、通过设置contentMode属性值为UIViewContentModeRedraw。那么将在每次设置或更改frame的时候自动调用drawRect:。
 4、直接调用setNeedsDisplay，或者setNeedsDisplayInRect:触发drawRect:，但是有个前提条件是rect不能为0。
 以上1,2推荐；而3,4不提倡
 */

#import "LayoutTestController.h"
#import "LayoutView.h"

@interface LayoutTestController ()
<UITableViewDelegate,UITableViewDataSource>
{
    LayoutView *layView;
    CGFloat cellHeight;
    NSArray *titleArr;
}

@property(nonatomic) UITableView *tableView;
@end

@implementation LayoutTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavWithTitle:@"Layout" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
    cellHeight = 46;
    
    layView = [[LayoutView alloc] initWithFrame:CGRectMake(10, NavigationBar_HEIGHT+20, 120, 46)];
    //    layView = [[LayoutView alloc] init];
    layView.backgroundColor = [UIColor redColor];
    layView.content = @"yyy";
    layView.contentMode = UIViewContentModeRedraw;
    [self.view addSubview:layView];
    
//    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationBar_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
//        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    layView.frame = CGRectMake(layView.origin.x, layView.origin.y, 200, layView.size.height);
    layView.width = 200;
//    [layView layoutIfNeeded];
//    [layView changeSubW:111];
//    [layView setNeedsLayout];     //触发layout
//    [layView setNeedsDisplay];      //触发drawRect
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    for(UIView *sub in cell.contentView.subviews)
        [sub removeFromSuperview];
    if(indexPath.row==7)
    {
        layView = [[LayoutView alloc] initWithFrame:CGRectMake(10, 0, 120, 46)];
        //    layView = [[LayoutView alloc] init];
        layView.backgroundColor = [UIColor redColor];
        layView.content = @"yyy";
        [cell.contentView addSubview:layView];
    }
    else
    {
        cell.textLabel.text = @"tttt";
    }
    return cell;
}
@end
