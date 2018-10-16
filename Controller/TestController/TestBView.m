//
//  TestBView.m
//  SummaryTest
//
//  Created by  Tmac on 2017/12/1.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "TestBView.h"

@implementation TestBView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self createView];
    }
    return self;
}

- (void)createView
{
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1)];
    tap1.numberOfTapsRequired = 1;
    tap1.numberOfTouchesRequired = 1;
//    [self addGestureRecognizer:tap1];
}

- (void)tap1
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__FUNCTION__);
}

//判断当前view是否为最舍和处理事件的view，不是就返回nil，代表我的子类和我都不适合处理，找其他的view吧
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    NSLog(@"%s pointX=%f,pointY=%f",__FUNCTION__,point.x,point.y);
//    return [super hitTest:point withEvent:event];
//}
@end
