//
//  TestViewController.m
//  SummaryTest
//
//  Created by  Tmac on 2017/12/1.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "TestViewController.h"
#import "TestView.h"
#import "TestBView.h"
#import "myButton.h"
#import "TestView1.h"
#import "TestView2.h"

/*
 事件产生和传递
 1、系统会将该事件加入到一个由UIApplication管理的事件队列中
 2、UIApplication会从事件队列中取出最前面的事件，先发送事件给应用程序的主窗口（keyWindow）
 3、主窗口会在视图层次结构中找到一个最合适的视图来处理触摸事件，触摸事件的传递是从父控件传递到子控件(采取从后往前遍历子控件的方式)，也就是UIApplication->window->寻找处理事件最合适的view
 4、产生触摸事件->UIApplication事件队列->[UIWindow hitTest:withEvent:]->返回更合适的view->[子控件 hitTest:withEvent:]->返回最合适的view
 
 响应事件
 如果找到最适合的view后，发现view没有重写touch事件，默认是不处理的，就交给上一级处理，不断往父类传事件处理，如果最后window和UIApplication也不处理，就丢弃
 */

@interface TestViewController ()
<UIGestureRecognizerDelegate>

@end

@implementation TestViewController

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
    [self setNavWithTitle:@"消息传递测试" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
    [self test3];
}

- (void)test3
{
    TestView1 *view1 = [[TestView1 alloc] initWithFrame:CGRectMake(100, NavigationBar_HEIGHT+30, 100, 100)];
    
    TestView2 *view2 = [[TestView2 alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(view1.frame)+20, 100, 100)];

    [self.view addSubview:view1];
    [self.view addSubview:view2];
}

- (void)test2
{
    //这里，我想测试，点击BView，让myView去响应这个事件
    TestView *myView = [[TestView alloc] initWithFrame:CGRectMake(100, NavigationBar_HEIGHT+30, 100, 100)];
    myView.backgroundColor = [UIColor redColor];
    
    TestBView *bView = [[TestBView alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(myView.frame)+20, 100, 100)];
    bView.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:bView];
    [self.view addSubview:myView];
}

- (void)test1
{
    TestView *myView = [[TestView alloc] initWithFrame:CGRectMake(100, NavigationBar_HEIGHT+30, 100, 100)];
    myView.backgroundColor = [UIColor redColor];
    [self.view addSubview:myView];
    
    TestBView *bView = [[TestBView alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(myView.frame)+20, 100, 100)];
    bView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:bView];
    
    //像btn这些系统控件，把触摸事件识别成自己的手势，然后就自己响应了，不在留到父类响应
    //    myButton *btn = [myButton buttonWithType:UIButtonTypeSystem];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(100, CGRectGetMaxY(bView.frame)+20, 100, 32);
    [btn setTitle:@"按钮" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //    [self.view bringSubviewToFront:bView];
    
    //在touch传递的时候，手势就捕获和识别处理了，所以点击子view，此view也能识别处理
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    tap.delegate = self;
    //    tap.delaysTouchesBegan = YES;   //此慢点再让view响应touch begin
    //    tap.delaysTouchesEnded = NO;    //此慢点再让view响应touch end
//    tap.cancelsTouchesInView = NO;   //来设置手势被识别后触摸事件是否被传送到视图
    [btn addGestureRecognizer:tap];
    //    [self.view addGestureRecognizer:tap];
    //当触摸对象被手势识别后，所有的touch系统响应都会被取消，如果都不delay，就有可以能在触摸对象没被手势识别前进行一些响应
    
    //按正常逻辑，包括上网查的13年的问题，父级view的tap应该可以拦截btn需要的touch事件，感觉现在的被改了，默认，tap.cancelsTouchesInView = YES，就是识别后取消触摸事件.可能btn权利大了，你tap想拦我，那我就不让你活，导致tap无法响应，如果tap.cancelsTouchesInView = NO，tap原意分享触摸事件我，那我就可以让你活，所有tap可以响应了。（只有这里特殊，也是这样处理才合理）
    //在btn上加tap事件，系统没做特殊处理，还是tap权限大点
    //同一个view上的btn和tap事件，btn权限大，其他情况都是tap权限大
    
    //    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1)];
    //    tap1.numberOfTapsRequired = 1;
    //    tap1.numberOfTouchesRequired = 1;
    //    [bView addGestureRecognizer:tap1];
}

- (void)tap
{
    NSLog(@"%s",__FUNCTION__);
}


- (void)btnAction:(UIButton *)sender
{
    NSLog(@"%s",__FUNCTION__);
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    if ([touch.view isKindOfClass:[UIButton class]]) {
//        return NO;      //让tap不接收点击在btn上的touch事件，这样btn点击就可以有效，tap无效
//    }
//    return YES;
//}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__FUNCTION__);
}

@end
