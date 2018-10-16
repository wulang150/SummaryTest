//
//  LiftCollectionLayout.m
//  SimpleTest
//
//  Created by  Tmac on 2018/7/18.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "LiftCollectionLayout.h"

@implementation LiftCollectionLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    // 水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = 12;
    self.itemSize = CGSizeMake(160, 180);

}

//设置放大动画
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *arr = [self getCopyOfAttributes:[super layoutAttributesForElementsInRect:rect]];
    //屏幕中线
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width/2.0f;
    //刷新cell缩放
    for (UICollectionViewLayoutAttributes *attributes in arr) {

        CGFloat distance = fabs(attributes.center.x - centerX);
        //移动的距离和屏幕宽度的的比例
        CGFloat apartScale = distance/self.collectionView.bounds.size.width;
        //把卡片移动范围最大为1，最小不是0，有一个最小值
        CGFloat scale = fabs(cos(apartScale * M_PI/3));
        //设置cell的缩放 按照余弦函数曲线 越居中越趋近于1
        attributes.transform = CGAffineTransformMakeScale(1.0, scale);
        //调整y值
        CGRect frame = attributes.frame;
        CGFloat y = self.collectionView.bounds.size.height - frame.size.height;
//        NSLog(@">>>%f",frame.size.height);
        //
        y += 20;
        frame.origin.y = y;
        attributes.frame = frame;
    }
    return arr;
}

//防止报错 先复制attributes
- (NSArray *)getCopyOfAttributes:(NSArray *)attributes
{
    NSMutableArray *copyArr = [NSMutableArray new];
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        [copyArr addObject:[attribute copy]];
    }
    return copyArr;
}


//是否需要重新计算布局
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return true;
}

/**
 
 * 这个方法的返回值，就决定了collectionView停止滚动时的偏移量
 
 */

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity

{
    
    // 计算出最终显示的矩形框
    
    CGRect rect;
    
    rect.origin.y = 0;
    
    rect.origin.x = proposedContentOffset.x;
    
    rect.size = self.collectionView.frame.size;
    
    //    NSLog(@"offX = %f",proposedContentOffset.x);
    
    // 获得super已经计算好的布局属性
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // 计算collectionView最中心点的x值
    
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 存放最小的间距值
    
    CGFloat minDelta = MAXFLOAT;
    
    for (UICollectionViewLayoutAttributes *attrs in array) {
        
        if (ABS(minDelta) > ABS(attrs.center.x - centerX)) {
            
            minDelta = attrs.center.x - centerX;
            
        }
        
    }
    
    // 修改原有的偏移量，把最靠经中间的移动到collection的中心
    
    proposedContentOffset.x += minDelta;
    
    return proposedContentOffset;
    
}

@end
