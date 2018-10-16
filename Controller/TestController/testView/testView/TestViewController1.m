//
//  TestViewController.m
//  SummaryTest
//
//  Created by  Tmac on 2018/7/30.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "TestViewController1.h"

@interface TestViewController1 ()
<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat startPos;
    CGFloat endPos;
    BOOL isUp;
    CGFloat topping;
    CGFloat rapping;    //下拉最后的缓冲区
}
@property(nonatomic) UIView *headView;
@property(nonatomic) UITableView *tableView;
@property(nonatomic) UIImageView *headImgV;
@end

@implementation TestViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createView
{
//    [self setNavWithTitle:@"测试" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    rapping = 100;
    topping = 160;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationBar_HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];

//    _tableView.estimatedRowHeight = 0;
//
//    _tableView.estimatedSectionHeaderHeight = 0;
//
//    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.bounces = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.contentOffset = CGPointMake(0, -topping);
    _tableView.contentInset = UIEdgeInsetsMake(topping+rapping, 0, 0, 0);
    isUp = YES;
    _tableView.decelerationRate = 0.1;
    
    _headView = [self gainHeightView:CGRectMake(0, 0, SCREEN_WIDTH, topping+300)];
    [self.view addSubview:_headView];
    
    [self.view addSubview:_tableView];
}

- (UIView *)gainHeightView:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor redColor];
    
    _headImgV = [[UIImageView alloc] initWithFrame:CGRectMake(16, 70, 60, 60)];
    _headImgV.layer.cornerRadius = _headImgV.height/2;
    _headImgV.clipsToBounds = YES;
    _headImgV.image = [UIImage imageNamed:@"myimage"];
    [view addSubview:_headImgV];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(_headImgV.right+10, _headImgV.top, 220, _headImgV.height)];
    titleLab.font = [UIFont boldSystemFontOfSize:16];
    titleLab.text = @"手机用户4456";
    titleLab.adjustsFontSizeToFitWidth = YES;
    titleLab.textColor = [UIColor whiteColor];
    [view addSubview:titleLab];
    return view;
}

- (void)doForScroll
{    
    CGFloat dis = endPos-startPos;
    if(dis>0)       //向上滑动
    {
        //如果已经是收缩状态就不处理
        if(!isUp)
            return;
        if(endPos>0)        //大于0就已经是收缩状态了
        {
            isUp = NO;
            return;
        }
        //收缩
        if(endPos>-topping/2)  //置顶收缩
        {
            isUp = NO;
            [UIView animateWithDuration:0.1 animations:^{

                _tableView.contentOffset = CGPointMake(0, 0);
            } completion:^(BOOL finished) {
            }];
        }
        else        //恢复下拉
        {
            isUp = YES;
            [UIView animateWithDuration:0.1 animations:^{

                _tableView.contentOffset = CGPointMake(0, -topping);

            } completion:^(BOOL finished) {

            }];
        }
    }
    else            //向下滑动
    {
        if(endPos>0)
            return;
        //处理缓冲部分的回弹，这里不想用系统的回弹，便改为自己的回弹，麻烦点
        if(endPos<-topping)
        {
            isUp = YES;
            [UIView animateWithDuration:0.1 animations:^{

                _tableView.contentOffset = CGPointMake(0, -topping-20);
                
            } completion:^(BOOL finished) {

            }];
            
            //弹簧效果
            [UIView animateWithDuration:0.2
                                   delay:0.1
                  usingSpringWithDamping:0.2
                   initialSpringVelocity:30
                                 options:UIViewAnimationOptionLayoutSubviews
                              animations:^{
                                  _tableView.contentOffset = CGPointMake(0, -topping);
                              } completion:^(BOOL finished) {
             }];
            return;
        }
        
        //如果已经是展开状态就不处理
        if(isUp)
            return;
        //向下拉取
        if(endPos<-topping/2)      //展开
        {
            isUp = YES;
            [UIView animateWithDuration:0.1 animations:^{

                _tableView.contentOffset = CGPointMake(0, -topping);
                
                
            } completion:^(BOOL finished) {

            }];
        }
        else        //恢复
        {
            isUp = NO;
            [UIView animateWithDuration:0.1 animations:^{

                _tableView.contentOffset = CGPointMake(0, 0);
                
            } completion:^(BOOL finished) {

            }];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
//    NSLog(@">>>>>%f",y);

    //控制顶部红色区域的高度
//    if(y<0&&y>=0-topping)
//    {
//        _headView.height = 0-y+NavigationBar_HEIGHT;
//    }
    if(y<=0)
    {
        CGFloat w = -y/topping * 30 + 30;
        CGFloat top = -y/topping * (70-24) + 24;
        _headImgV.frame = CGRectMake(16, top, w, w);
        _headImgV.layer.cornerRadius = _headImgV.height/2;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    startPos = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    endPos = scrollView.contentOffset.y;
    
    if(!decelerate)
        [self doForScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //停止滑动时候
    endPos = scrollView.contentOffset.y;
    [self doForScroll];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    cell.textLabel.text = [NSString stringWithFormat:@"num-%zi",indexPath.row];
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

@end
