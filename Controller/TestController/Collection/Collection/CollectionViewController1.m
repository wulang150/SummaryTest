//
//  CollectionViewController1.m
//  SummaryTest
//
//  Created by  Tmac on 2018/7/19.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "CollectionViewController1.h"
#import "ThreeDCollectionLayout.h"
#import "MyTestCollectionLayout.h"

@interface CollectionViewController1 ()
<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation CollectionViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view, typically from a nib.
//    ThreeDCollectionLayout *layout = [[ThreeDCollectionLayout alloc] init];
    MyTestCollectionLayout *layout = [[MyTestCollectionLayout alloc] init];
    
    UICollectionView * collect  = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 60, 320, 400) collectionViewLayout:layout];
    collect.delegate=self;
    collect.dataSource=self;
    //一开始将collectionView的偏移量设置为1屏的偏移量
//    collect.contentOffset = CGPointMake(320, 0);
    [collect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    [self.view addSubview:collect];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    label.text = [NSString stringWithFormat:@"我是第%ld行",(long)indexPath.row];
    label.adjustsFontSizeToFitWidth = YES;
    [cell.contentView addSubview:label];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    //小于半屏 则放到最后一屏多半屏
//    if (scrollView.contentOffset.y<200) {
//        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y+10*400);
//        //大于最后一屏多一屏 放回第一屏
//    }else if(scrollView.contentOffset.y>11*400){
//        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y-10*400);
//    }
    
    //小于半屏 则放到最后一屏多半屏
    if (scrollView.contentOffset.x<160) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x+10*320, scrollView.contentOffset.y);
        //大于最后一屏多一屏 放回第一屏
    }else if(scrollView.contentOffset.x>11*320){
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x-10*320, scrollView.contentOffset.y);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@">>>>>>>>>>>%zi",indexPath.row);
}

@end
