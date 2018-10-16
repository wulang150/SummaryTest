//
//  TKAlertView.m
//  ProBand
//
//  Created by star.zxc on 15/11/6.
//  Copyright © 2015年 DONGWANG. All rights reserved.
//

#import "TKAlertView.h"

@implementation TKAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id) init{
    if(!(self = [super initWithFrame:CGRectMake(0, 0, 100, 100)])) return nil;
    _messageRect = CGRectInset(self.bounds, 10, 10);
    self.backgroundColor = [UIColor clearColor];
    return self;
    
}

- (void) _drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)radius{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    CGRect rrect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height );
    
    CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
}
- (void) drawRect:(CGRect)rect{
    [[UIColor colorWithWhite:0 alpha:0.6] set];
    [self _drawRoundRectangleInRect:rect withRadius:10];
    [[UIColor whiteColor] set];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName: paragraphStyle};
    [_text drawInRect:_messageRect withAttributes:attributes];
    
    //    [_text drawInRect:_messageRect
    //			 withFont:[UIFont boldSystemFontOfSize:14]
    //		 lineBreakMode:NSLineBreakByWordWrapping
    //			alignment:NSTextAlignmentCenter];
    
    
    CGRect r = CGRectZero;
    r.origin.y = 15;
    r.origin.x = (NSInteger)((rect.size.width-_image.size.width)/2);
    r.size = _image.size;
    
    [_image drawInRect:r];
}

#pragma mark Setter Methods
- (void) adjust{
    
    CGSize s = CGSizeMake(0, 0);
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    // 计算文本的大小
    s = [_text boundingRectWithSize:CGSizeMake(160,200) // 用于计算文本绘制时占据的矩形块
                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                         attributes:attribute // 文字的属性
                            context:nil].size;
    
    //         s = [_text sizeWithFont:[UIFont boldSystemFontOfSize:14]
    //                     constrainedToSize:CGSizeMake(160,200)
    //                         lineBreakMode:NSLineBreakByWordWrapping];
    
    
    float imageAdjustment = 0;
    if (_image) {
        imageAdjustment = 7+_image.size.height;
    }
    
    self.bounds = CGRectMake(0, 0, s.width+40, s.height+15+15+imageAdjustment);
    
    _messageRect.size = s;
    _messageRect.size.height += 5;
    _messageRect.origin.x = 20;
    _messageRect.origin.y = 15+imageAdjustment;
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
    
}
- (void) setMessageText:(NSString*)str{
    _text = str;
    [self adjust];
}
- (void) setImage:(UIImage*)img{
    _image = img;
    [self adjust];
}

@end
