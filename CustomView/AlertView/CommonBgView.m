//
//  CommonBgView.m
//  SummaryTest
//
//  Created by  Tmac on 2017/6/30.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "CommonBgView.h"

@interface CommonBgView()
{
    UIView *subview;
    UIView *bgView;
    
    CGFloat dur;
    int aniType;        //动画类型
}
@end


@implementation CommonBgView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame subView:nil];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithFrame:CGRectZero subView:nil];
}

- (id)initWithFrame:(CGRect)frame subView:(UIView *)_subView
{
    if(self = [super initWithFrame:frame])
    {
        subview = _subView;
    }
    
    return self;
}

- (id)initWithName
{
    return [self initWithFrame:CGRectZero subView:nil];
}

- (void)createView
{
    self.backgroundColor = [UIColor clearColor];
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    [self addSubview:bgView];
    //点击事件
    UITapGestureRecognizer *singleTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tap)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [bgView addGestureRecognizer:singleTap];
    
    if(self.alphaVal>0)
        bgView.alpha = self.alphaVal;
    if(self.bgColor)
        bgView.backgroundColor = self.bgColor;
    
    if(subview)
        [self addSubview:subview];
}


- (void)tap
{
    if(self.isDismissAnimate)       //有消失动画
    {
        switch (aniType) {
            case CommonBgView_fromRight:
                [self animateFromRight_disMiss];
                break;
            case CommonBgView_fromLeft:
                [self animateFromLeft_disMiss];
                break;
            default:
                [self defaultMissAnimate];
                break;
        }
    }
    else
        [self removeFromSuperview];
}

- (void)show
{
    //显示之前，先移除之前的
    [self removeFromSuperview];
    
    [self createView];
    // 当前顶层窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow ;
    [window addSubview:self];
    
}

- (void)showAnimate:(int)type
{
    [self show];
    aniType = type;
    switch (type) {
        case CommonBgView_fromRight:
            [self animateFromRight];
            break;
        case CommonBgView_fromLeft:
            [self animateFromLeft];
            break;
        case CommonBgView_alert:
            [self animateAlert];
            break;
            
        default:
            [self animateAlert];
            break;
    }
}

- (void)showAnimate:(CGFloat)duration type:(int)type
{
    dur = duration;
    [self showAnimate:type];
}


///////////////////////动画//////////////////////
//消失动画
//默认动画
- (void)defaultMissAnimate
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}
//右划出的相反动画
- (void)animateFromRight_disMiss
{
    if(!subview)
        return;
    CGRect tmpFrame = subview.frame;
    
    void (^animations)() = ^{
        subview.frame = CGRectMake(CGRectGetMaxX(tmpFrame), tmpFrame.origin.y, tmpFrame.size.width, tmpFrame.size.height);
    };
    void (^completion)(BOOL) = ^(BOOL finished)
    {
        [self removeFromSuperview];
    };
    
    CGFloat time = 0.5;
    if(dur>0)
        time = dur;
    [UIView animateWithDuration:time delay:0 options:kNilOptions animations:animations completion:completion];
}
//左划出的相反动画
- (void)animateFromLeft_disMiss
{
    if(!subview)
        return;
    CGRect tmpFrame = subview.frame;
    void (^animations)() = ^{
        subview.frame = CGRectMake(tmpFrame.origin.x-tmpFrame.size.width, tmpFrame.origin.y, tmpFrame.size.width, tmpFrame.size.height);
    };
    void (^completion)(BOOL) = ^(BOOL finished)
    {
        [self removeFromSuperview];
    };
    
    CGFloat time = 0.5;
    if(dur>0)
        time = dur;
    [UIView animateWithDuration:time delay:0 options:kNilOptions animations:animations completion:completion];
    
}


//开始动画
//从右边划出
- (void)animateFromRight
{
    if(!subview)
        return;
    CGRect tmpFrame = subview.frame;
    subview.frame = CGRectMake(CGRectGetMaxX(tmpFrame), tmpFrame.origin.y, tmpFrame.size.width, tmpFrame.size.height);
    void (^animations)() = ^{
            subview.frame = tmpFrame;
    };
    void (^completion)(BOOL) = ^(BOOL finished)
    {
       
    };

    CGFloat time = 0.5;
    if(dur>0)
        time = dur;
    [UIView animateWithDuration:time delay:0 options:kNilOptions animations:animations completion:completion];
    
}
//从左边划出
- (void)animateFromLeft
{
    if(!subview)
        return;
    CGRect tmpFrame = subview.frame;
    subview.frame = CGRectMake(tmpFrame.origin.x-tmpFrame.size.width, tmpFrame.origin.y, tmpFrame.size.width, tmpFrame.size.height);
    void (^animations)() = ^{
        
        subview.frame = tmpFrame;
        
        
    };
    void (^completion)(BOOL) = ^(BOOL finished)
    {
        
    };
    
    CGFloat time = 0.5;
    if(dur>0)
        time = dur;
    [UIView animateWithDuration:time delay:0 options:kNilOptions animations:animations completion:completion];
    
}

//微小震动弹出，用于弹出框
-(void)animateAlert
{
    if(!subview)
        return;
    
    CGFloat time = 0.3;
    if(dur>0)
        time = dur;
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = time;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [subview.layer addAnimation:animation forKey:nil];
}
@end
