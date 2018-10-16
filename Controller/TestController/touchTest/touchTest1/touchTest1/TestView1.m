//
//  TestView1.m
//  SummaryTest
//
//  Created by  Tmac on 2018/8/9.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "TestView1.h"

@implementation TestView1

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
    self.backgroundColor = [UIColor yellowColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点击" forState:UIControlStateNormal];
    btn.frame = CGRectMake(10, 10, 60, 30);
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (void)btnAction
{
    ShowFun;
}

@end
