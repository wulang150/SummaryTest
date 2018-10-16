//
//  ViewController.m
//  SummaryTest
//
//  Created by  Tmac on 2017/6/29.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "ViewController.h"
#import "CommonBgView.h"
#import "PanGesture.h"
#import "NSMutableData+Extension.h"
#import "PageSelectView.h"
#import "CommonFun.h"
#import "PublicFunction.h"
#import "BottomSelectView.h"
#import "RightViewController.h"

@implementation testModel


@end

@interface ViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource,PanGestureDelegate,BottomSelectViewDelegate>
{
    NSInteger curPage;
    
    PageSelectView *pageView;
}
@property(nonatomic,strong) UICollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createView
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavWithTitle:@"更大幅度" leftImage:nil leftTitle:nil leftAction:nil rightImage:nil rightTitle:@"右边有很多人" rightAction:@selector(rightAction)];
    
    [self.view addSubview:self.collectionView];
    
    pageView = [[PageSelectView alloc] initWithCenter:300 pageCount:3];
    pageView.spaceLeg = 20;
    pageView.imgSize = CGSizeMake(32, pageView.radius*4);
    pageView.selectImg = [UIImage imageNamed:@"home_focus"];
    [pageView updateView];
    [self.view addSubview:pageView];
    
    NSArray *imageArr = @[[UIImage imageNamed:@"home_focus"],[UIImage imageNamed:@"home_focus"],[UIImage imageNamed:@"home_focus"]];
    NSArray *titleArr = @[@"社交",@"社交",@"社交"];
    //下面的选择
    BottomSelectView *bottomView = [[BottomSelectView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-52, SCREEN_WIDTH, 52) images:imageArr selectedImages:nil titles:titleArr titleColor:[UIColor lightGrayColor] titleSelectedColor:[UIColor grayColor]];
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
    
}

- (UICollectionView *)collectionView
{
    if(!_collectionView)
    {
        //创建一个layout布局类
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向为垂直流布局
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        //    layout.minimumInteritemSpacing = 0;
        //设置每个item的大小为100*100
        
        //创建collectionView 通过一个布局策略layout来创建
        UICollectionView * collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationBar_HEIGHT) collectionViewLayout:layout];
        
        layout.itemSize = CGSizeMake(collect.bounds.size.width, collect.bounds.size.height);
        
        //代理设置
        collect.delegate=self;
        collect.dataSource=self;
        collect.pagingEnabled = YES;
        collect.showsVerticalScrollIndicator = NO;
        collect.showsHorizontalScrollIndicator = NO;
        collect.bounces = NO;       //取消边际出滑动出现空白的情况
//        collect.canCancelContentTouches = NO;       //默认是取消了touch事件，现在开启
        //注册item类型 这里使用系统的类型
        [collect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
        _collectionView = collect;
        
        //加入手势
        PanGesture *pan = [[PanGesture alloc] init];
        pan.GesDelegate = self;
        [_collectionView addGestureRecognizer:pan];
        
    }
    
    return _collectionView;
}


- (CommonBgView *)gainRightView
{
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(80, 0, SCREEN_WIDTH-80, SCREEN_HEIGHT)];
    subView.backgroundColor = [UIColor whiteColor];
    UILabel *tLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, subView.bounds.size.width, 40)];
    tLab.text = @"右边页面";
    tLab.textAlignment = NSTextAlignmentCenter;
    [subView addSubview:tLab];
    
    
    //加入蒙版
    CommonBgView *markView = [[CommonBgView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) subView:subView];
    
    return markView;
}


- (void)rightAction
{
    NSLog(@"rightAction");
    
    RightViewController *rc = [RightViewController new];
    [self.navigationController pushViewController:rc animated:YES];
    
//    CommonBgView *rightView = [self gainRightView];
//    rightView.isDismissAnimate = YES;
////    [rightView show];
////    [rightView showAnimate:CommonBgView_fromRight];
//    [rightView showAnimate:0.3 type:CommonBgView_fromRight];
}

#pragma -mark BottomSelectViewDelegate
- (void)didSelectedBottomSelectView:(BottomSelectView *)selectView selectedImage:(UIImageView *)selectedImage selectedTitle:(UILabel *)selectedTitle
{
    NSLog(@"didSelectedBottomSelectView");
}

#pragma -mark PanGestureDelegate
- (void)didPanDirection:(PanGesture *)panGesture direction:(NSInteger)direction
{
    NSLog(@"didPanDirection");
    if(curPage==1)
        return;
    
    switch (direction) {
        case PanMoveDirectionLeft:
        {
            if(curPage!=2)
                return;
            [self rightAction];
            break;
        }
        case PanMoveDirectionRight:
            
            break;
            
        default:
            break;
    }
    
}

#pragma -mark scrollViewDidScroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"scrollx = %f",scrollView.contentOffset.x);
    if(scrollView.contentOffset.x<=0)
    {
        curPage = 0;
        pageView.curPage = curPage;
        [pageView updateView];
    }
    if(scrollView.contentOffset.x==SCREEN_WIDTH)
    {
        curPage = 1;
        pageView.curPage = curPage;
        [pageView updateView];
    }
    if(scrollView.contentOffset.x>=SCREEN_WIDTH*2)
    {
        curPage = 2;
        pageView.curPage = curPage;
        [pageView updateView];
    }
}

#pragma -mark UICollectionDelegate
//设置每个item的大小，双数的为50*50 单数的为100*100
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height-80);
//}
//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}
//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    return cell;
}

@end
