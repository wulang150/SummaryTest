//
//  SimpleAlertView.h
//  Runner
//
//  Created by  Tmac on 16/2/29.
//  Copyright © 2016年 Janson. All rights reserved.
//

/*
 使用例子
 
 UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 100)];
 UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 30, 280-20, 40)];
 textView.text = @"起床闹钟";
 textView.layer.borderWidth = 1;
 [myView addSubview:textView];
 
 //    SimpleAlertView *alert = [[SimpleAlertView alloc] initAlertView:@"铃声命名" content:@"请输入你的选择内容!" vi:myView];
 
 SimpleAlertView *alert = [[SimpleAlertView alloc] initAlertView:@"提前说" content:@"" vi:myView btnTilte:@[@"确定",@"取消"]];
 alert.callBack = ^(NSString *ret,int index){
 
    NSLog(@"~~~~~~%d",index);
 };
 
 [alert show];
 */

#import <UIKit/UIKit.h>

@interface SimpleAlertView : UIView
//strRet暂时没用  index：如果是两个按钮，左边按钮返回1，右边按钮返回2
@property (nonatomic,strong) void(^callBack)(NSString *strRet,int index);
//弹出框view
@property (nonatomic,strong) UIView *mainView;
//设置宽度，默认是280
@property (nonatomic,assign) int alertW;

//title:提示框标题   content:文字内容    vi：中间的view，没用到时候需传nil，弹出框的默认宽度为280，定义view可以参考这个
//btnTitle:自定义按钮标题，最多只有两个按钮
- (id)initAlertView:(NSString *)title content:(NSString *)content vi:(UIView *)vi btnTilte:(NSArray *)btnTitle;

- (void)show;

@end
