//
//  TestView.m
//  SummaryTest
//
//  Created by  Tmac on 2017/12/1.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "TestView.h"

@implementation TestView

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
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(10, 10, 80, 32);
    [btn setTitle:@"按钮" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
}

- (void)btnAction:(UIButton *)sender
{
    NSLog(@"%s",__FUNCTION__);
}

//如果不重写这些方法，就相当于此view不响应事件，交给父级处理
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__FUNCTION__);
    
    //也同时让父类处理
//    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__FUNCTION__);
}

//判断自己是否是事件处理的最适合的view
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    //这个point，是点击的位置相对于本view的相对位置，如果是在本view内的，那么point的值肯定在w和h内
    NSLog(@"%s pointX=%f,pointY=%f",__FUNCTION__,point.x,point.y);
//    return [super hitTest:point withEvent:event];
    //下面我想控制，返回自己就是最适合的view，这样的话，有可能很多消息都被它捕获了，
//    return self;
    //这里我只想捕获BView的touch事件，下面加入一些控制
    if(point.x>0&&point.x<self.width)
    {
        CGFloat y = point.y-(self.height+20);    //转换为对B的位置
        if(y>0&&y<100)
        {
            return self;
        }
    }
    //其他的消息按正常的方式处理
    return [super hitTest:point withEvent:event];
}
@end
