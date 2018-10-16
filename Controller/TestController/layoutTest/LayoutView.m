//
//  LayoutView.m
//  SummaryTest
//
//  Created by  Tmac on 2017/12/4.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "LayoutView.h"

@interface LayoutView()
{
    UILabel *lab;
}
@end

@implementation LayoutView

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
    lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.width-30, 30)];
    lab.text = @"sdfdsfdsfd";
    lab.centerX = self.width/2;
    lab.centerY = self.height/2;
    
    [self addSubview:lab];
    
//    lab = [[UILabel alloc] init];
//    lab.text = @"sdfdsdsgg";
//    [self addSubview:lab];
//    
//    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self);
//    }];
    
//    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.backgroundColor = [UIColor redColor];
//    [self addSubview:imageView];
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@(30));
//        make.center.equalTo(self);
//    }];
}

- (void)changeSubW:(CGFloat)w
{
    lab.width = w;
//    lab.x = 0;
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    ShowFun;
}

- (void)layoutSubviews
{
    ShowFun;
//    [self createView];
    NSLog(@"%@,%f,%@",lab.text,lab.width,_content);

}

- (void)drawRect:(CGRect)rect
{
    ShowFun;
}

@end
