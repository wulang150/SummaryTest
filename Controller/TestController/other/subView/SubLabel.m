//
//  SubLabel.m
//  SummaryTest
//
//  Created by  Tmac on 2018/6/8.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "SubLabel.h"
#import "SubLayer.h"
#import <CoreText/CoreText.h>

@interface SubLabel()
{
    
}
@property (nonatomic ,assign) CGFloat textHeight;
@end

@implementation SubLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect
{
//    [super drawRect:rect];
//
////    dispatch_async(dispatch_get_global_queue(0, 0), ^{
////        //1.获取当前上下文
////        //    CGContextRef contextRef = UIGraphicsGetCurrentContext();
////        //2.创建文字
////        NSString * str = self.text;
////        //设置字体样式
////        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
////        //NSFontAttributeName:字体大小
////        dict[NSFontAttributeName] = [UIFont systemFontOfSize:12];
////        //字体前景色
////        dict[NSForegroundColorAttributeName] = [UIColor blueColor];
////        //字体背景色
////        dict[NSBackgroundColorAttributeName] = [UIColor redColor];
////        //字体阴影
////        NSShadow * shadow = [[NSShadow alloc]init];
////        //阴影偏移量
////        shadow.shadowOffset = CGSizeMake(2, 2);
////        //阴影颜色
////        shadow.shadowColor = [UIColor greenColor];
////        //高斯模糊
////        shadow.shadowBlurRadius = 5;
////        dict[NSShadowAttributeName] = shadow;
////        //字体间距
////        dict[NSKernAttributeName] = @4;
////        //绘制到上下文
////        //从某一点开始绘制 默认 0 0点
////        //    [str drawAtPoint:CGPointMake(100, 100) withAttributes:nil];
////        //绘制区域设置
////        dispatch_async(dispatch_get_main_queue(), ^{
////            [str drawInRect:rect withAttributes:dict];
////        });
////
////        //添加到上下文
////        //    CGContextStrokePath(contextRef);
////    });
//
//    NSLog(@"subLayer-->drawRect");
//    NSString *str = self.text;
//    //设置字体样式
//    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
//    //NSFontAttributeName:字体大小
//    dict[NSFontAttributeName] = [UIFont systemFontOfSize:12];
//    //字体前景色
//    dict[NSForegroundColorAttributeName] = [UIColor blueColor];
//    //字体背景色
//    dict[NSBackgroundColorAttributeName] = [UIColor redColor];
//    //字体阴影
//    NSShadow * shadow = [[NSShadow alloc]init];
//    //阴影偏移量
//    shadow.shadowOffset = CGSizeMake(2, 2);
//    //阴影颜色
//    shadow.shadowColor = [UIColor greenColor];
//    //高斯模糊
//    shadow.shadowBlurRadius = 5;
//    dict[NSShadowAttributeName] = shadow;
//    //字体间距
//    dict[NSKernAttributeName] = @4;
//    //绘制到上下文
//    //从某一点开始绘制 默认 0 0点
//    //    [str drawAtPoint:CGPointMake(100, 100) withAttributes:nil];
//    //绘制区域设置
//    [str drawInRect:rect withAttributes:nil];

    

//    [self test:rect];
    
//    [self drawRectWithLineByLine];
    //自己的绘图方法
    [self mytest:rect];
    //调用父类的绘图方法
    [super drawRect:rect];
}

//+ (Class)layerClass {
//    return [SubLayer class];
//}

- (void)mytest:(CGRect)rect
{
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //保存原来的上下文
    CGContextSaveGState(context);
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"iOS程t序在yue是否水电费水电费的是否第三方覆餗是的范德萨发的是范德萨发"];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
    //描绘区域
    CGMutablePathRef Path = CGPathCreateMutable();
    CGPathAddRect(Path, NULL ,CGRectMake(0 , 0 ,self.bounds.size.width , self.bounds.size.height));
    //通过区域和文本得到frame
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    //得到frame中的行数组
    CFArrayRef Lines = CTFrameGetLines(frame);
    //获取数组Lines中的个数，一个多少行
    CFIndex lineCount = CFArrayGetCount(Lines);
    //获取基线原点的位置
    CGPoint lineOrigins[lineCount]; //绝对的位置
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
    for (int i = 0; i < lineCount; i++){
        CGPoint point = lineOrigins[i];
        NSLog(@"point.y = %f",point.y);
    }
    
    NSLog(@"当前context的变换矩阵 %@", NSStringFromCGAffineTransform(CGContextGetCTM(context)));
    //设置字形变换矩阵为CGAffineTransformIdentity，也就是说每一个字形都不做图形变换
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    //转换坐标方法1
//    CGAffineTransform flipVertical = CGAffineTransformMake(1,0,0,-1,0,self.bounds.size.height);
//    CGContextConcatCTM(context, flipVertical);//将当前context的坐标系进行flip
    
    //转换坐标方法2
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    NSLog(@"翻转后context的变换矩阵 %@", NSStringFromCGAffineTransform(CGContextGetCTM(context)));
    
    for (CFIndex i = 0; i < lineCount; i ++) {
        CTLineRef line = CFArrayGetValueAtIndex(Lines, i);
        
        CGPoint lineOrigin = lineOrigins[i];
        //设置绘制的基线原点
        CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y);
        //画横线
//        CGContextSetLineWidth(context, 1.0);
//        CGContextMoveToPoint(context, lineOrigin.x, lineOrigin.y);
//        CGContextAddLineToPoint(context, lineOrigin.x+30, lineOrigin.y);
//        CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
//        CGContextStrokePath(context);
        
        
        //如果要每一行地画，就得通过CGContextSetTextPosition修改每一行的绝对位置
        CTLineDraw(line, context);//开始绘制一行
        
        //多部分绘制 比如:IOS你好iye，那么就会分为三部分：IOS、你好、iye
//        CFArrayRef runs = CTLineGetGlyphRuns(line);
//        for (NSUInteger r = 0, rMax = CFArrayGetCount(runs); r < rMax; r++) {
//            //获得字符图像run
//            CTRunRef run = CFArrayGetValueAtIndex(runs, r);
//            CTRunDraw(run, context, CFRangeMake(0, 0));
//
//        }
        
    }
    //你的绘图结束后，出栈恢复
    CGContextRestoreGState(context);
    // 步骤7.内存管理
    CFRelease(frame);
    CFRelease(Path);
    CFRelease(framesetter);
}

- (void)test:(CGRect)rect
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"iOS程序在启动时会创建一个主线程，Jhpippp线程只能执行一件事情，如果在主线程执行某些耗时操作。"];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
    //描绘区域
    CGMutablePathRef Path = CGPathCreateMutable();
    CGPathAddRect(Path, NULL ,CGRectMake(0 , 0 ,self.bounds.size.width , self.bounds.size.height));
    //通过区域和文本得到frame
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    //得到frame中的行数组
    CFArrayRef Lines = CTFrameGetLines(frame);
    //获取数组Lines中的个数，一个多少行
    CFIndex lineCount = CFArrayGetCount(Lines);
    
    //获取基线原点的位置
    CGPoint lineOrigins[lineCount]; //绝对的位置
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
    for (int i = 0; i < lineCount; i++){
        CGPoint point = lineOrigins[i];
        NSLog(@"point.y = %f",point.y);
    }
    
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSLog(@"当前context的变换矩阵 %@", NSStringFromCGAffineTransform(CGContextGetCTM(context)));
    
    for (CFIndex i = 0; i < lineCount; i ++) {
        CTLineRef line = CFArrayGetValueAtIndex(Lines, i);
        
        //遍历每一行CTLine
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading; // 行距
        // 该函数除了会设置好ascent,descent,leading之外，还会返回这行的宽度
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
        NSLog(@"lineAscent = %f",lineAscent);
        NSLog(@"lineDescent = %f",lineDescent);
        NSLog(@"lineLeading = %f",lineLeading);
        
//        CGRect oldLineBounds = CTLineGetImageBounds((CTLineRef)line, context);
//        NSLog(@"Position修改前%@",NSStringFromCGPoint(CGContextGetTextPosition(context)));
//        NSLog(@"lineBounds改动前：%@",NSStringFromCGRect(oldLineBounds));
        
        CGPoint lineOrigin = lineOrigins[i];
        //设置绘制的基线原点
        CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y);
//        CGRect lineBounds = CTLineGetImageBounds((CTLineRef)line, context);
//        NSLog(@"Position修改后%@",NSStringFromCGPoint(CGContextGetTextPosition(context)));
//        NSLog(@"lineBounds改动后 = %@",NSStringFromCGRect(lineBounds));
        //画横线
        CGContextSetLineWidth(context, 1.0);
        CGContextMoveToPoint(context, lineOrigin.x, lineOrigin.y);
        CGContextAddLineToPoint(context, lineOrigin.x+30, lineOrigin.y);
        CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
        CGContextStrokePath(context);
        
        //如果要每一行地画，就得通过CGContextSetTextPosition修改每一行的绝对位置
        CTLineDraw(line, context);//开始绘制一行
    }
    
    
    // 步骤7.内存管理
    CFRelease(frame);
    CFRelease(Path);
    CFRelease(framesetter);
}

- (void)test1:(CGRect)rect
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
        
        NSLog(@"当前context的变换矩阵 %@", NSStringFromCGAffineTransform(CGContextGetCTM(ctx)));
        //他的作用是将上下文空间坐标系进行翻转，并使原来的左下角原点变成左上角是原点，并将向上为正y轴变为向下为正y轴
        //如果使用coreText来绘图，就得修改坐标，因为坐标系是不一样的
        //向下移动
        //        CGContextTranslateCTM(ctx, rect.origin.x, rect.origin.y+[UIFont systemFontOfSize:20].ascender);
        CGContextTranslateCTM(ctx, rect.origin.x, rect.origin.y+[UIFont systemFontOfSize:20].ascender);
        //当前文本矩阵，同样可以指定y因子为负数来倒转y轴，只是反转文字，坐标原点没有转到左下角
        CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1,-1));
        //设置字形变换矩阵为CGAffineTransformIdentity，也就是说每一个字形都不做图形变换
        //        CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
        
        //x，y轴方向移动
        //        CGContextTranslateCTM(ctx , 0 ,20);
        
        //缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
        //        CGContextScaleCTM(ctx, 1.0 ,-1.0);
        
        NSLog(@"翻转后context的变换矩阵 %@", NSStringFromCGAffineTransform(CGContextGetCTM(ctx)));
        
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
            NSLog(@"penOffset = %f y = %f",penOffset,textOffset);
            CGContextSetTextPosition(ctx, penOffset, textOffset);//在偏移量x,y上打印，就是设置基准线
            CTLineDraw(line, ctx);//draw 行文字
            
            //画横线
            CGContextSetLineWidth(ctx, 1.0);
            CGContextMoveToPoint(ctx, penOffset, textOffset);
            CGContextAddLineToPoint(ctx, penOffset+30, textOffset);
            CGContextSetStrokeColorWithColor(ctx, [[UIColor redColor] CGColor]);
            CGContextStrokePath(ctx);
            
            textOffset += fontLineHeight;
            
            
        }
        
        CGContextRestoreGState(ctx);
        
    }
}

- (void)test2:(CGRect)rect
{
    // 步骤1：得到当前用于绘制画布的上下文，用于后续将内容绘制在画布上
    // 因为Core Text要配合Core Graphic 配合使用的，如Core Graphic一样，绘图的时候需要获得当前的上下文进行绘制
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSLog(@"当前context的变换矩阵 %@", NSStringFromCGAffineTransform(CGContextGetCTM(context)));
    // 步骤2：翻转当前的坐标系（因为对于底层绘制引擎来说，屏幕左下角为（0，0））
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);//设置字形变换矩阵为CGAffineTransformIdentity，也就是说每一个字形都不做图形变换
    CGAffineTransform flipVertical = CGAffineTransformMake(1,0,0,-1,0,self.bounds.size.height);
    CGContextConcatCTM(context, flipVertical);//将当前context的坐标系进行flip
    NSLog(@"翻转后context的变换矩阵 %@", NSStringFromCGAffineTransform(CGContextGetCTM(context)));
    
    // 步骤3：创建绘制区域
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    // 步骤4：创建需要绘制的文字与计算需要绘制的区域
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"iOS程序在启动时会创建一个主线程，而在一个线程只能执行一件事情，如果在主线程执行某些耗时操作，例如加载网络图片，下载资源文件等会阻塞主线程（导致界面卡死，无法交互），所以就需要使用多线程技术来避免这类情况。iOS中有三种多线程技术 NSThread，NSOperation，GCD，这三种技术是随着IOS发展引入的，抽象层次由低到高，使用也越来越简单。"];
    // 步骤5：根据AttributedString生成CTFramesetterRef
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, [attrString length]), path, NULL);
    
    //获取frame中CTLineRef数组
    CFArrayRef Lines = CTFrameGetLines(frame);
    //获取数组Lines中的个数
    CFIndex lineCount = CFArrayGetCount(Lines);
    
    //获取基线原点的位置
    CGPoint origins[lineCount]; //绝对的位置
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    for (CFIndex i = 0; i < lineCount; i ++) {
        CTLineRef line = CFArrayGetValueAtIndex(Lines, i);
        //相对于每一行基线原点的偏移量和宽高（例如：{{1.2， -2.57227}, {208.025, 19.2523}}，就是相对于本身的基线原点向右偏移1.2个单位，向下偏移2.57227个单位，后面是宽高）
        CGRect lineBounds = CTLineGetImageBounds((CTLineRef)line, context);
        NSLog(@"lineBounds = %@",NSStringFromCGRect(lineBounds));
        NSLog(@"point = %@",NSStringFromCGPoint(origins[i]));
        //每一行的起始点（相对于context）加上相对于本身基线原点的偏移量，本身都会根据基线有一定的偏移量
        lineBounds.origin.x += origins[i].x;
        lineBounds.origin.y += origins[i].y;
        //填充，画边框
        CGContextSetLineWidth(context, 1.0);
        CGContextAddRect(context,lineBounds);
        CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
        CGContextStrokeRect(context, lineBounds);
        
//        CTLineDraw(line, context);
    }
    // 步骤6：进行绘制
    CTFrameDraw(frame, context);
    
    // 步骤7.内存管理
    CFRelease(frame);
    CFRelease(path);
    CFRelease(frameSetter);
}

- (void)test3:(CGRect)rect
{
    // 步骤1：得到当前用于绘制画布的上下文，用于后续将内容绘制在画布上
    // 因为Core Text要配合Core Graphic 配合使用的，如Core Graphic一样，绘图的时候需要获得当前的上下文进行绘制
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSLog(@"当前context的变换矩阵 %@", NSStringFromCGAffineTransform(CGContextGetCTM(context)));
    // 步骤2：翻转当前的坐标系（因为对于底层绘制引擎来说，屏幕左下角为（0，0））
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);//设置字形变换矩阵为CGAffineTransformIdentity，也就是说每一个字形都不做图形变换
    CGAffineTransform flipVertical = CGAffineTransformMake(1,0,0,-1,0,self.bounds.size.height);
    CGContextConcatCTM(context, flipVertical);//将当前context的坐标系进行flip
    NSLog(@"翻转后context的变换矩阵 %@", NSStringFromCGAffineTransform(CGContextGetCTM(context)));
    
    // 步骤3：创建绘制区域
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    // 步骤4：创建需要绘制的文字与计算需要绘制的区域
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"门梁真可怕 当中英文混合之后，??????????会出现行高不统一的情况，现在在绘制的时候根据字体的descender来偏移绘制，对齐baseline。??????????同时点击链接的时候会调用drawRect: 造成绘制异常，所以将setNeedsDisplay注释，如需刷新，请手动调用。带上emoji以供测试????????????????????"];
    
    CTFontRef font = CTFontCreateWithName(CFSTR("Georgia"), 20, NULL);
    [attrString addAttribute:(id)kCTFontAttributeName value:(__bridge id)font range:NSMakeRange(0, attrString.length)];
    // 步骤5：根据AttributedString生成CTFramesetterRef
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, [attrString length]), path, NULL);
    
    //获取frame中CTLineRef数组
    CFArrayRef Lines = CTFrameGetLines(frame);
    //获取数组Lines中的个数
    CFIndex lineCount = CFArrayGetCount(Lines);
    
    //获取基线原点
    CGPoint origins[lineCount];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    for (CFIndex i = 0; i < lineCount; i ++) {
        CTLineRef line = CFArrayGetValueAtIndex(Lines, i);
        
        //遍历每一行CTLine
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading; // 行距
        // 该函数除了会设置好ascent,descent,leading之外，还会返回这行的宽度
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
        NSLog(@"lineAscent = %f",lineAscent);
        NSLog(@"lineDescent = %f",lineDescent);
        NSLog(@"lineLeading = %f",lineLeading);
        
        CGPoint lineOrigin = origins[i];
        NSLog(@"point = %@",NSStringFromCGPoint(lineOrigin));
        
        CGRect oldLineBounds = CTLineGetImageBounds((CTLineRef)line, context);
        NSLog(@"lineBounds改动前：%@",NSStringFromCGRect(oldLineBounds));
        
        NSLog(@"y = %f  d = %f  fontD = %f",lineOrigin.y,lineDescent,CTFontGetDescent(font));
        
        NSLog(@"Position修改前%@",NSStringFromCGPoint(CGContextGetTextPosition(context)));
//        CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y -lineDescent - CTFontGetDescent(font));
        CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y);
        NSLog(@"Position修改后%@",NSStringFromCGPoint(CGContextGetTextPosition(context)));
        
        CGRect lineBounds = CTLineGetImageBounds((CTLineRef)line, context);
        NSLog(@"lineBounds改动后 = %@",NSStringFromCGRect(lineBounds));
        //填充
        CGContextSetLineWidth(context, 1.0);
        CGContextAddRect(context,lineBounds);
        CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
        CGContextStrokeRect(context, lineBounds);
        
        //如果要每一行地画，就得通过CGContextSetTextPosition修改每一行的绝对位置
        CTLineDraw(line, context);//绘制原点为左下角
    }
    
    // 步骤6：进行绘制
    //    CTFrameDraw(frame, context);
    
    // 步骤7.内存管理
    CFRelease(frame);
    CFRelease(path);
    CFRelease(frameSetter);
}

#pragma mark - 计算高度
const CGFloat kGlobalLineLeading = 2.0;
/**
 *  高度 = 每行的asent + 每行的descent + 行数*行间距
 *  行间距为指定的数值
 */
+ (CGFloat)textHeightWithText:(NSString *)aText width:(CGFloat)aWidth font:(UIFont *)aFont
{
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:aText];
    // 设置全局样式
    [self addGlobalAttributeWithContent:content font:aFont];
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    //粗略的计算高度
    CGSize suggestSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetterRef, CFRangeMake(0, aText.length), NULL, CGSizeMake(aWidth, MAXFLOAT), NULL);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, aWidth, suggestSize.height*10)); // 10这个数值是随便给的，主要是为了确保高度足够
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, aText.length), path, NULL);
    CFArrayRef lines = CTFrameGetLines(frameRef);
    CFIndex lineCount = CFArrayGetCount(lines);
    CGFloat ascent = 0;
    CGFloat descent = 0;
    CGFloat leading = 0;
    CGFloat totalHeight = 0;
    NSLog(@"计算高度开始");
    for (CFIndex i = 0; i < lineCount; i++){
        CTLineRef lineRef = CFArrayGetValueAtIndex(lines, i);
        CTLineGetTypographicBounds(lineRef, &ascent, &descent, &leading);
        NSLog(@"ascent = %f---descent = %f---leading = %f",ascent,descent,leading);
        totalHeight += ascent + descent + kGlobalLineLeading;//行间距
    }
    NSLog(@"totalHeight = %f",totalHeight);
    return totalHeight;
}

#pragma mark - 工具方法
#pragma mark 给字符串添加全局属性，比如行距，字体大小，默认颜色
+ (void)addGlobalAttributeWithContent:(NSMutableAttributedString *)aContent font:(UIFont *)aFont
{
    CGFloat lineLeading = kGlobalLineLeading; // 行间距
    
    const CFIndex kNumberOfSettings = 2;
    //设置段落格式
    CTParagraphStyleSetting lineBreakStyle;
    CTLineBreakMode lineBreakMode = kCTLineBreakByWordWrapping;
    lineBreakStyle.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakStyle.valueSize = sizeof(CTLineBreakMode);
    lineBreakStyle.value = &lineBreakMode;
    
    //设置行距
    CTParagraphStyleSetting lineSpaceStyle;
    CTParagraphStyleSpecifier spec;
    spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    lineSpaceStyle.spec = spec;
    lineSpaceStyle.valueSize = sizeof(CGFloat);
    lineSpaceStyle.value = &lineLeading;
    
    // 结构体数组
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        lineBreakStyle,
        lineSpaceStyle,
    };
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    
    // 将设置的行距应用于整段文字
    [aContent addAttribute:NSParagraphStyleAttributeName value:(__bridge id)(theParagraphRef) range:NSMakeRange(0, aContent.length)];
    
    CFStringRef fontName = (__bridge CFStringRef)aFont.fontName;
    CTFontRef fontRef = CTFontCreateWithName(fontName, aFont.pointSize, NULL);
    // 将字体大小应用于整段文字
    [aContent addAttribute:NSFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0, aContent.length)];
    
    // 给整段文字添加默认颜色
    [aContent addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, aContent.length)];
    // 内存管理
    CFRelease(theParagraphRef);
    CFRelease(fontRef);
}
/**
 *  一行一行绘制，未调整行高（行高不固定）
 */
- (void)drawRectWithLineByLine
{
    
    // 1.创建需要绘制的文字
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    // 2.设置行距等样式
    [[self class] addGlobalAttributeWithContent:attributed font:self.font];
    
    //获取高度
    self.textHeight = [[self class] textHeightWithText:self.text width:CGRectGetWidth(self.bounds) font:self.font];
    
    // 3.创建绘制区域，path的高度对绘制有直接影响，如果高度不够，则计算出来的CTLine的数量会少一行或者少多行
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, CGRectGetWidth(self.bounds), self.textHeight));
    
    // 4.根据NSAttributedString生成CTFramesetterRef
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributed);
    
    CTFrameRef ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attributed.length), path, NULL);
    // 1.获取上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    // 2.转换坐标系
    CGContextSetTextMatrix(contextRef, CGAffineTransformIdentity);
    CGContextTranslateCTM(contextRef, 0, self.textHeight); // 此处用计算出来的高度
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    
    // 重置高度
    //    CGPathAddRect(path, NULL, CGRectMake(0, 0, CGRectGetWidth(self.bounds), self.textHeight));
    
    // 一行一行绘制
    CFArrayRef lines = CTFrameGetLines(ctFrame);
    CFIndex lineCount = CFArrayGetCount(lines);
    CGPoint lineOrigins[lineCount];
    
    // 把ctFrame里每一行的初始坐标写到数组里，注意CoreText的坐标是左下角为原点，通过ctFrame可以得到每一行的基线上最左侧的点的位置，后面的字行绘制都会通过这个蓟县，向上画ascender，向下画descender，Y轴的方向为向上
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), lineOrigins);
    for (int i = 0; i < lineCount; i++){
        CGPoint point = lineOrigins[i];
        NSLog(@"point.y = %f",point.y);
    }
    NSLog(@"font.ascender = %f,descender = %f,lineHeight = %f,leading = %f",self.font.ascender,self.font.descender,self.font.lineHeight,self.font.leading);
    CGFloat frameY = 0;
    for (CFIndex i = 0; i < lineCount; i++){
        // 遍历每一行CTLine
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading; // 行距
        // 该函数除了会设置好ascent,descent,leading之外，还会返回这行的宽度
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
        NSLog(@"lineAscent = %f",lineAscent);
        NSLog(@"lineDescent = %f",lineDescent);
        NSLog(@"lineLeading = %f",lineLeading);
        
        CGPoint lineOrigin = lineOrigins[i];
        NSLog(@"i = %ld, lineOrigin = %@",i,NSStringFromCGPoint(lineOrigin));
        // 微调Y值，需要注意的是CoreText的Y值是在baseLine处，而不是下方的descent。
        // lineDescent为正数，self.font.descender为负数
//        if (i > 0){
//            // 第二行之后需要计算
////            frameY = frameY - kGlobalLineLeading - lineAscent - lineDescent;
//            lineOrigin.y = frameY;
//        }else{
//            // 第一行可直接用
//            frameY = lineOrigin.y;
//        }
        // 调整坐标
        CGContextSetTextPosition(contextRef, lineOrigin.x, lineOrigin.y);
        CTLineDraw(line, contextRef);
        // 微调
//        frameY = frameY - lineDescent;
        //得到第二行的开始
//        frameY = frameY - kGlobalLineLeading - lineAscent - lineDescent;
        
        //画横线
        CGContextSetLineWidth(contextRef, 1.0);
        CGContextMoveToPoint(contextRef, lineOrigin.x, lineOrigin.y);
        CGContextAddLineToPoint(contextRef, lineOrigin.x+30, lineOrigin.y);
        CGContextSetStrokeColorWithColor(contextRef, [[UIColor redColor] CGColor]);
        CGContextStrokePath(contextRef);
    }
    CFRelease(path);
    CFRelease(framesetter);
    CFRelease(ctFrame);
    
//    CGRect frame = self.frame;
//    frame.size.height = self.textHeight;
//    self.frame = frame;
}

@end
