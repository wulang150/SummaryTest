//
//  OtherViewController.m
//  SimpleTest
//
//  Created by  Tmac on 2017/11/30.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "OtherViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <libkern/OSAtomic.h>
#import <pthread.h>
#import "CommonBgView.h"

@implementation MyCal

- (void)gainMoney:(NSString *)name
{
    NSLog(@"cal money");
}

@end

@implementation MyModel

- (void)gainMoney:(NSString *)name
{
    NSLog(@"MyModel money");
}

- (void)show
{
    NSLog(@"show money");
}

+ (void)staticMethod
{
    NSLog(@"staticMethod");
}
/*
 比如：”v@:”意思就是这已是一个void类型的方法，没有参数传入。
 
 再比如 “i@:”就是说这是一个int类型的方法，没有参数传入。
 
 再再比如”i@:@”就是说这是一个int类型的方法，有一个参数传入。
 */
+ (BOOL)resolveInstanceMethod:(SEL)sel      //实现没实现的方法，有实现方法的话就不会走下面的方法了
{
//    if(sel==@selector(gainMoney:))
//    {
//        NSLog(@"haha");
//        class_addMethod(self, sel, (IMP)run, "v@:");
//        return YES;
//    }
    NSLog(@".........1...........");
    return [super resolveInstanceMethod:sel];
}

void run (id self,SEL _cmd)
{
    NSLog(@"%@ %s",self,sel_getName(_cmd));
}

//消息转发
- (id)forwardingTargetForSelector:(SEL)aSelector        //没有重新实现方法（要是正确的实现方法），就会调用这个
{
//    return [[MyCal alloc] init];
    NSLog(@".........2...........");
    return nil;
}

//另外一种消息转发，手动生成方法签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector //没正确指向方法，就调用这个
{
    NSLog(@".........3...........");
//    NSString *sel = NSStringFromSelector(aSelector);
//    if([sel isEqualToString:@"gainMoney:"])
//    {
//        //为转发方法手动生成签名
//        NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:"v@:@"];
//        return sig;
//    }
    //如果没有实现签名的话，这里返回的签名是nil，直接回报错
    return [super methodSignatureForSelector:aSelector];
}
//生成签名成功后，就会调用下面的方法 NSInvocation *invocation是通过NSMethodSignature得到的
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    NSLog(@".........4...........");
    NSString *str = @"";
    //参数
    [anInvocation getArgument:&str atIndex:2];
    NSLog(@"第一个参数：%@",str);
    //新建需要转发消息的对象
//    SEL selector = [anInvocation selector];
//    MyCal *car = [[MyCal alloc] init];
//    if([car respondsToSelector:selector])
//    {
//        //唤醒这个方法
//        [anInvocation invokeWithTarget:car];
//    }
}

@end

@interface OtherViewController()
{
    __weak id reference;
}
@end

@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavWithTitle:@"其他" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
//    @autoreleasepool {
//        NSString *str = [NSString stringWithFormat:@"asds"];//这里要写长点
//        reference = str;
//    }
//    NSString *str = [NSString stringWithFormat:@"asdsdfdsfdsfdsfdsfdsfdsfdsfdsfs"];//这里要写长点
//    reference = str;
    [self initData];
//    [self createView];
    
//    __weak __typeof(&*self)weakSelf = self;
    
//    [self aspect_hookSelector:@selector(saySomething:a:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
//
//        NSLog(@"%@ saySomething",aspectInfo.instance);
//    } error:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear->%@",reference);       //如果只有三个字符，这里还是有值的
}
- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear->%@",reference);
}

- (void)initData
{
//    [self testThread];
    
//    [self testChangeMessage];
    
//    [self performSelector:@selector(saySomething:) withObject:@"123"];
//    [self performSelector:@selector(saySomething:a:) withObject:@"t" withObject:@"p"];
    
//    [self testOther];
    
//    NSString *tmp = [self workStr:@"look at me"];
//    NSLog(@"~~~%@",tmp);
    
//    [self testAnchorPoint];
    
//    [self testLock];
    
//    [self testMsgChange];
    
//    [self testAnimate];
//    [self testTranscare];
//    [self testWeak];
    
//    [self testAutoauto];
    [self testAutorelease];
    
//    NSLog(@"2>>>>%@",reference);
}

- (void)testAutorelease
{
    NSString *myStr1 = [NSString stringWithFormat:@"assdfdsfdsfddd"];
    NSString *myStr2 = [NSString stringWithFormat:@"ass"];
    reference = myStr1;
    NSLog(@"str1=%p  str2=%p",myStr1,myStr2);
}
- (NSObject *)gainObj
{
    return [[NSObject alloc] init];
}

- (void)testAutoauto
{
    __weak id wsStr;
    {
        @autoreleasepool
        {
            //栈区
            int num = 10;
            //堆区
            NSString *myStr = [NSString stringWithFormat:@"asddsfsdfsdfdsfsdf"];
            //程序数据区
            NSString *myStr1 = @"asdsdfdsfdsfdsfdsfdsfdsfdsfdsfs";
            NSLog(@">>>>>>>>>%p %p  %p",myStr,myStr1,&num);
            reference = myStr;
            MyCal *cal = [[MyCal alloc] init];
            cal.name = @"car";
            reference = cal;
        }
        
        //堆区
//        NSString *myStr = [NSString stringWithFormat:@"asddsfsdfsdfdsfsdf"];
//        reference = myStr;
//        NSArray *arr = [[NSArray alloc] initWithArray:@[@"1111",@"2222"]];
//        NSArray *arr = [NSArray arrayWithArray:@[@"1111",@"2222"]];
//        reference = arr;
//
//        MyCal *cal = [[MyCal alloc] init];
////        MyCal *cal = [self gainCal];
////        __autoreleasing MyCal *cal = [[MyCal alloc] init];
//        cal.name = @"car";
//        wsStr = cal;
//        NSLog(@"%p   %@=%p",arr,[wsStr class],cal);
    }
    NSLog(@"1>>>>%@",reference);
//    MyCal *cal = (MyCal *)wsStr;
    NSLog(@"1>>>>>%@",[wsStr class]);
}

- (MyCal *)gainCal
{
    MyCal *tt = [[MyCal alloc] init];
    return tt;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"2>>>>%@",reference);
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"3>>>>>%@",reference);
}

- (void)saySomething:(NSString *)work a:(NSString *)a
{
    NSLog(@"%@ %@",work,a);
}

- (void)createView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.text = @"sdfdfdsf";
    lab.layer.borderWidth = 1;
    lab.center = CGPointMake(100, 200);
    lab.numberOfLines = 0;
    [self.view addSubview:lab];
}

- (void)testWeak
{
    NSString *str = @"123";
    __weak NSString *weakStr = str;
    NSLog(@"%p %p\n%p %p",&str,str,&weakStr,weakStr);
}

//测试缩放
- (void)testTranscare
{
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(30, 100, 100, 100)];
    subView.backgroundColor = [UIColor redColor];
    [self.view addSubview:subView];
    
    subView.transform = CGAffineTransformMakeScale(1.0, 0.5);
    NSLog(@"%f %f",subView.frame.size.width,subView.frame.size.height);
}

//动画测试
- (void)testAnimate
{
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 100, 100)];
    subView.backgroundColor = [UIColor redColor];
    [self.view addSubview:subView];
    
    //dampingRatio 弹簧的阻尼 如果为1动画则平稳减速动画没有振荡。 这里值为 0~1  摩擦力的大小
    //velocity 弹簧的速率。数值越小，动力越小，弹簧的拉伸幅度就越小。反之相反。比如：总共的动画运行距离是200 pt，你希望每秒 100pt 时，值为 0.5
//    [UIView animateWithDuration:2
//                          delay:2
//         usingSpringWithDamping:0.5
//          initialSpringVelocity:10
//                        options:UIViewAnimationOptionRepeat
//                     animations:^{
//                         subView.center = self.view.center;
//                     } completion:^(BOOL finished) {
//    }];
    
    //过度动画
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.view addSubview:view];
    view.center = self.view.center;
    view.backgroundColor = [UIColor redColor];
    UIView *view_1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    view_1.backgroundColor = [UIColor yellowColor];
    view_1.alpha = 0;
    [view addSubview:view_1];
    [UIView transitionWithView:view
                      duration:3
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
//                        [view addSubview:view_1];
                        view_1.alpha = 1;
                    } completion:^(BOOL finished) {
    }];
    
    
    
    
//    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    [self.view addSubview:baseView];
//    baseView.center = self.view.center;
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    [baseView addSubview:view];
//    view.backgroundColor = [UIColor redColor];
//    UIView *view_1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    view_1.backgroundColor = [UIColor yellowColor];
//    [UIView transitionFromView:view
//                        toView:view_1
//                      duration:2
//                       options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
//                       }];
}
//测试消息转发
- (void)testMsgChange
{
    MyModel *model = [[MyModel alloc] init];
//    [model aspect_hookSelector:@selector(gainMoney:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
//            NSLog(@"after gainMoney");
//    } error:nil];
    //好像不支持加方法的hook
//    [MyModel aspect_hookSelector:@selector(staticMethod) withOptions:AspectPositionAfter usingBlock:^(){
//        NSLog(@"after staticMethod");
//    } error:nil];
    //获得方法
    Method targetMethod = class_getInstanceMethod(model.class, @selector(gainMoney:));
    //获取原来方法参数
    const char *typeEncoding = method_getTypeEncoding(targetMethod);
    //重新指向方法，把方法直接指向forwardInvocation
    class_replaceMethod(model.class, @selector(gainMoney:), _objc_msgForward, typeEncoding);
    [model gainMoney:@"123"];


}
//测试Lock
- (void)testLock
{
    //OSSpinLockLock，默认值为 0,在 locked 状态时就会大于 0，unlocked状态下为 0
//    static OSSpinLock oslock = 0;
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"线程1 准备上锁");
//        OSSpinLockLock(&oslock);
//        NSLog(@"线程1......");
//        sleep(4);
//
//        OSSpinLockUnlock(&oslock);
//        NSLog(@"线程1 解锁成功");
//    });
//
//    //线程2
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"线程2 准备上锁");
//        OSSpinLockLock(&oslock);
//        NSLog(@"线程2......");
//        OSSpinLockUnlock(&oslock);
//        NSLog(@"线程2 解锁成功");
//    });
    
//   //dispatch_semaphore 信号量
//    dispatch_semaphore_t signal = dispatch_semaphore_create(1); //传入值必须 >=0, 若传入为0则阻塞线程并等待timeout,时间到后会执行其后的语句，值代表有多少个资源，就是可以让多少个线程同时使用
//    dispatch_time_t overTime = dispatch_time(DISPATCH_TIME_NOW, 3.0f * NSEC_PER_SEC);
//
//    //线程1
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"线程1 等待ing");
//        dispatch_semaphore_wait(signal, overTime); //signal 值 -1
//        NSLog(@"线程1");
//        sleep(2);
//        dispatch_semaphore_signal(signal); //signal 值 +1
//        NSLog(@"线程1 发送信号");
//        NSLog(@"--------------------------------------------------------");
//    });
//
//    //线程2
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"线程2 等待ing");
//        dispatch_semaphore_wait(signal, overTime);
//        NSLog(@"线程2");
//        dispatch_semaphore_signal(signal);
//        NSLog(@"线程2 发送信号");
//    });
    
//    //pthread_mutex 互斥锁
//    static pthread_mutex_t pLock;
//    pthread_mutex_init(&pLock, NULL);
//    //1.线程1
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"线程1 准备上锁");
//        pthread_mutex_lock(&pLock);
//        NSLog(@"线程1......");
//        sleep(3);
//        pthread_mutex_unlock(&pLock);
//        NSLog(@"线程1 解锁成功");
//    });
//
//    //1.线程2
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"线程2 准备上锁");
//        pthread_mutex_lock(&pLock);
//        NSLog(@"线程2......");
//        pthread_mutex_unlock(&pLock);
//        NSLog(@"线程2 解锁成功");
//    });
    
//    //递归锁允许同一个线程在未释放其拥有的锁时反复对该锁进行加锁操作，所谓递归锁，就是在同一线程上该锁是可重入的，对于不同线程则相当于普通的互斥锁
//    //pthread_mutex(recursive)
//    static pthread_mutex_t pLock;
//    pthread_mutexattr_t attr;
//    pthread_mutexattr_init(&attr); //初始化attr并且给它赋予默认
//    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE); //设置锁类型，这边是设置为递归锁
//    pthread_mutex_init(&pLock, &attr);
//    pthread_mutexattr_destroy(&attr); //销毁一个属性对象，在重新进行初始化之前该结构不能重新使用
//
//    //1.线程1
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        static void (^RecursiveBlock)(int);
//        RecursiveBlock = ^(int value) {
//            pthread_mutex_lock(&pLock);
//            if (value > 0) {
//                NSLog(@"value: %d", value);
//                RecursiveBlock(value - 1);
//            }
//            pthread_mutex_unlock(&pLock);
//        };
//        RecursiveBlock(5);
//    });
    
    //另一种递归锁
//    NSRecursiveLock *rLock = [NSRecursiveLock new];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        static void (^RecursiveBlock)(int);
//        RecursiveBlock = ^(int value) {
//            [rLock lock];
//            if (value > 0) {
//                NSLog(@"线程%d", value);
//                sleep(1);
//                RecursiveBlock(value - 1);
//            }
//            [rLock unlock];
//        };
//        RecursiveBlock(4);
//    });
//    //在不同线程是互斥
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"线程n外部等待..");
//        [rLock lock];
//        NSLog(@"线程n..");
//        [rLock unlock];
//        NSLog(@"线程n完成");
//    });
    
    
//    //条件锁，可控制线程间的依赖，下面是线程1-->线程3-->线程2
    NSConditionLock *cLock = [[NSConditionLock alloc] initWithCondition:0];

    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([cLock tryLockWhenCondition:0]){
            NSLog(@"线程1");
            [cLock unlockWithCondition:1];
        }else{
            NSLog(@"失败");
        }
    });

    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lockWhenCondition:3];
        NSLog(@"线程2...");
        [cLock unlockWithCondition:2];
    });

    //线程3
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lockWhenCondition:1];
        NSLog(@"线程3...");
        [cLock unlockWithCondition:3];
    });
    
}

//anchorPoint与position
- (void)testAnchorPoint
{
    CAShapeLayer *grad3 = [CAShapeLayer layer];
    
    grad3.frame = CGRectMake(20, 260, 10, 100);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:grad3.bounds];
    grad3.path = path.CGPath;
    //加入动画
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 0.5;
    animation.delegate= nil;
    animation.fromValue = [NSNumber numberWithFloat:0.1];
    animation.toValue = [NSNumber numberWithFloat:1];
    [grad3 addAnimation:animation forKey:@"transform.scale.y"];
    
    //默认是由中点向两边延伸，前面说过，改变动画的初始位置，是改变anchorPoint值，比如我想改为由底部向上延伸
//    [grad3 setAnchorPoint:CGPointMake(0.5, 1)];
//    [grad3 setPosition:CGPointMake(grad3.position.x, 260)];
    
    [self.view.layer addSublayer:grad3];
    
    //多加一个对比的点
    UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    pointView.center = CGPointMake(40, 260);
    pointView.layer.cornerRadius = 5;
    pointView.backgroundColor = [UIColor redColor];
    [self.view addSubview:pointView];
}

//测试消息转发
- (void)testChangeMessage
{
    MyModel *my = [[MyModel alloc] init];
    [my gainMoney:@"123"];
}

- (void)testThread
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"main");
        });
    });
    
    NSLog(@"sub");
}

- (void)testOther
{
    NSString *mydfd = @"ssfdsfdsfdsf";
    NSString *tmp = [mydfd copy];
    
    NSLog(@"f=%p  l=%p",&mydfd,mydfd);
    
    int a = 20;
    NSLog(@"f1=%d  l1=%p",a,a);
}

- (NSString *)workStr:(NSString *)str
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    str = [str lowercaseString];
    for(int i=0;i<str.length;i++)
    {
        char s = [str characterAtIndex:i];
        if(s>='a'&&s<='z')
        {
            NSString *key = [NSString stringWithFormat:@"%c",s];
            int num = [[dic objectForKey:key] intValue];
            num++;
            [dic setObject:@(num) forKey:key];
        }
    }
    NSMutableArray *keyArr = [[dic allKeys] mutableCopy];
    for(int i=0;i<keyArr.count-1;i++)
    {
        for(int j=i+1;j<keyArr.count;j++)
        {
            NSString *key1 = keyArr[i];
            NSString *key2 = keyArr[j];
            int num1 = [[dic objectForKey:key1] intValue];
            int num2 = [[dic objectForKey:key2] intValue];
            if(num1<num2)
            {
                [keyArr replaceObjectAtIndex:i withObject:key2];
                [keyArr replaceObjectAtIndex:j withObject:key1];
            }
            if(num2==num1)
            {
                char s1 = [key1 characterAtIndex:0];
                char s2 = [key2 characterAtIndex:0];
                if(s1<s2)
                {
                    [keyArr replaceObjectAtIndex:i withObject:key2];
                    [keyArr replaceObjectAtIndex:j withObject:key1];
                }
            }
        }
    }
    return [keyArr componentsJoinedByString:@""];
}


@end
