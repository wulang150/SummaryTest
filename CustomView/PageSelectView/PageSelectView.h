//
//  PageSelectView.h
//  SummaryTest
//
//  Created by  Tmac on 2017/7/5.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageSelectView : UIView

- (id)initWithCenter:(CGFloat)y pageCount:(NSInteger)pageCount;

//- (id)initWithCenter:(CGFloat)y pageCount:(NSInteger)pageCount WithOnColor:(UIColor *)onColor WithOffColor:(UIColor *)OffOcolor;

- (void)updateView;

@property(nonatomic,strong) UIColor *onColor;
@property(nonatomic,strong) UIColor *offColor;
@property(nonatomic,assign) CGFloat spaceLeg;       //点之间的空隙
@property(nonatomic,assign) CGFloat radius;         //半径
@property(nonatomic,assign) NSInteger curPage;        //当前页
@property(nonatomic,assign) NSInteger pageCount;

//加入图片的情况
@property(nonatomic,strong) UIImage *selectImg;     //选中后的图片
@property(nonatomic) CGSize imgSize;                //选中后图的的size
@end
