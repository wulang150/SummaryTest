//
//  CommonBgView.h
//  SummaryTest
//
//  Created by  Tmac on 2017/6/30.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import <UIKit/UIKit.h>

enum{
    CommonBgView_fromRight = 1,         //从右边划出
    CommonBgView_fromLeft,
    CommonBgView_alert                  //弹出动作
};

@interface CommonBgView : UIView

@property(nonatomic) CGFloat alphaVal;      //透明度
@property(nonatomic,strong) UIColor *bgColor;
@property(nonatomic) BOOL isDismissAnimate;     //退出时候是否有动画

- (id)initWithFrame:(CGRect)frame subView:(UIView *)subView NS_DESIGNATED_INITIALIZER;
//可以定义多个指定初始化函数，但使用一个就不会有警告了
- (id)initWithName;
- (void)show;       //无动画
- (void)showAnimate:(int)type;
- (void)showAnimate:(CGFloat)duration type:(int)type;


@end
