//
//  BaseController.m
//  SummaryTest
//
//  Created by  Tmac on 2017/6/29.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "BaseController.h"

@interface BaseController ()

@end

@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack
{
    NSLog(@"goBack");
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)setNavWithTitle:(NSString *)title
              leftImage:(NSString *)leftImage
              leftTitle:(NSString *)leftTitle
             leftAction:(SEL)leftAction
             rightImage:(NSString *)rightImage
             rightTitle:(NSString *)rightTitle
            rightAction:(SEL)rightAction
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *view = [[self class] comNavWithTitle:title leftImage:leftImage leftTitle:leftTitle leftAction:leftAction rightImage:rightImage rightTitle:rightTitle rightAction:rightAction itemSelf:self];
    
    UIButton *leftBtn = [view viewWithTag:700];
    UILabel *titleView = [view viewWithTag:701];
    UIButton *rightBtn = [view viewWithTag:702];
    
    self.NavleftBtn = leftBtn;
    self.NavrightBtn = rightBtn;
    self.NavtitleLab = titleView;
    
    if(!leftAction)
    {
        [leftBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.view addSubview:view];
    return view;
}

+ (UIView *)comNavWithTitle:(NSString *)title
                  leftImage:(NSString *)leftImage
                  leftTitle:(NSString *)leftTitle
                 leftAction:(SEL)leftAction
                 rightImage:(NSString *)rightImage
                 rightTitle:(NSString *)rightTitle
                rightAction:(SEL)rightAction
                   itemSelf:(id)itemSelf
{
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavigationBar_HEIGHT)];
    navView.backgroundColor = [UIColor grayColor];
    
    CGFloat wbtn = 40,lx = 8,lh = 20;
    
    //左按钮
    UIButton *leftBtn = [self gainBtn:CGRectMake(lx, lh+(NavigationBar_HEIGHT-wbtn-lh)/2, wbtn, wbtn) title:leftTitle image:leftImage];
    leftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    leftBtn.tag = 700;
    if(leftAction)
    {
        [leftBtn addTarget:itemSelf action:leftAction forControlEvents:UIControlEventTouchUpInside];
    }
    
    //标题
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, lh, SCREEN_WIDTH, NavigationBar_HEIGHT-lh)];
    navTitle.font = [UIFont systemFontOfSize:20];
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.textColor = [UIColor whiteColor];
    navTitle.tag = 701;
    navTitle.text = title;
    
    //右按钮
    UIButton *rightBtn = [self gainBtn:CGRectMake(SCREEN_WIDTH-wbtn-lx, lh+(NavigationBar_HEIGHT-wbtn-lh)/2, wbtn, wbtn) title:rightTitle image:rightImage];
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    rightBtn.tag = 702;
    if(rightAction)
    {
        [rightBtn addTarget:itemSelf action:rightAction forControlEvents:UIControlEventTouchUpInside];
    }
    
    [navView addSubview:navTitle];
    [navView addSubview:leftBtn];
    [navView addSubview:rightBtn];
    
    return navView;
}

+ (UIButton *)gainBtn:(CGRect)frame title:(NSString *)title image:(NSString *)image
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.textColor = [UIColor whiteColor];
    
    if(image)
    {
        [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    else if(title)
    {
        UILabel *tlab = [[UILabel alloc] initWithFrame:CGRectZero];
        tlab.text = title;
        tlab.font = [UIFont systemFontOfSize:15.0f];
        [tlab sizeToFit];
        
        if(tlab.frame.size.width>frame.size.width)
        {
            
            CGFloat newW = tlab.frame.size.width + 8;
            CGFloat gap = newW - frame.size.width;
            frame.size.width = newW;
            if(frame.origin.x>SCREEN_WIDTH/2)      //说明是右边的按钮
            {
                frame.origin.x -= gap;
            }
        }
        if(tlab.frame.size.height>frame.size.height)
            frame.size.height = tlab.frame.size.height;
        
        [btn setTitle:title forState:UIControlStateNormal];
    }
    
    btn.frame = frame;
    
    return btn;
}


- (void)GoBackToController:(NSString *)controllerName
{
    id controll = nil;
    NSArray * ctrlArray = self.navigationController.viewControllers;
    for(UIViewController *vi in ctrlArray)
    {
        if([vi isKindOfClass:NSClassFromString(controllerName)])
        {
            controll = vi;
            break;
        }
    }
    if(controll!=nil)
    {
        [self.navigationController popToViewController:controll animated:YES];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)putAndBackToFirst:(NSString *)controllerName
{
    UIViewController *vc = [NSClassFromString(controllerName) new];
    if(!vc)
        return;
    
    NSMutableArray * ctrlArray = [self.navigationController.viewControllers mutableCopy];
    
    [ctrlArray insertObject:vc atIndex:0];
    self.navigationController.viewControllers = ctrlArray;
    [self.navigationController popToViewController:vc animated:YES];
}

@end
