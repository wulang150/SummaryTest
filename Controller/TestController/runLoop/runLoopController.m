//
//  runLoopController.m
//  SummaryTest
//
//  Created by  Tmac on 2017/12/12.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "runLoopController.h"


@interface runLoopController ()
{
    CFRunLoopSourceRef runloopSource;
    NSRunLoop* myRunLoop;
}
@end

@implementation runLoopController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavWithTitle:@"runLoop" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(100, 80, 100, 30);
    [btn setTitle:@"点击" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    // Do any additional setup after loading the view.
    //在一个线程中开启runloop
    [NSThread detachNewThreadSelector:@selector(newThreadProcess)
     
                             toTarget: self
     
                           withObject: nil];
    
    //为主线程添加观察者
    //    myRunLoop = [NSRunLoop currentRunLoop];
    //    CFRunLoopObserverContext context = {0,(__bridge void *)(self),NULL,NULL,NULL};
    //    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,kCFRunLoopBeforeWaiting, YES, 0, &myRunLoopObserver, &context);
    //
    //    if(observer)
    //
    //    {
    //
    //        //将Cocoa的NSRunLoop类型转换成CoreFoundation的CFRunLoopRef类型
    //
    //        CFRunLoopRef cfRunLoop = [myRunLoop getCFRunLoop];
    //
    //
    //
    //        //将新建的observer加入到当前thread的runloop
    //
    //        CFRunLoopAddObserver(cfRunLoop, observer, kCFRunLoopDefaultMode);
    //
    //    }
    //
    //    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval: 3
    //
    //                                         target: self
    //
    //                                       selector:@selector(timerProcess)
    //
    //                                       userInfo: nil
    //
    //                                        repeats: YES];
    //    
    //    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)newThreadProcess
{
    
//    [self performSelectorOnMainThread:@selector(timerProcess) withObject:nil waitUntilDone:NO];
//    [self performSelector:@selector(timerProcess) withObject:nil];
    [self performSelector:@selector(timerProcess) withObject:nil afterDelay:2]; //有延迟的操作，内部是会创建定时器的，所以如果没有runLoop，那么就会无效。像上面两个直接执行的，不需要runLoop
    
    @autoreleasepool {
        
        ////获得当前thread的Runloop
        
        myRunLoop = [NSRunLoop currentRunLoop];
        
        //设置Run loop observer的运行环境
        
        CFRunLoopObserverContext context = {0,(__bridge void *)(self),NULL,NULL,NULL};
        
        //创建Run loop observer对象
        
        //第一个参数用于分配observer对象的内存
        
        //第二个参数用以设置observer所要关注的事件，详见回调函数myRunLoopObserver中注释
        
        //第三个参数用于标识该observer是在第一次进入runloop时执行还是每次进入run loop处理时均执行
        
        //第四个参数用于设置该observer的优先级
        
        //第五个参数用于设置该observer的回调函数
        
        //第六个参数用于设置该observer的运行环境
        
        CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,kCFRunLoopAllActivities, YES, 0, &myRunLoopObserver, &context);
        
        if(observer)
        {
            
            //将Cocoa的NSRunLoop类型转换成CoreFoundation的CFRunLoopRef类型
            CFRunLoopRef cfRunLoop = [myRunLoop getCFRunLoop];
            //将新建的observer（观察者）加入到当前thread的runloop
            CFRunLoopAddObserver(cfRunLoop, observer, kCFRunLoopDefaultMode);
            
        }
        
        //加入输入事件源
        CFRunLoopSourceContext src_context;
        src_context.version = 0;
        src_context.retain = NULL;
        src_context.release = NULL;
        src_context.copyDescription = NULL;
        src_context.equal = NULL;
        src_context.hash = NULL;
        src_context.schedule = NULL;
        src_context.cancel = NULL;
        src_context.perform = &callback ;//设置唤醒是调用的回调函数
        runloopSource = CFRunLoopSourceCreate (NULL, 0, &src_context);
//
        CFRunLoopAddSource ([myRunLoop getCFRunLoop],
                            runloopSource,
                            kCFRunLoopCommonModes);
        //加入时钟事件源
        
//        [NSTimer scheduledTimerWithTimeInterval:2
//         
//                                         target: self
//         
//                                       selector:@selector(timerProcess)
//         
//                                       userInfo: nil
//         
//                                        repeats: NO];
        
        NSInteger loopCount = 3;
        
        do{
            //runloop，发现没有需要监听的事件时候就会退出，比如只有时钟事件，并且不是循环的，那么它监听完时钟事件之后就会退出，就算在外层加了循环处理，再次执行到CFRunLoopRun也不会进入监听等待，直接就返回。如果时钟是循环的，那么CFRunLoopRun能一直接听，监听完一次，不会返回，是直接返回到监听等待状态。
            //如果加入超时的，时间到了，会直接返回
            /*
             对于输入源的处理
             2017-12-12 11:07:47.663491+0800 SummaryTest[6268:3849419] run loop before waiting
             2017-12-12 11:07:57.463172+0800 SummaryTest[6268:3849419] run loop after waiting
             2017-12-12 11:07:57.463365+0800 SummaryTest[6268:3849419] run loop before timers
             2017-12-12 11:07:57.463446+0800 SummaryTest[6268:3849419] run loop before sources
             2017-12-12 11:07:57.463660+0800 SummaryTest[6268:3849419] ~~~~~mysource
             2017-12-12 11:07:57.463748+0800 SummaryTest[6268:3849419] run loop before timers
             2017-12-12 11:07:57.463818+0800 SummaryTest[6268:3849419] run loop before sources
             2017-12-12 11:07:57.463888+0800 SummaryTest[6268:3849419] run loop before waiting
             可以看到，在等待状态时候，如果触发了输入源事件，立刻重新遍历一遍，从timers到sources，发现是输入事件源，就直接处理，然后就又重新遍历直到waiting。
             */
            
            //启动当前thread的loop直到所指定的时间到达，在loop运行时，runloop会处理所有来自与该run loop联系的inputsource的数据
            
            //对于本例与当前run loop联系的inputsource只有一个Timer类型的source。
            
            //该Timer每隔1秒发送触发事件给runloop，run loop检测到该事件时会调用相应的处理方法。
            
            //当调用runUnitDate方法时，observer检测到runloop启动并进入循环，observer会调用其回调函数，第二个参数所传递的行为是kCFRunLoopEntry。
            
            //observer检测到runloop的其它行为并调用回调函数的操作与上面的描述相类似。
            
//            [myRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5.0]];
//            [myRunLoop run];
            CFRunLoopRun();
//            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 4, NO);
            NSLog(@"~~~~%ld",loopCount);
            loopCount--;
            
        }while (loopCount);
        
    }
    
}
//观察回调
void myRunLoopObserver(CFRunLoopObserverRef observer,CFRunLoopActivity activity,void *info)
{
    
    switch (activity) {
            
            //The entrance of the run loop, beforeentering the event processing loop.
            
            //This activity occurs once for each callto CFRunLoopRun and CFRunLoopRunInMode
            
        case kCFRunLoopEntry:
            
            NSLog(@"run loop entry");
            
            break;
            
            //Inside the event processing loop beforeany timers are processed
            
        case kCFRunLoopBeforeTimers:
            
            NSLog(@"run loop before timers");
            
            break;
            
            //Inside the event processing loop beforeany sources are processed
            
        case kCFRunLoopBeforeSources:
            
            NSLog(@"run loop before sources");
            
            break;
            
            //Inside the event processing loop beforethe run loop sleeps, waiting for a source or timer to fire.
            
            //This activity does not occur ifCFRunLoopRunInMode is called with a timeout of 0 seconds.
            
            //It also does not occur in a particulariteration of the event processing loop if a version 0 source fires
            
        case kCFRunLoopBeforeWaiting:
            
            NSLog(@"run loop before waiting");
            
            break;
            
            //Inside the event processing loop afterthe run loop wakes up, but before processing the event that woke it up.
            
            //This activity occurs only if the run loopdid in fact go to sleep during the current loop
            
        case kCFRunLoopAfterWaiting:
            
            NSLog(@"run loop after waiting");
            
            break;
            
            //The exit of the run loop, after exitingthe event processing loop.
            
            //This activity occurs once for each callto CFRunLoopRun and CFRunLoopRunInMode
            
        case kCFRunLoopExit:
            
            NSLog(@"run loop exit");
            
            break;
            
            /*
             
             A combination of all the precedingstages
             
             case kCFRunLoopAllActivities:
             
             break;
             
             */
            
        default:
            
            break;
    }
}

void callback()
{
    NSLog(@"~~~~~mysource");
}

CFDataRef PortCallBack(CFMessagePortRef local, SInt32 msgid, CFDataRef data, void *info)
{
    
    NSData *my_nsdata = (__bridge_transfer NSData*)data;
    char *str = (char *)[my_nsdata bytes];
    
    NSLog(@"~~~~~~~~PortCallBack=%s",str);
    return data;
}


- (void)timerProcess{
    
    
    NSLog(@"In timerProcess count = %d. thread=%@", 10,[NSThread currentThread]);
    
    //    for (int i=0; i<5; i++) {
    //
    //        NSLog(@"In timerProcess count = %d.", i);
    //        
    //        sleep(1);
    //        
    //    }
    
}

- (void)btnAction:(UIButton *)sender
{
    CFRunLoopSourceSignal(runloopSource);
    CFRunLoopWakeUp([myRunLoop getCFRunLoop]);
    
    //CFRunLoopStop([myRunLoop getCFRunLoop]);
    
    //    CFMessagePortRef bRemote = CFMessagePortCreateRemote(kCFAllocatorDefault, CFSTR(PORT));
    //    // tell thread b to print his name
    //    char message[255]="lingdaiping,yohunl";
    //    CFDataRef data;
    //    data = CFDataCreate(NULL, (UInt8 *)message, strlen(message)+1);
    //    (void)CFMessagePortSendRequest(bRemote, CFSTR(PORT), data, 0.0, 0.0, NULL, NULL);
    //    CFRelease(data);
    //    CFRelease(bRemote);
}


@end
