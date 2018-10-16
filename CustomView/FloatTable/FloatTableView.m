//
//  FloatTableView.m
//  Runner
//
//  Created by  Tmac on 16/1/14.
//  Copyright © 2016年 Janson. All rights reserved.
//

#import "FloatTableView.h"

@interface FloatTableView()
<UITableViewDataSource,UITableViewDelegate>
{
    int cellHeight;
    BOOL isShow;
    BOOL hasImg;
    NSInteger numItem;
    CGRect myframe;
    int wtable;
    UIColor *Icolor;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,weak) UIViewController *myView;
@end
@implementation FloatTableView

- (id)initWithFrame:(CGRect)frame superView:(UIViewController *)_self numOfItem:(NSInteger)num hasImg:(BOOL)_hasImg
{
    if(self=[super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)])
    {
        myframe = frame;
        numItem = num;
        hasImg = _hasImg;
        self.myView = _self;
        Icolor = [UIColor lightGrayColor];
        [self initData];
        [self createView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame superView:(UIViewController *)_self hasImg:(BOOL)_hasImg
{
    if(self=[super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)])
    {
        myframe = frame;
        hasImg = _hasImg;
        self.myView = _self;
        Icolor = [UIColor lightGrayColor];
        
    }
    return self;
}

- (void)initData
{
    cellHeight = 40;
    isShow = NO;
    
}

- (void)createView
{
    UIView *arrowView = [self getArrows];
    [self addSubview:arrowView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(myframe.origin.x, CGRectGetMaxY(arrowView.frame), myframe.size.width, cellHeight*[_dataSource numOfFloatTableView:self])];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //_tableView.backgroundColor = [UIColor grayColor];
    _tableView.scrollEnabled = NO;
    _tableView.layer.cornerRadius = 4;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.backgroundColor = [UIColor clearColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.backgroundColor = [UIColor whiteColor];
    view.alpha = 0.2;
    [self addSubview:view];
    [self addSubview:_tableView];
    
    
    //点击事件
    UITapGestureRecognizer *singleTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                             action:@selector(tap)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [view addGestureRecognizer:singleTap];
    
    
    
}

//获得三角标志
- (UIView *)getArrows
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(myframe.origin.x, myframe.origin.y, myframe.size.width, 10)];
    view.backgroundColor = [UIColor clearColor];
    
    CAShapeLayer *layer = [CAShapeLayer new];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(myframe.size.width-16, 0)];
    [path addLineToPoint:CGPointMake(myframe.size.width-22, 10)];
    [path addLineToPoint:CGPointMake(myframe.size.width-10, 10)];
    [path addLineToPoint:CGPointMake(myframe.size.width-16, 0)];
    
    layer.path = path.CGPath;
    layer.fillColor = [UIColor blueColor].CGColor;
    
    [view.layer addSublayer:layer];
    return view;
}
- (void)setDataSource:(id<FloatTableViewDataSource>)dataSource
{
    _dataSource = dataSource;
    
    [self initData];
    [self createView];
}

- (void)setBgColor:(UIColor *)color
{
    Icolor = color;
}

- (void)reloadData
{
    if(_tableView)
       [_tableView reloadData];
}
- (void)show
{
//    UIView *view = [[UIApplication sharedApplication].delegate window];
//    [view addSubview:self];
    //self.hidden = NO;
    
    [self.myView.view addSubview:self];
    isShow = YES;
}

- (void)hiding
{
    isShow = NO;
    [self removeFromSuperview];
}

- (void)showOrHiding
{
    if(isShow)
        [self hiding];
    else
        [self show];
}



- (void)tap
{
    [self hiding];
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource numOfFloatTableView:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FloatTableCell"];
    if (!cell)
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FloatTableCell"];
    }
    
    for(UIView *vi in cell.contentView.subviews)
    {
        [vi removeFromSuperview];
    }
    //image
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, cellHeight/4, cellHeight/2, cellHeight/2)];
    //imageView.layer.borderWidth = 1;
    //imageView.image = [UIImage imageNamed:@"icon_qq"];
    if([self.dataSource respondsToSelector:@selector(floatTableView:imageAtIndex:)])
    {
        imageView.image = [self.dataSource floatTableView:self imageAtIndex:row];
        [cell.contentView addSubview:imageView];
    }
    
    //title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+8, 0, myframe.size.width, cellHeight)];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:cellHeight/2-6],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    NSString *tmp = @"null";
    if([self.dataSource respondsToSelector:@selector(floatTableView:stringAtIndex:)])
    {
        tmp = [self.dataSource floatTableView:self stringAtIndex:row];
    }
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:tmp attributes:dic];
    title.attributedText = str;
    title.textAlignment = NSTextAlignmentLeft;
    
    //分割线
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight-1, myframe.size.width, 1)];
    bottom.backgroundColor = ColorRGB(20, 180, 230);
    [cell.contentView addSubview:bottom];
    
    if(!hasImg)
    {
        [imageView removeFromSuperview];
        title.frame = CGRectMake(0, 0, myframe.size.width, cellHeight);
        title.textAlignment = NSTextAlignmentCenter;
    }
    
    cell.backgroundColor = Icolor;
    //cell.selectedBackgroundView.backgroundColor = Icolor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:title];
    
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hiding];
    if([self.delegate respondsToSelector:@selector(floatTableView:didSelectedRowAtIndex:)])
    {
        [self.delegate floatTableView:self didSelectedRowAtIndex:indexPath.row];
    }
    
    
}

@end
