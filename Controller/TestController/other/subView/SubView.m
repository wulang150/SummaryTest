//
//  SubView.m
//  SummaryTest
//
//  Created by  Tmac on 2018/6/8.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "SubView.h"
#import <CoreText/CoreText.h>

@implementation SubView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self createView];
    }
    
    return self;
}

- (void)createView
{
//    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 30)];
//    lab.text = @"dsfdsf";
//    lab.backgroundColor = [UIColor redColor];
//    [self addSubview:lab];
    
    _name = @"hello";
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    NSLog(@"%s",__func__);
    // 下面两句代码的作用就是填充背景色
    [[UIColor grayColor] setFill];
    UIRectFill(rect);
//    //1.获取上下文
//    CGContextRef contextRef = UIGraphicsGetCurrentContext();
//    //2.描述路径
//    UIBezierPath * path = [UIBezierPath bezierPath];
//    //起点
//    [path moveToPoint:CGPointMake(10, 10)];
//    //终点
//    [path addLineToPoint:CGPointMake(100, 100)];
//    //设置颜色
//    [[UIColor blueColor] setStroke];
//    //3.添加路径
//    CGContextAddPath(contextRef, path.CGPath);
//    //显示路径
//    CGContextStrokePath(contextRef);
    
    [self test1:rect];
}

- (void)test:(CGRect)rect
{
    NSString *src = [NSString stringWithString:@"其实流程是这样的： 1、生成要绘制的NSAttributedString对象。 "];
    
    NSMutableAttributedString * mabstring = [[NSMutableAttributedString alloc]initWithString:src];
    
    long slen = [mabstring length];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)mabstring);
    
    CGMutablePathRef Path = CGPathCreateMutable();
    
    //坐标点在左下角，描绘区域
    CGPathAddRect(Path, NULL ,CGRectMake(0 , 0 ,self.bounds.size.width-20 , self.bounds.size.height-20));
    //通过区域和文本得到frame
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    
    
    //得到frame中的行数组
    CFArrayRef rows = CTFrameGetLines(frame);
    
    if (rows) {
        
        const CFIndex numberOfLines = CFArrayGetCount(rows);
        //行高
        const CGFloat fontLineHeight = [UIFont systemFontOfSize:20].lineHeight;
        CGFloat textOffset = 0;
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        //如果使用coreText来绘图，就得修改坐标，因为坐标系是不一样的
        //向下移动
        //        CGContextTranslateCTM(ctx, rect.origin.x, rect.origin.y+[UIFont systemFontOfSize:20].ascender);
        CGContextTranslateCTM(ctx, rect.origin.x, rect.origin.y+[UIFont systemFontOfSize:20].ascender);
        //同样可以指定y因子为负数来倒转y轴，只是反转文字
        CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1,-1));
        
        //x，y轴方向移动
        //        CGContextTranslateCTM(ctx , 0 ,20);
        
        //缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
        //        CGContextScaleCTM(ctx, 1.0 ,-1.0);
        
        for (CFIndex lineNumber=0; lineNumber<numberOfLines; lineNumber++) {
            CTLineRef line = CFArrayGetValueAtIndex(rows, lineNumber);
            float flush;
            switch (3) {
                case NSTextAlignmentCenter: flush = 0.5;    break; //1
                case NSTextAlignmentRight:  flush = 1;      break; //2
                case NSTextAlignmentLeft:  //0
                default:                    flush = 0;      break;
            }
            
            CGFloat penOffset = CTLineGetPenOffsetForFlush(line, flush, rect.size.width);
            NSLog(@"penOffset = %f",penOffset);
            CGContextSetTextPosition(ctx, penOffset, textOffset);//在偏移量x,y上打印
            CTLineDraw(line, ctx);//draw 行文字
            textOffset += fontLineHeight;
        }
        
        CGContextRestoreGState(ctx);
        
    }
}

- (void)test1:(CGRect)rect
{
//    //一：绘制直线
//    //获取上下文
//    CGContextRef context =UIGraphicsGetCurrentContext();
//    //设置直线宽度
//    CGContextSetLineWidth(context,3.0f);
//    //设置画笔颜色
//    CGContextSetStrokeColorWithColor(context, [[UIColor redColor]CGColor]);
//    //设置起始点和终点
//    CGContextMoveToPoint(context,0,10);
//    CGContextAddLineToPoint(context,80,10);
//    //绘制直线
//    CGContextStrokePath(context);
    
//    //二：绘制三角形
//    //获取上下文
//    CGContextRef context =UIGraphicsGetCurrentContext();
//    //设置直线宽度
//    CGContextSetLineWidth(context,3.0f);
//    //设置画笔颜色
//    CGContextSetStrokeColorWithColor(context, [[UIColor yellowColor]CGColor]);
//    //设置三角形的三个点，原理就是绘制直线
//    CGContextMoveToPoint(context,30,30);
//    CGContextAddLineToPoint(context,150,50);
//    CGContextAddLineToPoint(context,20,80);
//    CGContextAddLineToPoint(context,30,30);
//    //绘制路径
//    CGContextStrokePath(context);
    
    
    
//    //三：绘制圆形
//    //获取上下文
//    CGContextRef context =UIGraphicsGetCurrentContext();
//    //设置直线宽度
//    CGContextSetLineWidth(context,5.0f);
//    //设置画笔颜色
//    CGContextSetStrokeColorWithColor(context, [[UIColor yellowColor]CGColor]);
//    //设置背景填充颜色
//    CGContextSetFillColorWithColor(context, [[UIColor blueColor]CGColor]);
//    //设置绘制圆形的区域
//    CGContextAddEllipseInRect(context,CGRectMake(100,100,80,80));
//    //绘制路径
//    CGContextFillPath(context);
    //或者，或者通过UIBezierPath来画图
    // 1.获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 2.拼接路径
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(30,30,150,150)];
    // 3.把路径添加到上下文
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetFillColorWithColor(ctx, [[UIColor blueColor] CGColor]);
    // 4.渲染上下文到视图
    CGContextFillPath(ctx); //填充
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetLineWidth(ctx,3.0f);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor yellowColor] CGColor]);
    CGContextStrokePath(ctx);   //画线
    
//    [[UIColor blueColor] setFill];
//
//    [path fill];
    
//    //四：绘制方形
//    //上下文
//    CGContextRef context =UIGraphicsGetCurrentContext();
//    //设置画笔直线宽度
//    CGContextSetLineWidth(context,2.0f);
//    //设置画笔颜色
//    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor]CGColor]);
//    //设置背景填充色
//    CGContextSetFillColorWithColor(context, [[UIColor yellowColor]CGColor]);
//    //设置绘制方形区域
//    CGContextAddRect(context,CGRectMake(30,30,150,150));
//    //绘制路径
//    CGContextFillPath(context);
    
    //七：用Quartz2D方式绘制文字
//    //获取绘图上下文
//    CGContextRef context =UIGraphicsGetCurrentContext();
//    //设置绘制的文字
//    char *name ="right!";
//    //选择绘制的文字(参数：上下文、字体、大小、转码方式)
//    CGContextSelectFont(context,"Helvetica",0.5f,kCGEncodingMacRoman);
//    //设置文字绘制方式(描边、填充、描边填充)
//    CGContextSetTextDrawingMode(context,kCGTextFillStroke);
//    //设置画笔和填充颜色
//    CGContextSetStrokeColorWithColor(context, [[UIColor redColor]CGColor]);
//    CGContextSetFillColorWithColor(context, [[UIColor yellowColor]CGColor]);
//    //绘制文字
//    CGContextShowTextAtPoint(context,50,150, name,strlen(name));
    
//    //获取图像上下文对象
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetRGBStrokeColor(context, 250/255.0, 250/255.0, 250/255.0, 1);
//    CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
//    CGContextSetShadowWithColor(context, CGSizeMake(1, 1), 3, [UIColor yellowColor].CGColor);
//
//    //使用填充模式绘制文字
//    CGContextSetTextDrawingMode(context,kCGTextFill);
//    NSString *str = @"this is a jock";
//    [str drawAtPoint:CGPointMake(20, 20) withAttributes:@{NSFontAttributeName:[
//                                                                               UIFont fontWithName:@"Arial" size:30],NSForegroundColorAttributeName:[UIColor greenColor]}];
    

    //八：绘制图片
    //方式1：UIImage自带方式
//    UIImage *img1 = [UIImage imageNamed:@"myimage"];
//    [img1 drawAtPoint:CGPointMake(30,30)];
    
//    //方式2：Quartz2D方式
//    //获取上下文
//    CGContextRef context =UIGraphicsGetCurrentContext();
//    //绘制的图片
//    UIImage *img2 = [UIImage imageNamed:@"myimage"];
//    //使用Quarzt2D绘制的图片是倒置的，使用下方法设置坐标原点和显示比例来改变坐标系
//    CGContextTranslateCTM(context,0.0f,self.frame.size.height);
//    CGContextScaleCTM(context,1.0,-1.0);
//    //在上下文绘制图片
//    CGContextDrawImage(context,CGRectMake(10,20, img2.size.width, img2.size.height), [img2 CGImage]);
    
}
@end
