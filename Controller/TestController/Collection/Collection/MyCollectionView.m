//
//  MyCollectionView.m
//  SimpleTest
//
//  Created by  Tmac on 2017/7/11.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "MyCollectionView.h"

@implementation MyCollectionView

//点击了scroll上的子图时
//判断是否多点触摸：NSSet有多少个UITouch对象元素
//一次完整的触摸过程中，只会产生一个事件对象event
//这里返回的view为cell.contentView
- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    
//    NSLog(@"用户点击了scroll上的视图%@,是否开始滚动scroll",view);
//    UITouch * touch = touches.anyObject;//获取触摸对象
//    
//    CGPoint point = [touch locationInView:view];
//    NSLog(@"point.y = %f view.bounds=%f",point.y,view.frame.size.height);
    
//    CGPoint point = [touch locationInView:view];
//    if(point.y<view.bounds.size.height/2)
//        return YES;
//    NSLog(@"%@",point);

//    UIImageView *myImage;
//    for(UIView *sub in view.subviews)
//    {
//        if([sub isKindOfClass:[UIImageView class]])
//        {
//            myImage = sub;
//            break;
//        }
//    }
//    
//    if(myImage)     //如果touch的是contentView上的image控件，就只触发touch，不scroll
//    {
//        CGPoint point = [touch locationInView:myImage];
//        if(CGRectContainsPoint(myImage.bounds, point))
//            return YES;
//    }
//    
//    if([touch.view isKindOfClass:[UIImageView class]])
//        return YES;
//    //返回yes 是不滚动 scroll 返回no 是滚动scroll
//    if([view isKindOfClass:[UIImageView class]])
//        return YES;
    return NO;
}



//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    NSLog(@"%@----hitTest:", [self class]);
//    // 如果控件不允许与用户交互那么返回 nil
//    if (self.userInteractionEnabled == NO || self.alpha <= 0.01 || self.hidden == YES) {
//        return nil;
//    }
//    // 如果这个点不在当前控件中那么返回 nil
//    if (![self pointInside:point withEvent:event]) {
//        return nil;
//    }
//    
//    // 从后向前遍历每一个子控件
//    for (int i = (int)self.subviews.count - 1; i >= 0; i--) {
//        // 获取一个子控件
//        UIView *lastVw = self.subviews[i];
//        // 把当前触摸点坐标转换为相对于子控件的触摸点坐标
//        CGPoint subPoint = [self convertPoint:point toView:lastVw];
//        // 判断是否在子控件中找到了更合适的子控件
//        UIView *nextVw = [lastVw hitTest:subPoint withEvent:event];
//        // 如果找到了返回
//        if (nextVw) {
//            return nextVw;
////            tmp = nextVw;
//        }
//    }
//    // 如果以上都没有执行 return, 那么返回自己(表示子控件中没有"更合适"的了)
//    return  self;
//}
//点击后的在子图上滑动
//- (BOOL)touchesShouldCancelInContentView:(UIView *)view
//{
//
//    NSLog(@"用户点击的视图 %@",view);
//
//    //NO scroll不可以滚动 YES scroll可以滚动
//    return NO;
//}

@end
