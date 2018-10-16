//
//  SubLayer.m
//  SummaryTest
//
//  Created by  Tmac on 2018/6/8.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "SubLayer.h"

@implementation SubLayer


//- (void)display
//{
////    CGSize size = self.bounds.size;
////    BOOL opaque = self.opaque;
////    CGFloat scale = self.contentsScale;
//
//    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, self.contentsScale);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    if (context) {
//        CGSize size = self.bounds.size;
//        size.width *= self.contentsScale;
//        size.height *= self.contentsScale;
//        CGContextSaveGState(context); {
//            if (!self.backgroundColor || CGColorGetAlpha(self.backgroundColor) < 1) {
//                CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
//                CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
//                CGContextFillPath(context);
//            }
//            if (self.backgroundColor) {
//                CGContextSetFillColorWithColor(context, self.backgroundColor);
//                CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
//                CGContextFillPath(context);
//            }
//        } CGContextRestoreGState(context);
//    }
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    self.contents = (__bridge id)(image.CGImage);
//}

//估计是在这里弄好了CGContextRef，再调用drawInContext
- (void)display
{
    NSLog(@">>>>>>>>>>>>display");
    [super display];
}

- (void)drawInContext:(CGContextRef)ctx
{
    NSLog(@">>>>>>>>>>>>drawInContext");
    CGContextAddEllipseInRect(ctx, CGRectMake(0,0,100,200));
    CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);
    CGContextFillPath(ctx);
    
    [super drawInContext:ctx];
}
@end
