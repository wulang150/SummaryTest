//
//  MyCollectionLayout.m
//  SimpleTest
//
//  Created by  Tmac on 2017/6/26.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "MyCollectionLayout.h"

static NSUInteger CellWidth = 100;
static CGFloat ContentHeight;

@interface MyCollectionLayout()
{
    NSMutableArray *_yOffsets;      //存储各列的当前offest
}
@property (nonatomic, strong) NSMutableDictionary *layoutInformation;
@property (nonatomic) NSInteger maxNumCols;
@end

@implementation MyCollectionLayout

- (instancetype)init
{
    
    if (self = [super init]) {
        
    }
    
    return self;
    
}

/**
 
 * 当collectionView的显示范围发生改变的时候，是否需要重新刷新布局
 
 * 一旦重新刷新布局，就会重新调用下面的方法：
 
 1.prepareLayout
 
 2.layoutAttributesForElementsInRect:方法
 
 */

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds

{
    
    return YES;
    
}



/**
 
 * 用来做布局的初始化操作（不建议在init方法中进行布局的初始化操作）
 
 */

- (void)prepareLayout

{
    
    [super prepareLayout];
    
//    // 水平滚动
//    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    self.minimumLineSpacing = 20;
    
    // 设置内边距
//    CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width) * 0.5;
//    
////    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
//    
//   self.collectionView.contentInset = UIEdgeInsetsMake(0, inset, 0, inset);
    
    CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width) * 0.5;
    CGFloat yinset = (self.collectionView.frame.size.height - self.itemSize.height) * 0.5;
    // 设置第一个和最后一个默认居中显示
//    self.collectionView.contentInset = UIEdgeInsetsMake(yinset, inset, yinset, inset);
    self.sectionInset = UIEdgeInsetsMake(yinset, inset, yinset, inset);
}



/**
 
 UICollectionViewLayoutAttributes *attrs;
 
 1.一个cell对应一个UICollectionViewLayoutAttributes对象
 
 2.UICollectionViewLayoutAttributes对象决定了cell的frame
 
 */

/**
 
 * 这个方法的返回值是一个数组（数组里面存放着rect范围内所有元素的布局属性）
 
 * 这个方法的返回值决定了rect范围内所有元素的排布（frame）
 
 */

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    // 获得super已经计算好的布局属性，获取到原来的布局
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    // 计算collectionView最中心点的x值
    
    CGRect visibleRect;
    visibleRect.origin =self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.frame.size;

    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;

//    NSLog(@"collectX=%f",self.collectionView.contentOffset.x);


    // 在原有布局属性的基础上，进行微调

    for (UICollectionViewLayoutAttributes *attrs in array) {

        // 只处理正在界面上面显示的Item
//        if(!CGRectIntersectsRect(visibleRect, attrs.frame))
//            continue;
        // cell的中心点x 和 collectionView最中心点的x值 的间距
        CGFloat delta = ABS(attrs.center.x - centerX);
//        CGFloat scale = 0.8;
//        if(delta==0)
//        {
//            scale = 1;
//        }

        // 根据间距值 计算 cell的缩放比例
        CGFloat scale = 1 - delta / (self.collectionView.frame.size.width*0.5)*0.2;
//        if(scale<0)
//            scale = 0.1;
        //不让他无限缩小，有个最小值
        if(scale<0.8)
            scale = 0.8;

        // 设置缩放比例
        attrs.transform = CGAffineTransformMakeScale(scale, scale);

    }

    return array;
    
//    NSArray *array = [super layoutAttributesForElementsInRect:rect];
//
//
//    CGRect visibleRect;
//    visibleRect.origin =self.collectionView.contentOffset;
//    visibleRect.size = self.collectionView.frame.size;
//
//    CGFloat collectionViewCenterX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
//
//    for (UICollectionViewLayoutAttributes *attrs in array) {
//        // 只处理正在界面上面显示的Item
//        if(!CGRectIntersectsRect(visibleRect, attrs.frame))
//            continue;
//
//        // 计算各个Item的缩放比例(距离中线越近，缩放比例就越大)
//        CGFloat scale;
//        // 防止突变的情况(当Item的中心与collectionView中心的距离大于等于collectionView宽度的一半时，Item不缩放，平稳过度)
////        CGFloat delta = ABS(attrs.center.x - collectionViewCenterX);
//        if(ABS(attrs.center.x - collectionViewCenterX) >= self.collectionView.frame.size.width * 0.5){
//            scale = 1;
//        }
//        else{
//            scale = 1 + 0.8 * (1 - ABS(attrs.center.x - collectionViewCenterX) / (self.collectionView.frame.size.width * 0.5));
//        }
//        attrs.transform3D = CATransform3DMakeScale(scale, scale, 1);
//    }
//
//
//    return array;
    
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
