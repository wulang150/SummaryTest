//
//  TestView2.m
//  SummaryTest
//
//  Created by  Tmac on 2018/8/9.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "TestView2.h"

@interface TestView2()
{
    BOOL isTouchBtn;
}
@end

@implementation TestView2

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor redColor];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    ShowFun;
    if(isTouchBtn)
        NSLog(@"检测到点击了View1的btn");
}

- (void)doForBtn
{
    NSLog(@"点击了view1的btn");
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    NSLog(@"%s pointX=%f,pointY=%f",__FUNCTION__,point.x,point.y);
//    UITouch *touch = [event.allTouches anyObject];
//    if([touch.view isKindOfClass:[UIButton class]])
    {
        if(point.x>=20&&point.x<=44)
        {
            if(point.y>=-108&&point.y<=-88)
            {
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doForBtn) object:nil];
                [self performSelector:@selector(doForBtn) withObject:nil afterDelay:0.2];
            }
        }
    }
    
    return [super hitTest:point withEvent:event];
}
@end
