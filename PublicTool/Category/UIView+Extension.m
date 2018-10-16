//
//  UIView+Extension.m
//  SummaryTest
//
//  Created by  Tmac on 2018/3/29.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

//通过遮挡层设置圆角
- (void)setCirCleRoundByRadius:(CGFloat)radius
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
@end
