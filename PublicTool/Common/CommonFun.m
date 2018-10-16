//
//  CommonFun.m
//  SummaryTest
//
//  Created by  Tmac on 2017/6/29.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "CommonFun.h"
#import <CoreText/CoreText.h>

@implementation CommonFun


/**
 *  传入point，返回point.x对应的字节数距离
 *  比如说，一个view里面有个UIlable(labView)，UIlable里面含有带有属性的文字。当点击了lab，本来只能知道其中的point，现在要把这个point转为点击了文字哪个范围，即是点击文字的哪一个字节
 *  @param point 点击事件相对于view的point
 *  @param textRect labView相对于view的rect
 @param labView labView
 *  @return 点击文字的哪一个字节
 */

+ (CFIndex)characterIndexAtPoint:(CGPoint)point textRect:(CGRect)textRect labView:(UILabel *)labView
{
    UILabel *lab = labView;
    if(lab==nil)
        return NSNotFound;
    NSMutableAttributedString* optimizedAttributedText = [lab.attributedText mutableCopy];
    //遍历字体属性
    [lab.attributedText enumerateAttributesInRange:NSMakeRange(0, [lab.attributedText length]) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        //是否设置了字体大小
        if (!attrs[(NSString*)kCTFontAttributeName])
        {
            [optimizedAttributedText addAttribute:(NSString*)kCTFontAttributeName value:lab.font range:NSMakeRange(0, [lab.attributedText length])];
        }
        //是否设置了行间距
        if (!attrs[(NSString*)kCTParagraphStyleAttributeName])
        {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineBreakMode:lab.lineBreakMode];
            
            [optimizedAttributedText addAttribute:(NSString*)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
        }
    }];
    
    // modify kCTLineBreakByTruncatingTail lineBreakMode to kCTLineBreakByWordWrapping
    [optimizedAttributedText enumerateAttribute:(NSString*)kCTParagraphStyleAttributeName inRange:NSMakeRange(0, [optimizedAttributedText length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop)
     {
         NSMutableParagraphStyle* paragraphStyle = [value mutableCopy];
         //修改行距属性
         if ([paragraphStyle lineBreakMode] == NSLineBreakByTruncatingTail) {
             [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
         }
         
         [optimizedAttributedText removeAttribute:(NSString*)kCTParagraphStyleAttributeName range:range];
         [optimizedAttributedText addAttribute:(NSString*)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
     }];
    
    if (!CGRectContainsPoint(textRect, point)) {
        return NSNotFound;
    }
    
    // Offset tap coordinates by textRect origin to make them relative to the origin of frame
    point = CGPointMake(point.x - textRect.origin.x, point.y - textRect.origin.y);
    // Convert tap coordinates (start at top left) to CT coordinates (start at bottom left)
    point = CGPointMake(point.x, textRect.size.height - point.y);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)optimizedAttributedText);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [optimizedAttributedText length]), path, NULL);
    
    if (frame == NULL) {
        CFRelease(path);
        return NSNotFound;
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
    NSInteger numberOfLines = lab.numberOfLines > 0 ? MIN(lab.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    
    //NSLog(@"num lines: %ld", numberOfLines);
    
    if (numberOfLines == 0) {
        CFRelease(frame);
        CFRelease(path);
        return NSNotFound;
    }
    
    NSUInteger idx = NSNotFound;
    
    CGPoint lineOrigins[numberOfLines];
    //对lineOrigins数组赋值
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        //每一行的位置
        CGPoint lineOrigin = lineOrigins[lineIndex];
        //得到每一行的值
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        // Get bounding information of line
        //根据行距来正确计算一行的y向范围
        CGFloat ascent, descent, leading, width;
        width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = floor(lineOrigin.y - descent);
        CGFloat yMax = ceil(lineOrigin.y + ascent);
        
        // Check if we've already passed the line
        if (point.y > yMax) {
            break;
        }
        //竖向判断
        // Check if the point is within this line vertically
        if (point.y >= yMin) {
            //横向判断
            // Check if the point is within this line horizontally
            if (point.x >= lineOrigin.x && point.x <= lineOrigin.x + width) {
                //point相对这一行的位置
                // Convert CT coordinates to line-relative coordinates
                CGPoint relativePoint = CGPointMake(point.x - lineOrigin.x, point.y - lineOrigin.y);
                idx = CTLineGetStringIndexForPosition(line, relativePoint);
                
                break;
            }
        }
    }
    
    CFRelease(frame);
    CFRelease(path);
    
    return idx;
}

//最后一次执行这函数的时间与上一次的时间差
+ (UInt64)runGapTime
{
    static UInt64 lastDate = 0;
    UInt64 nowDate = [[NSDate date] timeIntervalSince1970]*1000;
    
    UInt64 gap = nowDate - lastDate;
    lastDate = nowDate;
    
    if(lastDate==0)
        return 0;
    return gap;
}

+ (NSAttributedString *)gainAttrStr:(NSString *)val valAttr:(NSDictionary *)valAttr unit:(NSString *)unit unitAttr:(NSDictionary *)unitAttr
{
    if(valAttr.count<=0||unitAttr.count<=0)
        return nil;
    NSMutableAttributedString *mulStr = [[NSMutableAttributedString alloc] initWithString:val attributes:valAttr];
    
    NSAttributedString *unitStr = [[NSAttributedString alloc] initWithString:unit attributes:unitAttr];
    
    [mulStr appendAttributedString:unitStr];
    
    return mulStr;
}

+ (NSAttributedString *)gainSimpleAttrStr:(NSString *)val valAttr:(NSArray *)valAttr unit:(NSString *)unit unitAttr:(NSArray *)unitAttr
{
    NSMutableDictionary *valDic = [[NSMutableDictionary alloc] initWithCapacity:10];
    NSMutableDictionary *unitDic = [[NSMutableDictionary alloc] initWithCapacity:10];
    
    for(id valsub in valAttr)
    {
        if([valsub isKindOfClass:[UIColor class]])
            [valDic setObject:valsub forKey:NSForegroundColorAttributeName];
        if([valsub isKindOfClass:[UIFont class]])
            [valDic setObject:valsub forKey:NSFontAttributeName];
    }
    
    for(id valsub in unitAttr)
    {
        if([valsub isKindOfClass:[UIColor class]])
            [unitDic setObject:valsub forKey:NSForegroundColorAttributeName];
        if([valsub isKindOfClass:[UIFont class]])
            [unitDic setObject:valsub forKey:NSFontAttributeName];
    }
    
    return [self gainAttrStr:val valAttr:valDic unit:unit unitAttr:unitDic];
}


+ (UIView *)gainVerAutoView:(NSArray *)subView viewX:(CGFloat)viewX viewY:(CGFloat)viewY align:(int)align
{
    CGFloat maxW = 0;
    UIView *preView = [[UIView alloc] initWithFrame:CGRectZero];
    UIView *mainview = [[UIView alloc] initWithFrame:CGRectZero];
    
    for(int i=0;i<subView.count;i++)
    {
        UIView *sview = [subView objectAtIndex:i];
        if([sview isKindOfClass:[UILabel class]])
        {
            UILabel *lab = (UILabel *)sview;
            CGFloat w = lab.frame.size.width;
            [lab sizeToFit];
            //如果是单行的，并且设置宽度比字体宽度小，那么就会通过控制字体大小来适应宽度
            if(lab.numberOfLines==1&&w>10&&w<lab.frame.size.width)
            {
                CGRect iframe = lab.frame;
                iframe.size.width = w;
                lab.frame = iframe;
                lab.adjustsFontSizeToFitWidth = YES;
            }
            
        }
        CGRect tframe = sview.frame;
        
        if(tframe.size.width>maxW)      //找到最大宽度
            maxW = tframe.size.width;
        
        tframe.origin.x = 0;
        if(i==0)
            tframe.origin.y = 0;
        if(tframe.size.height<=0)
            tframe.origin.y = 0;
        tframe.origin.y = CGRectGetMaxY(preView.frame)+tframe.origin.y; //调整每一个的y值
        sview.frame = tframe;
        preView = sview;
        
        [mainview addSubview:sview];
    }
    
    mainview.frame = CGRectMake(viewX, viewY, maxW, CGRectGetMaxY(preView.frame));
    if(align==1)    //居中对齐
    {
        //横向每个字控件都居中
        for(int i=0;i<subView.count;i++)
        {
            UIView *child = [subView objectAtIndex:i];
            child.center = CGPointMake(maxW/2, child.center.y);
        }
    }
    if(align==2)    //右对齐
    {
        for(int i=0;i<subView.count;i++)
        {
            UIView *child = [subView objectAtIndex:i];
            child.center = CGPointMake(maxW-child.frame.size.width/2, child.center.y);
        }
    }
    
    
    return mainview;
}

+ (UIView *)gainHorAutoView:(NSArray *)subView viewX:(CGFloat)viewX viewY:(CGFloat)viewY align:(int)align
{
    CGFloat maxH = 0;
    UIView *preView = [[UIView alloc] initWithFrame:CGRectZero];
    UIView *mainview = [[UIView alloc] initWithFrame:CGRectZero];
    
    for(int i=0;i<subView.count;i++)
    {
        UIView *sview = [subView objectAtIndex:i];
        
        if([sview isKindOfClass:[UILabel class]])
        {
            UILabel *lab = (UILabel *)sview;
            CGFloat w = lab.frame.size.width;
            [lab sizeToFit];
            //如果是单行的，并且设置宽度比字体宽度小，那么就会通过控制字体大小来适应宽度
            if(lab.numberOfLines==1&&w>10&&w<lab.frame.size.width)
            {
                CGRect iframe = lab.frame;
                iframe.size.width = w;
                lab.frame = iframe;
                lab.adjustsFontSizeToFitWidth = YES;
            }
        }
        CGRect tframe = sview.frame;
        if(tframe.size.height>maxH)
            maxH = tframe.size.height;
        
        tframe.origin.y = 0;
        if(i==0)
            tframe.origin.x = 0;
        if(tframe.size.width<=0)
            tframe.origin.x = 0;
        tframe.origin.x = CGRectGetMaxX(preView.frame)+tframe.origin.x;
        sview.frame = tframe;
        preView = sview;
        
        [mainview addSubview:sview];
    }
    
    mainview.frame = CGRectMake(viewX, viewY, CGRectGetMaxX(preView.frame), maxH);
    if(align==1)    //居中对齐
    {
        for(int i=0;i<subView.count;i++)
        {
            UIView *child = [subView objectAtIndex:i];
            child.center = CGPointMake(child.center.x, maxH/2);
        }
    }
    if(align==2)    //下部对齐
    {
        for(int i=0;i<subView.count;i++)
        {
            UIView *child = [subView objectAtIndex:i];
            child.center = CGPointMake(child.center.x, maxH-child.frame.size.height/2);
        }
    }
    
    
    return mainview;
}

+ (UIView *)fitToRight:(UIView *)parent childs:(NSArray *)childs align:(int)align isHor:(BOOL)isHor
{
    if(childs.count<=0)
        return nil;
    UIView *firstView = [childs objectAtIndex:0];
    if(![firstView isKindOfClass:[UIView class]])
        return nil;
    
    CGFloat x = firstView.frame.origin.x;
    CGFloat y = firstView.frame.origin.y;
    UIView *subView;
    if(isHor)
    {
        subView = [self gainHorAutoView:childs viewX:x viewY:y align:align];
    }
    else
    {
        subView = [self gainVerAutoView:childs viewX:x viewY:y align:align];
    }
    
    CGRect iframe = subView.frame;
    iframe.origin.x = parent.frame.size.width - x - iframe.size.width;
    subView.frame = iframe;
    
    [parent addSubview:subView];
    return subView;
}

/*调整自动view到父类，
 看第一个子类View的x和y来控制内部view在父类的位置(如果x==0横向居中，y==0竖向居中)
 
 isHor：YES横向(内部view的align 0：上部对齐 1：居中 2：下部对齐)  NO竖向(align 0：左对齐 1：居中 2：右对齐)
 */
+ (UIView *)fitToCenter:(UIView *)parent childs:(NSArray *)childs subAlign:(int)subAlign isHor:(BOOL)isHor
{
    if(childs.count<=0)
        return nil;
    UIView *firstView = [childs objectAtIndex:0];
    if(![firstView isKindOfClass:[UIView class]])
        return nil;
    
    CGFloat x = firstView.frame.origin.x;
    CGFloat y = firstView.frame.origin.y;
    UIView *subView;
    if(isHor)
    {
        subView = [self gainHorAutoView:childs viewX:firstView.frame.origin.x viewY:firstView.frame.origin.y align:subAlign];
    }
    else
    {
        subView = [self gainVerAutoView:childs viewX:firstView.frame.origin.x viewY:firstView.frame.origin.y align:subAlign];
    }
    
    if(x==0) //横向居中
    {
        CGPoint center = subView.center;
        center.x = parent.frame.size.width/2;
        subView.center = center;
    }
    if(y==0) //竖向居中
    {
        CGPoint center = subView.center;
        center.y = parent.frame.size.height/2;
        subView.center = center;
    }
    [parent addSubview:subView];
    return subView;
}

+(UILabel *)getAutoLab:(CGRect)frame text:(NSString *)text font:(UIFont *)font color:(UIColor *)color
{
    UILabel *labelPrice=[[UILabel alloc] initWithFrame:frame];
    if(color)
        labelPrice.textColor = color;
    labelPrice.font = font;
    labelPrice.lineBreakMode = NSLineBreakByWordWrapping;
    labelPrice.numberOfLines = 0;
    labelPrice.text=text;
    [labelPrice sizeToFit];
    
    return labelPrice;
}

+ (void)setFontSizeFitWidth:(UILabel *)lab
{
    if(lab.numberOfLines==1&&lab.frame.size.width>10)
        lab.adjustsFontSizeToFitWidth = YES;
    else
        [lab sizeToFit];
}

//自动调整字体大小来设配大小，宽高自设配，当宽大于给的宽度，就通过调整字体大小，而不是换行
+ (UILabel *)getAutoFontLab:(CGRect)frame text:(NSString *)text font:(UIFont *)font
{
    UILabel *lab = [[UILabel alloc] initWithFrame:frame];
    lab.text = text;
    lab.font = font;
    
    CGFloat w = frame.size.width;
    
    [lab sizeToFit];
    
    if(w<=10)   //太过小的不考虑
        return lab;
    
    if(w<lab.frame.size.width)
    {
        CGRect iframe = lab.frame;
        iframe.size.width = w;
        lab.frame = iframe;
        
        lab.adjustsFontSizeToFitWidth = YES;
    }
    
    //    //对循环次数的控制
    //    int num = 8;
    //    while (lab.frame.size.width>w)
    //    {
    //        UIFontDescriptor *ctfFont = lab.font.fontDescriptor;
    //        NSNumber *fontSize = [ctfFont objectForKey:@"NSFontSizeAttribute"];
    //        int size = [fontSize intValue]-1;
    //        //调整字体大小
    //        lab.font = [UIFont fontWithName:font.fontName size:size];
    //
    //        [lab sizeToFit];
    //
    //        if(--num==0)
    //            break;      //如果循环超过控制次数，直接返回
    //    }
    
    return lab;
    
}

+ (NSString *)mergeStr:(int)num,...
{
    NSMutableString *mulStr = [[NSMutableString alloc] init];
    for(int i=0;i<num;i++)
    {
        [mulStr appendString:@"%@"];
    }
    va_list args;
    va_start(args, num);
    
    NSString *contentStr = [[NSString alloc] initWithFormat:mulStr arguments:args];
    
    return contentStr;
}

//获取当前的UIViewController
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
