//
//  BaseController.h
//  SummaryTest
//
//  Created by  Tmac on 2017/6/29.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseController : UIViewController <UINavigationControllerDelegate>

//正常情况
@property(nonatomic,strong) UIButton *NavleftBtn;       //tag 700
@property(nonatomic,strong) UIButton *NavrightBtn;      //tag 702
@property(nonatomic,strong) UILabel *NavtitleLab;       //tag 701

//没有的就传nil
- (UIView *)setNavWithTitle:(NSString *)title
              leftImage:(NSString *)leftImage
              leftTitle:(NSString *)leftTitle
             leftAction:(SEL)leftAction
             rightImage:(NSString *)rightImage
             rightTitle:(NSString *)rightTitle
            rightAction:(SEL)rightAction;

//定义加方法，方便没有继承这个类的使用
+ (UIView *)comNavWithTitle:(NSString *)title
                  leftImage:(NSString *)leftImage
                  leftTitle:(NSString *)leftTitle
                 leftAction:(SEL)leftAction
                 rightImage:(NSString *)rightImage
                 rightTitle:(NSString *)rightTitle
                rightAction:(SEL)rightAction
                   itemSelf:(id)itemSelf;


//返回对应的界面
- (void)GoBackToController:(NSString *)controllerName;

//把某个controller作为导航的第一个，并且返回到这个控制器
- (void)putAndBackToFirst:(NSString *)controllerName;


@end
