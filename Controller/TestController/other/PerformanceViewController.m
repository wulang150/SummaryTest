//
//  PerformanceViewController.m
//  SummaryTest
//
//  Created by  Tmac on 2018/6/27.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "PerformanceViewController.h"
#import "SDWebImageDecoder.h"
#import "YYFPSLabel.h"

@interface PerformanceViewController ()
<UITableViewDelegate,UITableViewDataSource>
{
    
}

@property (strong, nonatomic) NSCache *memCache;
@property (strong, nonatomic) dispatch_queue_t ioQueue;
@end

@implementation PerformanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavWithTitle:@"性能测试" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
    [self initCache];
    [self testTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initCache
{
    _memCache = [[NSCache alloc] init];
    _memCache.countLimit = 11;
    // Create IO serial queue
    _ioQueue = dispatch_queue_create("com.hackemist.SDWebImageCache", DISPATCH_QUEUE_SERIAL);
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

- (void)queryImageCache:(NSString *)filename block:(void(^)(UIImage *image))block
{
    //从内存去取，如果没取到，就直接读取文件，在缓存起来
    UIImage *image = [self.memCache objectForKey:filename];
    if(image)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(block)
                block(image);
        });
    }
    else
    {
        dispatch_async(_ioQueue, ^{
            
            @autoreleasepool{
                NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"png"];
                UIImage *image = [UIImage imageWithContentsOfFile:path];
                //把解压操作放到子线程
                image = [UIImage decodedImageWithImage:image];
                [self.memCache setObject:image forKey:filename];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(block)
                        block(image);
                });
            }
        });
    }
}

#pragma -mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        //注意：ios9.0之后对UIImageView的圆角设置做了优化，UIImageView这样设置圆角
        //不会触发离屏渲染，ios9.0之前还是会触发离屏渲染。而UIButton还是都会触发离屏渲染。
        UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 80, 100-12)];
        headImageView.tag = 10;
        headImageView.layer.cornerRadius = 40;
        headImageView.clipsToBounds = YES;
        [cell.contentView addSubview:headImageView];
        
        UIImageView *headImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(headImageView.right+10, 6, 80, 100-12)];
        headImageView1.tag = 11;
        headImageView1.layer.cornerRadius = 40;
        headImageView1.clipsToBounds = YES;
        [cell.contentView addSubview:headImageView1];
        
        headImageView.image = [UIImage imageNamed:@"IMG_0548"];
        headImageView1.image = [UIImage imageNamed:@"IMG_0548"];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(headImageView1.right+6, 6, 80, 44);
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 20;
        btn.clipsToBounds = YES;
        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:@"点击按钮" forState:UIControlStateNormal];
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(btn.right+6, 6, 80, 44);
        btn1.layer.borderWidth = 1;
        btn1.layer.cornerRadius = 20;
        btn1.clipsToBounds = YES;
        btn1.backgroundColor = [UIColor redColor];
        [btn1 setTitle:@"点击按钮" forState:UIControlStateNormal];
        
        [cell.contentView addSubview:btn];
        [cell.contentView addSubview:btn1];
    }
    
//    UIImageView *headImageView = [cell.contentView viewWithTag:10];
//    headImageView.image = [UIImage imageNamed:@"myimage"];
    
    //下面是对图片解码的处理
//    NSString *fileName = [NSString stringWithFormat:@"Start%zi",indexPath.row%12];
//
//    //这个会操作加载图和解压图片，所以第一次会占用比较多的时间，但后面会缓存，遇到同名的，会直接用解码后的图片，解码占用时间比较多，而且这个函数解压操作都是在主线程
//
//    //        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"png"];
//    //        UIImage *image = [UIImage imageWithContentsOfFile:path];
//
//    @autoreleasepool{
//        UIImage *image = [UIImage imageNamed:fileName];
//        UIImageView *imageView = [cell.contentView viewWithTag:10];
//        imageView.image = image;
//    }
//
//
//    [self queryImageCache:fileName block:^(UIImage *image) {
//        UIImageView *imageView = [cell.contentView viewWithTag:10];
//        imageView.image = image;
//    }];

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
