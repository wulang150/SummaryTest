//
//  SimpleViewController.m
//  SummaryTest
//
//  Created by  Tmac on 2018/1/30.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "SimpleViewController.h"
#import "UIView+Extension.h"
#import "UIView+LayoutMethods.h"
#import "SubView.h"
#import "SubLabel.h"
#import "SubLayer.h"
#import "UIImage+YYAdd.h"
#import "SDWebImageDecoder.h"
#import "YYFPSLabel.h"
#include <mach/mach_host.h>
#import <mach-o/ldsyms.h>

@implementation Student

//@synthesize name = _name;
//- (void)setName:(NSString *)name
//{
//    _name = name;
//}
//- (NSString *)name
//{
//    return _name;
//}
// 手动设定KVO，对应实例变量（非属性变量），必须添加willChangeValueForKey和didChangeValueForKey方法
//- (void)setAge:(NSString *)age
//{
//    [self willChangeValueForKey:@"age"];
//    _age = age;
//    [self didChangeValueForKey:@"age"];
//}
//- (NSString *)age
//{
//    return _age;
//}
//+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
//{
//    // 如果监测到键值为age，则指定为非自动监听对象，就要用户去添加willChangeValueForKey和didChangeValueForKey
//    if ([key isEqualToString:@"age"])
//    {
//        return NO;
//    }
//
//    return [super automaticallyNotifiesObserversForKey:key];
//}

@end

@interface SimpleViewController ()
<UITextFieldDelegate,CALayerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIView *superView;
    UIView *view1;
    UIView *_redView;
    NSArray *_array;
    dispatch_queue_t _serialQueue;
    dispatch_queue_t _concurrentQueue;
    
    NSMutableArray *mulArr;
}

@property (nonatomic, strong) Student *student;
@end

@implementation SimpleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavWithTitle:@"简单测试" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    _serialQueue = dispatch_queue_create("myname", DISPATCH_QUEUE_SERIAL);
    _concurrentQueue = dispatch_queue_create("hello", DISPATCH_QUEUE_CONCURRENT);
    mulArr = [[NSMutableArray alloc] init];
    
//    [self drawCircleView];
//    [self testKVC];
    
//    [self testLine];
    
//    [self myTest1];
    
//    [self testMyLayoutView];
    
//    [self testFrameAndBounds];
    
//    [self testMyTextView];
    
//    [self testAutoFit];
    
//    [self testBlock];
    
//    [self testViewAndCALayer];
    
    
//    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(100, 100, 200, 100)];
//    textView.text = @"sdfdsfdsf";
//    textView.textAlignment = NSTextAlignmentCenter;
//    textView.layer.borderWidth = 1;
//    [self.view addSubview:textView];
//
//    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, textView.bottom+20, 200, 100)];
//    textField.text = @"sdfdsfdsf";
//    textField.layer.borderWidth = 1;
//    textField.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:textField];
    
//    [self testDraw];
//    [self testDrawLayer];
//    [self testRender];
    
//    [self testThread];
    
//    NSString *str = @"w";
//    str = [str substringWithRange:NSMakeRange(0, 3)];
//    NSLog(@">>>>>>>%@",str);
    
//    [self testImage];
    
//    [self testTableView];
//    [self testSync];
    
//    [self testDispatch];
//    [self testBug];
//    [self getCPUType];
    
//    [self textcuccct];
    [self testDispatchLine];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    superView.width += 20;
//    view1.width += 20;
//    [superView setNeedsLayout];
    //在这里打断点，view1的frame是有值的
//    [view1 mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(50);
//    }];
    
    
    //测试frame和bounds，bounds.y增加10，子控件上向上移动的10
    CGRect bounds = _redView.bounds;
    //将redView的bounds的y坐标增加10
    bounds.origin.y += 10;
    bounds.origin.x += 10;
    _redView.bounds = bounds;
    NSLog(@"%lf",_redView.bounds.origin.y);

}

- (void)testDispatchLine
{
    dispatch_async(_serialQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@">>>>>>1");
    });
    dispatch_async(_serialQueue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@">>>>>>2");
    });
    dispatch_barrier_async(_serialQueue, ^{
        NSLog(@">>>>>>>3");
    });
}

- (void)textcuccct
{
    //证明非线程安全的
    static int count = 0;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (1) {
            [mulArr addObject:[NSString stringWithFormat:@"%d",count++]];
            if(count>10000)
                break;
        }
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        while (1) {
            if(mulArr.count>0)
            {
                NSString *str = [mulArr firstObject];
                NSLog(@"%@",str);
                [mulArr removeObject:str];
            }
        }
    });
}

- (NSString *)executableUUID
{
    const uint8_t *command = (const uint8_t *)(&_mh_execute_header + 1);
    for (uint32_t idx = 0; idx < _mh_execute_header.ncmds; ++idx) {
        if (((const struct load_command *)command)->cmd == LC_UUID) {
            command += sizeof(struct load_command);
            return [NSString stringWithFormat:@"%02X%02X%02X%02X-%02X%02X-%02X%02X-%02X%02X-%02X%02X%02X%02X%02X%02X",
                    command[0], command[1], command[2], command[3],
                    command[4], command[5],
                    command[6], command[7],
                    command[8], command[9],
                    command[10], command[11], command[12], command[13], command[14], command[15]];
        } else {
            command += ((const struct load_command *)command)->cmdsize;
        }
    }
    return nil;
}


- (void)getCPUType{
    host_basic_info_data_t hostInfo;
    mach_msg_type_number_t infoCount;
    
    infoCount = HOST_BASIC_INFO_COUNT;
    host_info(mach_host_self(), HOST_BASIC_INFO, (host_info_t)&hostInfo, &infoCount);
    
    switch (hostInfo.cpu_type) {
        case CPU_TYPE_ARM:
            NSLog(@"CPU_TYPE_ARM");
            break;
            
        case CPU_TYPE_ARM64:
            NSLog(@"CPU_TYPE_ARM64");
            break;
            
        case CPU_TYPE_X86:
            NSLog(@"CPU_TYPE_X86");
            break;
            
        case CPU_TYPE_X86_64:
            NSLog(@"CPU_TYPE_X86_64");
            break;
            
        default:
            break;
    }
    
    NSLog(@"uuid = %@",[self executableUUID]);
}
//测试崩溃
- (void)testBug
{
    NSArray *arr = @[@"1"];
    
    NSLog(@"%@",arr[1]);
}

- (void)testDispatch
{
    dispatch_queue_t serialQueue = dispatch_queue_create("seriorQueue", DISPATCH_QUEUE_SERIAL);
    NSArray *arr = @[@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p",@"a",@"s",@"d",@"f"];
    dispatch_apply(arr.count, serialQueue, ^(size_t i) {
        
        NSLog(@">>>>val=%@",arr[i]);
    });
    
    NSLog(@">>>>>>>end");
}

- (void)testSync
{
    for(NSInteger i = 0;i<3;i++)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self testThreed1:i];
        });
//        [self testThreed1:i];
    }
    
    NSLog(@">>>>>>>>end all");
    
//    [self testThreed1:0];
//    [self deadLock];
}

- (void)deadLock
{
    //来个死锁的
    NSLog(@">>>>>>>>>start");
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@">>>>>>>>>>in");
    });
    NSLog(@">>>>>>>>>>end");
}

- (void)testThreed1:(NSInteger)tag
{
    //所有可以得出结论，同步或异步只是决定是否等待当前任务完成（不是队列的所有任务），串行和并发队列决定是一个任务一个任务地执行，还是并发一块执行。队列决定每个任务的出列方式，对于每一个出列的任务，再分配是异步还是同步，同步内部与父线程一致。
    //对于同步串行队列，这里等待的是当前任务的完成，而不是队列里所有任务完成
//    NSLog(@">>>>>>>>>threed%zi start",tag);
//    dispatch_async(_serialQueue, ^{
//
//        NSLog(@">>>>>>>>>threed%zi ining isMain=%d",tag,[NSThread currentThread].isMainThread);
//        sleep(3);
//    });
//
//    NSLog(@">>>>>>>>>threed%zi end",tag);
    
    //同步并发队列，这里等待的是当前任务的完成，而不是队列里所有任务完成
    NSLog(@">>>>>>>>>threed%zi start",tag);
    dispatch_sync(_concurrentQueue, ^{
        NSLog(@">>>>>>>>>threed%zi ining",tag);
        sleep(2);
    });

    NSLog(@">>>>>>>>>threed%zi end",tag);
}

- (void)testTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationBar_HEIGHT)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    
    //加入fps测试工具
    YYFPSLabel *FpsLab = [[YYFPSLabel alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT-60, 0, 0)];
    [self.view addSubview:FpsLab];
}

//测试图片解码的耗时
- (void)testImage
{
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 80, SCREEN_WIDTH-20, SCREEN_HEIGHT-160)];
    imageView1.layer.borderWidth = 1;
    [self.view addSubview:imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH-40, SCREEN_HEIGHT-200)];
    imageView2.layer.borderWidth = 1;
    [self.view addSubview:imageView2];
    
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(40, 120, SCREEN_WIDTH-80, SCREEN_HEIGHT-240)];
    imageView3.layer.borderWidth = 1;
    [self.view addSubview:imageView3];
    
//    UIImage *image1 = [UIImage imageNamed:@"Start"];
//    imageView1.image = image1;
//
//    UIImage *image2 = [UIImage imageNamed:@"Start"];
//    imageView2.image = image2;
//
    UIImage *image3 = [UIImage imageNamed:@"Start"];
    imageView3.image = image3;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Start" ofType:@"png"];
    UIImage *image2 = [UIImage imageWithContentsOfFile:path];
    imageView2.image = image2;
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"Start" ofType:@"png"];
//        UIImage *image1 = [UIImage imageWithContentsOfFile:path];
//        image1 = [UIImage decodedImageWithImage:image1];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            imageView1.image = image1;
//        });
//
//    });
}

//测试线程
- (void)testThread
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(1);
        NSLog(@"goning....");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"in main....");
            sleep(1);
            NSLog(@"out main....");
        });
        
        NSLog(@"out...");
    });
}

//离屏渲染
- (void)testRender
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 70, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    view.layer.cornerRadius = 50;
    [self.view addSubview:view];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(view.right+20, view.centerY, 100, 30)];
    lab.layer.borderWidth = 1;
    [self.view addSubview:lab];
    
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, view.bottom+10, 80, 80)];

    UIImage *myImage = [UIImage imageNamed:@"myimage"];
    imageView1.image = myImage;
    [self.view addSubview:imageView1];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //只有极少数的UI能直接进行UI更新，因为开辟线程时会获取当前环境，如点击某个按钮，这个按钮响应的方法是开辟一个子线程，在子线程中对该按钮进行UI 更新是能及时的
        //我们看到的UI更新其实是子线程代码执行完毕了，又自动进入到了主线程，执行了子线程中的UI更新的函数栈
        //如果先执行了sleep，当前函数testRender已经执行完了，所有UI的更新会慢点
        sleep(1);
        imageView1.layer.cornerRadius = 20;
        imageView1.clipsToBounds = YES;
        
        lab.text = @"hello";
        //在异步线程中处理圆角
//        UIImage *myImage = [UIImage imageNamed:@"myimage"];
//        myImage = [myImage imageByRoundCornerRadius:40];
//        myImage = [myImage imageByRotateLeft90];

//        imageView1.image = [myImage imageByRoundCornerRadius:40];
        
//        sleep(3);
    });
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, imageView1.bottom+10, 80, 80)];
//    imageView2.layer.cornerRadius = 40;
    imageView2.image = [UIImage imageNamed:@"myimage"];
//    imageView2.clipsToBounds = YES;
    [self.view addSubview:imageView2];
}

//layer
- (void)testDrawLayer
{

//    CALayer *layer  = [CALayer layer];
//    layer.bounds    = CGRectMake(0, 0, 100, 100);
//    layer.position  = CGPointMake(100, 100);
//    layer.delegate  = self;
//    [layer setNeedsDisplay];
//    [self.view.layer addSublayer:layer];
    
    SubLayer *layer = [SubLayer layer];
    layer.bounds    = CGRectMake(0, 0, 100, 100);
    layer.position  = CGPointMake(100, 100);
    [layer setNeedsDisplay];
    [self.view.layer addSublayer:layer];
}

#pragma -mark CALayerDelegate
//- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
//    CGContextAddEllipseInRect(ctx, CGRectMake(0,0,100,200));
//    CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);
//    CGContextFillPath(ctx);
//}
//测试画图
- (void)testDraw
{
    SubView *view = [[SubView alloc] initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH-40, 300)];
    [self.view addSubview:view];
    
    NSLog(@">>>>%@",view.name);
//    NSString *str = @"我自横刀向天笑，去留肝胆两昆仑。--谭嗣同同学你好啊。This is my first CoreText demo,how are you ?I love three things,the sun,the moon,and you.the sun for the day,the moon for the night,and you forever.去年今日此门中，人面桃花相映红。人面不知何处去，桃花依旧笑春风。少年不知愁滋味，爱上层楼";
//    CGFloat height = [SubLabel textHeightWithText:str width:200 font:[UIFont systemFontOfSize:14]];
//    SubLabel *myLab = [[SubLabel alloc] initWithFrame:CGRectMake(10, 100, 200, 200)];
//    myLab.text = @"123";
//    myLab.layer.borderWidth = 1;
//    myLab.font = [UIFont systemFontOfSize:14];
//    [self.view addSubview:myLab];
    
    
}
//UIView和CALayer的测试
- (void)testViewAndCALayer
{
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 60)];
//    mainView.backgroundColor = [UIColor yellowColor];
    
    CALayer *grayCover = [[CALayer alloc] init];
   
    grayCover.backgroundColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
    
    [mainView.layer addSublayer:grayCover];
    
    [self.view addSubview:mainView];
}



//block测试
- (void)testBlock
{
    /*
     结论：（先变化的是存储的地址）
     1、__block定义的变量，如果在block内部使用了（无需调用，定义了就改变了），那么后面的变量都会变为堆区的那个
     2、只要有拷贝到堆区，后面所有的block都是使用同一个堆区变量
     3、__block没定义变量，只是拷贝一份到堆区，不对后面的变量使用产生影响
     4、Block就是Oc的对象，所以这就是为什么会在堆区
     */
//    __block int a = 0;
//    int a = 0;
//    __block int b = 10;
//    const char *text = "hello";     //不能用数组text[]，block并没有实现对C语音数组的截获
//    NSLog(@"定义前：%p", &a);         //栈区
//    void (^foo)(void) = ^{
////        a = 10;
//        NSLog(@"block内部：%p a=%d str=%s", &a,a,text);    //堆区
//
//    };
//
//    void (^hoo)(void) = ^{
////        a = 10;
//        NSLog(@"hoo--block内部：%p a=%d", &b,b);    //堆区
//    };

    //源码都是通过
    //(a._forwarding->val)来访问的，当使用__block是，_forwarding会执行堆区的，否则执行自己本身，这样就可以很好地兼容堆栈区的变量
//    a++;
//    NSLog(@"定义后：%p a = %d", &a,a);         //堆区
//    foo();
////    NSLog(@"block存储地址=%p 内容地址=%p",&foo,foo);
////    hoo();
//    NSLog(@"B变量的存储地址=%p",&b);
    
    //使用__block修饰，在block编译后，就直接修改了源对象的地址，后面使用此对象，都是使用新的地址的对象
    //new出来的对象，存储空间实在堆区的，但a有时局部变量，所以在栈区的变量a存储了实际堆区内容的地址
//    __block NSMutableString *a = [NSMutableString stringWithString:@"Tom"];
//    NSLog(@"\n 定以前：------------------------------------\n\
//          a指向的堆中地址：%p；a在栈中的指针地址：%p", a, &a);               //a在栈区
//    void (^foo)(void) = ^{
////        a.string = @"Jerry";
//        a = [NSMutableString stringWithString:@"William"];
//        NSLog(@"\n block内部：------------------------------------\n\
//              a指向的堆中地址：%p；a在拷贝到堆后的指针地址：%p", a, &a);               //a在栈区
//
//    };
//
//    NSLog(@"\n 定以后：------------------------------------\n\
//          a指向的堆中地址：%p；a在拷贝到堆后的指针地址：%p", a, &a);               //a在栈区
//
//    foo();
    
//    NSArray *obj = [self getBlockArray];
//    typedef void (^blk_t)();
//    blk_t blk = (blk_t)[obj firstObject];
//    blk_t blk1 = (blk_t)[obj objectAtIndex:1];
//    blk();
//
//    blk_t blk3 = (blk_t)[self getMyBlock];
//    NSLog(@"地址=%p 内容地址=%p",&blk3,blk3);
//    blk3();
    
    //截获对象的问题
//    typedef void (^blk_t)(id obj);
//    blk_t blk;
//    {
//        id array = [[NSMutableArray alloc] init];
//        id __weak array1 = array;
//        blk = ^(id obj){
//
//            [array1 addObject:obj];
//            NSLog(@"array count = %ld",[array1 count]);
//        };
//
//    }
//
//    blk([[NSObject alloc] init]);
//    blk([[NSObject alloc] init]);
//    blk([[NSObject alloc] init]);
    
//    NSArray *arr = [self getPerson];
//    Student *stu = [arr firstObject];
//    NSLog(@"stu=%@",stu.name);
    
    [self myBlockTest];

}
- (void)myBlockTest
{
//    __block int a = 10;     //__block变量
//    NSLog(@"a前的地址=%p a=%d",&a,a);
//    void (^foo)(void) = ^{
//        NSLog(@"foo_block中的a的地址%p a=%d",&a,a);    //堆区
////        NSLog(@"foo_block中");
//
//    };
//    foo();
//    NSLog(@"a后的地址=%p a=%d",&a,a);
//    NSLog(@"block的存储地址=%p 内容地址=%p",&foo,foo);
    
    //如果block不访问局部变量或者堆区的变量，默认是存储到代码区的
//    static int a = 10;     //静态局部变量
//    void (^foo)(void) = ^{
//        //修改a的值
////        a = 12;
////        NSLog(@"foo_block中的a的地址%p a=%d",&a,a);    //堆区
//    };
//    void (^hoo)(void) = ^{
////        NSLog(@"hoo_block中的a的地址%p a=%d",&a,a);    //堆区
//    };
//    foo();
//    hoo();
//    NSLog(@"外部a的地址=%p a=%d",&a,a);
//    NSLog(@"foo的存储地址=%p 内存地址=%p",&foo,foo);
//
    static int b = 10;     //静态局部变量
    int a = 10;     //局部变量
    NSArray *arr = [[NSArray alloc] init];
    void (^foo)(void) = ^{
        NSLog(@"foo 的block%d--->%d",a,b);    //堆区

    };
    foo();
    NSLog(@"a的地址=%p, b的地址=%p",&a,&b);
    NSLog(@"arr的存储地址=%p 内容地址=%p",&arr,arr);
    NSLog(@"block的存储地址=%p 内容地址=%p",&foo,foo);
}

- (id)getBlockArray
{
    int val = 10;

    typedef void (^blk_t)();
    //栈上的block
//    blk_t blk0 = ^{NSLog(@"blk0:%d",val);};
    blk_t blk1 = ^{NSLog(@"blk1:%d",val);};
//    NSLog(@"地址=%p 内容地址=%p",&blk0,blk0);
//    blk_t blk2 = [blk0 copy];   //如果不执行copy，这函数返回后，block已经被释放，再访问就会出错，我觉得这里是拷贝到了autoPool中，所有返回没被释放，外部还可以访问
//    NSLog(@"地址=%p 内容地址=%p",&blk2,blk2);
    return [[NSArray alloc] initWithObjects:^{NSLog(@"blk0:%d",val);},blk1, nil];
    
}
- (id)getMyBlock
{
    int val = 10;
    
    typedef void (^blk_t)();
    //栈上的block
    blk_t blk0 = ^{NSLog(@"blk0:%d",val);};
    NSLog(@"地址=%p 内容地址=%p",&blk0,blk0);
    return blk0;
}
- (id)getPerson
{
    Student *stu = [[Student alloc] init];
    stu.name = @"liuyu";
    
    return [[NSArray alloc] initWithObjects:stu, nil];
    return stu;
}

//自动补全功能
- (void)testAutoFit
{
    _array = @[@"wulang",@"xiaoming",@"dongyan",@"xiaohua"];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, 160, 32)];
    textField.layer.borderWidth = 1;
    textField.delegate = self;
    [self.view addSubview:textField];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@""]) {//删除的话
        return YES;
    }
    NSMutableString *text = [[NSMutableString alloc]initWithCapacity:0];
    [text appendString:textField.text];
    [text deleteCharactersInRange:range];//在选中的位置 插入string
    [text insertString:string atIndex:range.location];
    
    if (text.length>2) { //限制从2个以上才开始匹配  根据需求 自己设定
        NSString *behind = [self matchString:text]; //匹配是否有开头相同的
        if (behind) {
            [text appendString:behind];
            textField.text = text;
            UITextPosition *endDocument = textField.endOfDocument;//获取 text的 尾部的 TextPositext
            
            //选取尾部补全的String
            UITextPosition *end = [textField positionFromPosition:endDocument offset:0];
            UITextPosition *start = [textField positionFromPosition:end offset:-behind.length];//左－右＋
            textField.selectedTextRange = [textField textRangeFromPosition:start toPosition:end];
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}
-(NSString *)matchString:(NSString *)head{
    for (int i = 0; i<[_array count]; i++) {
        NSString *string = _array[i];
        if ([string hasPrefix:head]) {
            return  [string substringFromIndex:head.length];
        }
    }
    return nil;
}

//测试textView
- (void)testMyTextView
{
    //选中文字，并且用颜色围住
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, 160, 32)];
    textView.text = @"sdfdsfdfdsfdsf";
    textView.layer.borderWidth = 1;
    [self.view addSubview:textView];
    
    UITextPosition *start = [textView positionFromPosition:textView.beginningOfDocument offset:0];
    UITextPosition *end = [textView positionFromPosition:start offset:4];
    UITextRange *range = [textView textRangeFromPosition:start toPosition:end];
    
    //有可能出现多行，所以这里是数组
    NSArray *highlightRects = [textView selectionRectsForRange:range];
    for (UITextSelectionRect *selectionRect in highlightRects)
    {
        CGRect frame = selectionRect.rect;
        UIView *highlight = [[UIView alloc] initWithFrame:frame];
        highlight.backgroundColor = [UIColor blueColor];
        [textView insertSubview:highlight belowSubview:[self textSubview:textView]];
    }
}

- (UIView *)textSubview:(UITextView *)textView
{
//    if (!_textSubview)
//    {
//        // Detect _UITextContainerView or UIWebDocumentView (subview with text) for highlight placement
//
//    }
    UIView *_textSubview;
    for (UIView *view in textView.subviews)
    {
        if ([view isKindOfClass:NSClassFromString(@"_UITextContainerView")] || [view isKindOfClass:NSClassFromString(@"UIWebDocumentView")])
        {
            _textSubview = view;
            break;
        }
    }
    return _textSubview;
}

//测试frame和bounds
- (void)testFrameAndBounds
{
    //创建一个红色的view作为demo的父view
    UIView *redView = [[UIView alloc] init];
    redView.frame = CGRectMake(50, 50, 200, 200);
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];

    _redView = redView;
    
    // 创建一个switch控件作为demo的子view
    UISwitch *switchView = [[UISwitch alloc] init];
    [redView addSubview:switchView];
    NSLog(@"%lf",switchView.frame.origin.x) ;
    
}

//测试UIView+LayoutMethods的一些方法
- (void)testMyLayoutView
{
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(100, 50, 100, 100)];
    view1.backgroundColor = [UIColor redColor];
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(100, 50, 100, 100)];
    view2.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:view2];
    
    [view2 top:20 FromView:view1];
    
    
}

- (void)myTest1
{
    /*
     对应相对布局的view，期frame都是0，出了范围，那么它的frame又恢复正常了，在这个函数里面view1的frame都是0
     
     view1绝对布局    view2自动布局
     如果view2是相对view1的布局，那么改变view1的frame，view2会发生对应的改变
     
     view1自动布局    view2自动布局
     如果view2是相对view1的布局，那么view1 updateConstraints（这种情况改变frame是无效的），view2会发生改变
     */
//    void (^block)();
//    if(1){
//        block = ^{NSLog(@"Block A");};
//    }else {
//        block = ^{NSLog(@"Block B");};
//    }
//    block();
//    superView = [[UIView alloc] init];
    superView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
    superView.center = self.view.center;
    superView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:superView];
//    [superView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self.view);
////        make.width.mas_equalTo(self.view).multipliedBy(0.6);
////        make.height.mas_equalTo(self.view).multipliedBy(0.5);
//        make.width.mas_equalTo(200);
//        make.height.mas_equalTo(300);
//    }];
    
    view1 = [[UIView alloc] init];
//    view1 = [[UIView alloc] initWithFrame:CGRectMake(20, 40, 30, 30)];
//    view1.centerY = superView.centerY;
    view1.backgroundColor = [UIColor redColor];
    [superView addSubview:view1];
    
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor yellowColor];
    [superView addSubview:view2];
    
    UIView *view3 = [[UIView alloc] init];
    view3.backgroundColor = [UIColor greenColor];
//    [superView addSubview:view3];
    
    
    CGFloat w = 30;
    CGFloat padding = (superView.width-30*2)/3;
    
    //等分
//    [@[view1,view2] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:w leadSpacing:padding tailSpacing:padding];
//    [@[view1,view2] mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(superView);
//        make.height.mas_equalTo(view1.mas_width);
//    }];
    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(superView);
        make.width.height.mas_equalTo(w);
        make.left.equalTo(superView).offset((superView.width-30*2)/3);
    }];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view1.mas_top);
        make.width.height.mas_equalTo(view1.mas_width);

        make.right.mas_equalTo(superView).offset(-(superView.width-30*2)/3);
//        make.left.equalTo(view1.mas_right).offset(10);

    }];
//    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(view1.mas_top);
//        make.width.height.mas_equalTo(view1.mas_width);
//    }];
    
   
}

//手动设定实例变量的KVO实现监听
- (void)testKVC
{
    // 创建学生对象
    _student = [Student new];
    
    // 监听属性name
    [_student addObserver:self
               forKeyPath:@"name"  // 属性
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:nil];
    
    // 监听实例变量age
    [_student addObserver:self
               forKeyPath:@"age"   // 实例变量
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:nil];
    

//    NSLog(@"1");
//    [self willChangeValueForKey:@"name"]; // “手动触发self.now的KVO”，必写。
//    NSLog(@"2");
//    [self didChangeValueForKey:@"name"]; // “手动触发self.now的KVO”，必写。
//    NSLog(@"4");
    
    _student.name = @"YouXianMing"; // 改变名字
//    _student.age  = @"18";          // 改变年龄
    [_student setValue:@"18" forKey:@"age"];
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSLog(@"3%@", change);
}

- (void)drawCircleView
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    imageView.image = [UIImage imageNamed:@"icon_emergency"];
    
    UIImageView *subImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 100, 50)];
    subImage.backgroundColor = [UIColor greenColor];
    [imageView addSubview:subImage];

//    [self test2:imageView radius:50];
    [imageView setCirCleRoundByRadius:20];
    [self.view addSubview:imageView];
    
    
   
}

- (void)test:(UIImageView *)imageView radius:(CGFloat)radius
{
    imageView.layer.cornerRadius = radius;
    imageView.layer.masksToBounds = YES;
}

//使用贝塞尔曲线UIBezierPath和Core Graphics框架画出一个圆角
- (void)test1:(UIImageView *)imageView radius:(CGFloat)radius
{
    //开始对imageView进行画图
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);
    //使用贝塞尔曲线画出一个圆形图
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:radius] addClip];
    [imageView drawRect:imageView.bounds];
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    //结束画图
    UIGraphicsEndImageContext();
}
//使用CAShapeLayer和UIBezierPath设置圆角，使用遮挡层
- (void)test2:(UIImageView *)imageView radius:(CGFloat)radius
{
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:imageView.bounds.size];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:radius];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = imageView.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    imageView.layer.mask = maskLayer;
}

//CAShapeLayer
- (void)testLine
{
    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    shapeLayer.strokeColor = [UIColor yellowColor].CGColor;
    shapeLayer.lineWidth = 1;
    shapeLayer.frame = CGRectMake(30, 80, 100, 140);
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *eLineChartPath = [UIBezierPath bezierPath];
    eLineChartPath.lineCapStyle = kCGLineCapRound;
    eLineChartPath.lineJoinStyle = kCGLineCapRound;
    
    [eLineChartPath moveToPoint:CGPointMake(0, 30)];
    [eLineChartPath addQuadCurveToPoint:CGPointMake(shapeLayer.bounds.size.width, 30) controlPoint:CGPointMake(shapeLayer.bounds.size.width/2, 0)];
    [eLineChartPath addLineToPoint:CGPointMake(shapeLayer.bounds.size.width, shapeLayer.bounds.size.height)];
    [eLineChartPath addLineToPoint:CGPointMake(0, shapeLayer.bounds.size.height)];
    [eLineChartPath addLineToPoint:CGPointMake(0, 30)];
    
    shapeLayer.path = eLineChartPath.CGPath;
    
    [self.view.layer addSublayer:shapeLayer];
    
    //从开始到完整
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 3;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [shapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    
}

#pragma -mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
//    for(UIView *subView in cell.contentView.subviews)
//        [subView removeFromSuperview];
    
    NSString *fileName = [NSString stringWithFormat:@"Start%zi",indexPath.row%12];
    
    //这个会操作加载图和解压图片，所以第一次会占用比较多的时间，但后面会缓存，遇到同名的，会直接用解码后的图片，解码占用时间比较多，而且这个函数解压操作都是在主线程
//    imageView.image = [UIImage imageNamed:fileName];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        @autoreleasepool{

            NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"png"];
            UIImage *image1 = [UIImage imageWithContentsOfFile:path];
            //把解压操作放到子线程
            image1 = [UIImage decodedImageWithImage:image1];
            dispatch_async(dispatch_get_main_queue(), ^{

                cell.imageView.image = image1;
            });
        }
        
        
    });

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
@end
