//
//  AnimateViewController.m
//  SummaryTest
//
//  Created by  Tmac on 2018/7/31.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "AnimateViewController.h"

@interface AnimateViewController ()

@end

@implementation AnimateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createView
{
    [self setNavWithTitle:@"测试动画" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
    [self test4];
//    [self test2];
    
//    [self test3];
}

- (void)test4
{
    //让view沿着Bezier曲线运动
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 10, 10)];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    //    shapeLayer.frame = CGRectMake(20, 100, 100, 100);
    
    //    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:shapeLayer.bounds];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 100) radius:20 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [path moveToPoint:CGPointMake(120, 100)];
    [path addLineToPoint:CGPointMake(200, 100)];
    [path addLineToPoint:CGPointMake(200, 200)];
    [path addLineToPoint:CGPointMake(120, 200)];
    [path addLineToPoint:CGPointMake(120, 100)];
    [path addArcWithCenter:CGPointMake(140, 100) radius:20 startAngle:M_PI endAngle:M_PI*3 clockwise:YES];
    
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 2.0f;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:shapeLayer];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    //设置动画属性，因为是沿着贝塞尔曲线动，所以要设置为position
    animation.keyPath = @"position";
    //设置动画时间
    animation.duration = 4;
    // 告诉在动画结束的时候不要移除
    animation.removedOnCompletion = NO;
    // 始终保持最新的效果
    animation.fillMode = kCAFillModeForwards;
    animation.path = path.CGPath;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [redView.layer addAnimation:animation forKey:nil];
}

- (void)test1
{
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.frame = CGRectMake(20, 100, 100, 100);
    
//    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:shapeLayer.bounds];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 100) radius:20 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [path moveToPoint:CGPointMake(120, 100)];
    [path addLineToPoint:CGPointMake(200, 100)];
    [path addLineToPoint:CGPointMake(200, 200)];
    [path addLineToPoint:CGPointMake(120, 200)];
    [path addLineToPoint:CGPointMake(120, 100)];
    [path addArcWithCenter:CGPointMake(140, 100) radius:20 startAngle:M_PI endAngle:M_PI*3 clockwise:YES];
    
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 2.0f;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:shapeLayer];
    
    float duration = 12.0f;
    float circleLen = 2*M_PI*20;
    float allLen = circleLen*2+180*2;
    float speed = allLen/duration;      //速度
    
    CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnima.duration = duration;
    //效果就是一条路径从终点到起点慢慢消失
//    pathAnima.fromValue = [NSNumber numberWithFloat:1.0f];
//    pathAnima.toValue = [NSNumber numberWithFloat:0.0f];
    //效果就是一条路径起点到终点慢慢的出现
    pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnima.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnima.fillMode = kCAFillModeForwards;
    pathAnima.removedOnCompletion = NO;
    pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    [shapeLayer addAnimation:pathAnima forKey:@"strokeEndAnimation"];
    
    CABasicAnimation *SpathAnima = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    SpathAnima.beginTime = circleLen/speed;
    SpathAnima.duration = pathAnima.duration;
    //效果就是一条从路径终点到起点慢慢的出现
    //    pathAnima.fromValue = [NSNumber numberWithFloat:1.0f];
    //    pathAnima.toValue = [NSNumber numberWithFloat:0.0f];
    //效果就是一条从路径起点到终点慢慢的消失
    SpathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
    SpathAnima.toValue = [NSNumber numberWithFloat:1.0f];
    SpathAnima.fillMode = kCAFillModeForwards;
    SpathAnima.removedOnCompletion = NO;
    SpathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    [shapeLayer addAnimation:SpathAnima forKey:@"strokeStartAnimation"];
    
    [CATransaction begin];
    CAAnimationGroup *transitionAnimationGroup = [CAAnimationGroup animation];
    //    transitionAnimationGroup.animations  = @[leadingAnimation,trailingAnimation];
    transitionAnimationGroup.animations  = @[pathAnima,SpathAnima];
    transitionAnimationGroup.duration = pathAnima.duration;
    transitionAnimationGroup.removedOnCompletion = NO;
    transitionAnimationGroup.fillMode =kCAFillModeForwards;
    [shapeLayer addAnimation:transitionAnimationGroup forKey:nil];
    [CATransaction commit];
    
//    [self.view.layer addSublayer:animatingTabTransitionLayer];
}

- (void)test2
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(140, 100, 100, 100);
    
    //    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:shapeLayer.bounds];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 50) radius:20 startAngle:0 endAngle:M_PI * 2 clockwise:NO];
    
    shapeLayer.path = path.CGPath;
    
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 2.0f;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    
    [self.view.layer addSublayer:shapeLayer];
    
    CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnima.duration = 3.0f;
    pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnima.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnima.fillMode = kCAFillModeForwards;
    pathAnima.removedOnCompletion = NO;
    [shapeLayer addAnimation:pathAnima forKey:@"strokeEndAnimation"];
}

- (void)test3
{
    CAShapeLayer *animatingTabTransitionLayer = [CAShapeLayer layer];
    UIBezierPath *animatingTabTransitionBezierPath = [UIBezierPath bezierPath];
    animatingTabTransitionLayer.strokeColor = [UIColor redColor].CGColor;
    animatingTabTransitionLayer.fillColor = [UIColor clearColor].CGColor;
    animatingTabTransitionLayer.lineWidth = 1;
    
    [animatingTabTransitionBezierPath addArcWithCenter:CGPointMake(100, 100) radius:20 startAngle:M_PI/2 endAngle:M_PI clockwise:NO];
    [animatingTabTransitionBezierPath addArcWithCenter:CGPointMake(100, 100) radius:20 startAngle:M_PI  endAngle:M_PI/2 clockwise:NO];
    
    [animatingTabTransitionBezierPath moveToPoint:CGPointMake(100, 120)];
    [animatingTabTransitionBezierPath addLineToPoint:CGPointMake(200, 120)];
    
    [animatingTabTransitionBezierPath addArcWithCenter:CGPointMake(200, 100) radius:20 startAngle:M_PI/2 endAngle:M_PI clockwise:NO];
    [animatingTabTransitionBezierPath addArcWithCenter:CGPointMake(200, 100) radius:20 startAngle:M_PI  endAngle:M_PI/2 clockwise:NO];
    
    double circumference = 2*M_PI*(10);     //周长
    double distanceBetweenTabs = 100;
    double totalLength = 2*circumference + distanceBetweenTabs;     //总距离
    
    animatingTabTransitionLayer.path = animatingTabTransitionBezierPath.CGPath;
    //strokeEnd从 0-1，strokeEnd=0 时，无路径，strokeEnd=1 时，一条完整路径。效果就是一条路径起点到终点慢慢的出现
    CABasicAnimation *leadingAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    leadingAnimation.duration = 3.0;
    leadingAnimation.fromValue = @0;
    leadingAnimation.toValue = @1;
    leadingAnimation.removedOnCompletion = NO;
    leadingAnimation.fillMode =kCAFillModeForwards;
    leadingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    //strokeStart从 0 到 1 ，strokeStart = 0 时有一条完整的路径，strokeStart = 1 时 路径消失。效果就是一条从路径起点到终点慢慢的消失
    CABasicAnimation *trailingAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    trailingAnimation.duration = leadingAnimation.duration - 0.15;
    trailingAnimation.fromValue = @0;
    trailingAnimation.removedOnCompletion = NO;
    trailingAnimation.fillMode =kCAFillModeForwards;
    trailingAnimation.toValue = @((circumference+distanceBetweenTabs)/totalLength);
    trailingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [CATransaction begin];
    CAAnimationGroup *transitionAnimationGroup = [CAAnimationGroup animation];
//    transitionAnimationGroup.animations  = @[leadingAnimation,trailingAnimation];
    transitionAnimationGroup.animations  = @[trailingAnimation,leadingAnimation];
    transitionAnimationGroup.duration = leadingAnimation.duration;
    transitionAnimationGroup.removedOnCompletion = NO;
    transitionAnimationGroup.fillMode =kCAFillModeForwards;
    [animatingTabTransitionLayer addAnimation:transitionAnimationGroup forKey:nil];
    [CATransaction commit];
    
    [self.view.layer addSublayer:animatingTabTransitionLayer];
}

@end
