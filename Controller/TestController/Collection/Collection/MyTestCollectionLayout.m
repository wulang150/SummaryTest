//
//  MyTestCollectionLayout.m
//  SummaryTest
//
//  Created by  Tmac on 2018/7/20.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "MyTestCollectionLayout.h"

@implementation MyTestCollectionLayout
{
    //这个数组就是我们自定义的布局配置数组
    NSMutableArray * _attributeAttay;
}

//将滚动范围设置为(item总数+2)*每屏高度
-(CGSize)collectionViewContentSize{
//    return CGSizeMake(self.collectionView.frame.size.width, (44+self.minimumLineSpacing)*([self.collectionView numberOfItemsInSection:0]-1)+44);
    
    return CGSizeMake(self.collectionView.frame.size.width*([self.collectionView numberOfItemsInSection:0]+2), 180);
}

-(void)prepareLayout
{
    [super prepareLayout];
    _attributeAttay = [[NSMutableArray alloc]init];

    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];

    for (int i=0; i<itemCount; i++) {
        //设置每个item的位置等相关属性
        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
        
        [_attributeAttay addObject:[self layoutAttributesForItemAtIndexPath:index]];
    }
//    self.itemSize = CGSizeMake(width, height);
//    self.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
//    self.scrollDirection = UICollectionViewScrollDirectionVertical;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = 60;
    CGFloat height = 180;
    CGFloat y = 10;
    //获取item的个数
    int itemCounts = (int)[self.collectionView numberOfItemsInSection:0];
    //创建一个布局属性类，通过indexPath来创建
    UICollectionViewLayoutAttributes * attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
//    y = (height+self.minimumLineSpacing)*i;
    
    attris.frame = CGRectMake(30, y, width, height);
    
    //全部定位于中间
//    attris.center = CGPointMake(self.collectionView.frame.size.width/2, self.collectionView.frame.size.height/2);
    attris.center = CGPointMake(self.collectionView.frame.size.width/2+self.collectionView.contentOffset.x, self.collectionView.frame.size.height/2);
    
    //加入3D效果
    //CATransform3DIdentity创建空得矩阵
    CATransform3D trans3D = CATransform3DIdentity;
    //这个值设置的是透视度，影响视觉离投影平面的距离
    trans3D.m34 = -1/900.0;
    //下面这些属性 后面会具体介绍
    //这个是3D滚轮的半径
    CGFloat radius = 50/tanf(M_PI*2/itemCounts/2);
    //计算每个item应该旋转的角度
    //获取当前的偏移量
    float offset = self.collectionView.contentOffset.x;
    //在角度设置上，添加一个偏移角度
    float angleOffset = offset/self.collectionView.frame.size.width;
    CGFloat angle = (float)(indexPath.row+angleOffset)/itemCounts*M_PI*2;
//    CGFloat angle = (float)(indexPath.row+angleOffset-1)/itemCounts*M_PI*2;
//    CGFloat angle = (float)(indexPath.row)/itemCounts*M_PI*2;
    //这个方法返回一个新的CATransform3D对象，在原来的基础上进行旋转效果的追加
    //第一个参数为旋转的弧度，后三个分别对应x，y，z轴，我们需要以x轴进行旋转
    trans3D = CATransform3DRotate(trans3D, angle, 0, -1.0, 0);
    //这个方法也返回一个transform3D对象，追加平移效果，后面三个参数，对应平移的x，y，z轴，我们沿z轴平移
    trans3D = CATransform3DTranslate(trans3D, 0, 0, radius);
    //进行设置
    attris.transform3D = trans3D;
    
    return attris;
}

//返回yes，则一有变化就会刷新布局
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
    
}

//这个方法中返回我们的布局数组
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return _attributeAttay;
}


@end
