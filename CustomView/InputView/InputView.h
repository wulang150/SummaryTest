//
//  InputView.h
//  Runner
//
//  Created by  Tmac on 16/8/31.
//  Copyright © 2016年 Janson. All rights reserved.
//

#import <UIKit/UIKit.h>
//输入的内容格式
enum{
    INPUT_PHONE = 1<<0,        //手机号码
    INPUT_HOMENUMBER = 1<<1,       //电话号码
    INPUT_EMAIL = 1<<2,
    INPUT_WECHAT = 1<<3,
    INPUT_QQ = 1<<4,
    INPUT_WEIBO = 1<<5,
    INPUT_URL = 1<<6,
    INPUT_CONTENT = 1<<7,           //用户说说的评论
    INPUT_SPECIALCHAR = 1<<8        //特殊字符
};

@interface InputView : UIView
//输入框，可以自己控制
@property(nonatomic,strong) UITextView *textField;
//最大字数控制
@property(nonatomic,assign) int maxNum;
//对格式的控制
@property(nonatomic,assign) int inputFormat;
//是否支持输入表情
@property(nonatomic,assign) BOOL isAllowEmotion;

//str==nil，就是格式错误
@property(nonatomic,strong) void(^callBack)(NSString *str);
//height 弹出框的高度,用于想自己控制输入框上移，height==0 为键盘消失
@property(nonatomic,strong) void(^callBackWithHeight)(NSString *str,CGFloat height);

- (id)initWithStr:(NSString *)value;
/*
 value 初始化的值
 subView 可能被遮挡的控件
 superView 此控件所在最前的父类
 */
- (id)initWithStr:(NSString *)value subView:(UIView *)subView superView:(UIView *)superView;
- (void)show;


@end
