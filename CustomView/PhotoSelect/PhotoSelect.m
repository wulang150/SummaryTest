//
//  PhotoSelect.m
//  Runner
//
//  Created by  Tmac on 16/5/12.
//  Copyright © 2016年 Janson. All rights reserved.
//

#import "PhotoSelect.h"

@interface PhotoSelect()
{
    UIImage *srcImg;
    int wSelect;        //选择框的宽度
    double xlocation;   //选取图片的X坐标
    double ylocation;
    
    UIImageView *imgView;
    
    UIView *selectView;
    
    CGRect oldFrame;    //保存图片原来的大小
    CGRect largeFrame;  //确定图片放大最大的程度
    
    BOOL isChange;
    
    int type;
}
@end

@implementation PhotoSelect

- (id)initWithImage:(UIImage *)img
{
    if(self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)])
    {
        wSelect = SCREEN_WIDTH - 20*2;
        xlocation = 0;
        ylocation = 0;
        type = PhotoSelect_type1;
        srcImg = img;
        [self createView];
    }
    
    return self;
}

- (id)initWithImage:(UIImage *)img type:(int)_type
{
    if(self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)])
    {
        wSelect = SCREEN_WIDTH - 20*2;
        xlocation = 0;
        ylocation = 0;
        type = _type;
        srcImg = img;
        [self createView];
    }
    
    return self;
}

- (void)createView
{
    isChange = NO;
    self.backgroundColor = [UIColor whiteColor];
    
    imgView = [self getImage];
    [self addSubview:imgView];
    
    selectView = [self getSelectView:CGRectMake((SCREEN_WIDTH-wSelect)/2, 64+(SCREEN_HEIGHT-64-wSelect)/2, wSelect, wSelect)];
    [self addSubview:selectView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 1;
    if(type==PhotoSelect_type1)
    {
        [selectView addGestureRecognizer:panGesture];
    }
    else if(type==PhotoSelect_type2)
    {
        selectView.alpha = 0;
        CAShapeLayer *shape = [self getSelectLayer:selectView.frame];
        [self.layer addSublayer:shape];
        
        // 缩放手势
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
        [imgView addGestureRecognizer:pinchGestureRecognizer];
        [imgView addGestureRecognizer:panGesture];
    }
    
    UIView *headView = [self getHeadView];
    [self addSubview:headView];
    
    UIView *view = [[UIApplication sharedApplication].delegate window];
    [view addSubview:self];
}

- (UIImageView *)getImage
{
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tmpView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-tmpView.frame.size.height)];
//    imageView.image = srcImg;
    
    UIImage *tmpImg = [self fixOrientation:srcImg];
    
    double w = tmpImg.size.width,h = tmpImg.size.height;
    //根据比例缩放图片
    if(w>SCREEN_WIDTH)
    {
        h = h*SCREEN_WIDTH/w;
        w = SCREEN_WIDTH;
    }
    if(h>SCREEN_HEIGHT-64)
    {
        w = w*(SCREEN_HEIGHT-64)/h;
        h = SCREEN_HEIGHT - 64;
    }
    
    srcImg = tmpImg;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-w)/2, 64+(SCREEN_HEIGHT-64-h)/2, w, h)];
    imageView.image = srcImg;
    imageView.clipsToBounds = YES;
    [imageView setUserInteractionEnabled:YES];
    [imageView setMultipleTouchEnabled:YES];
    //NSLog(@"w = %f h = %f",w,h);

    oldFrame = imageView.frame;
    largeFrame = CGRectMake(imgView.frame.origin.x-imageView.frame.size.width/2, imageView.frame.origin.y-imageView.frame.size.height/2, imageView.frame.size.width*2, imageView.frame.size.height*2);
    wSelect = h>w?w-4:h-4;
    
    return imageView;
}

//调整图片，能正确显示
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    
    
    if (aImage==nil || !aImage) {
        
        return nil;
        
    }
    
    
    
    // No-op if the orientation is already correct
    
    if (aImage.imageOrientation == UIImageOrientationUp) return aImage;
    
    
    
    // We need to calculate the proper transformation to make the image upright.
    
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    UIImageOrientation orientation=aImage.imageOrientation;
    
    int orientation_=orientation;
    
    switch (orientation_) {
            
        case UIImageOrientationDown:
            
        case UIImageOrientationDownMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            
            transform = CGAffineTransformRotate(transform, M_PI);
            
            break;
            
            
            
        case UIImageOrientationLeft:
            
        case UIImageOrientationLeftMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            
            transform = CGAffineTransformRotate(transform, M_PI_2);
            
            break;
            
            
            
        case UIImageOrientationRight:
            
        case UIImageOrientationRightMirrored:
            
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            
            break;
            
    }
    
    
    
    switch (orientation_) {
            
        case UIImageOrientationUpMirrored:{
            
        }
            
        case UIImageOrientationDownMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            
            transform = CGAffineTransformScale(transform, -1, 1);
            
            break;
            
            
            
        case UIImageOrientationLeftMirrored:
            
        case UIImageOrientationRightMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            
            transform = CGAffineTransformScale(transform, -1, 1);
            
            break;
            
    }
    
    
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    
    // calculated above.
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             
                                             CGImageGetColorSpace(aImage.CGImage),
                                             
                                             CGImageGetBitmapInfo(aImage.CGImage));
    
    CGContextConcatCTM(ctx, transform);
    
    
    
    switch (aImage.imageOrientation) {
            
        case UIImageOrientationLeft:
            
        case UIImageOrientationLeftMirrored:
            
        case UIImageOrientationRight:
            
        case UIImageOrientationRightMirrored:
            
            // Grr...
            
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            
            break;
            
        default:
            
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            
            break;
            
    }
    
    
    
    // And now we just create a new UIImage from the drawing context
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    
    CGContextRelease(ctx);
    
    CGImageRelease(cgimg);
    
    aImage=img;
    
    img=nil;
    
    return aImage;
    
}
//头部的view
- (UIView *)getHeadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    view.backgroundColor = [UIColor blueColor];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, SCREEN_WIDTH, 40)];
    titleLab.text = @"选取照片";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:18];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLab];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    btn.tag = 1;
    btn.frame = CGRectMake(SCREEN_WIDTH-60, (40-30)/2+24, 60, 30);
    [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    cancleBtn.tag = 2;
    cancleBtn.frame = CGRectMake(0, (40-30)/2+24, 60, 30);
    [cancleBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancleBtn];
    return view;
}

//选择框
- (UIView *)getSelectView:(CGRect)frame
{
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-wSelect)/2, 64+(SCREEN_HEIGHT-wSelect-64)/2, wSelect, wSelect)];
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.layer.borderWidth = 2;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.backgroundColor = [UIColor clearColor];
    
    xlocation = view.frame.origin.x - imgView.frame.origin.x;
    ylocation = view.frame.origin.y - imgView.frame.origin.y;
    
    return view;
}
//移动图片的情况下的选择框
- (CAShapeLayer *)getSelectLayer:(CGRect)frame
{
    CAShapeLayer *shape = [CAShapeLayer new];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(frame.origin.x, frame.origin.y)];
    [path addLineToPoint:CGPointMake(frame.origin.x+frame.size.width, frame.origin.y)];
    [path addLineToPoint:CGPointMake(frame.origin.x+frame.size.width, frame.origin.y+frame.size.height)];
    [path addLineToPoint:CGPointMake(frame.origin.x, frame.origin.y+frame.size.height)];
    [path addLineToPoint:CGPointMake(frame.origin.x, frame.origin.y)];
    shape.path = path.CGPath;
    shape.strokeColor = [UIColor whiteColor].CGColor;
    shape.lineWidth = 2;
    shape.fillColor = [UIColor clearColor].CGColor;
    
    return shape;
}

//根据选取框来截取图片
- (UIImage *)getScareImage
{
    xlocation = selectView.frame.origin.x - imgView.frame.origin.x;
    ylocation = selectView.frame.origin.y - imgView.frame.origin.y;
    CGRect rect = CGRectMake(xlocation, ylocation, wSelect, wSelect);
    UIImage *img = [PublicFunction getImage:srcImg width:imgView.frame.size.width height:imgView.frame.size.height];
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(img.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}
//按钮，确定后的回调
- (void)buttonAction:(UIButton *)sender
{
    if(sender.tag==1)
    {
        UIImage *retImg = [self getScareImage];
        if(self.callBack)
            self.callBack(retImg);
    }
    
    [self removeFromSuperview];
}

//重新调整选择框的位置，使他只能在图片内部移动，返回的位置还是根据这个self的
- (CGPoint)locationInImgView:(CGPoint)location
{
    CGPoint point = location;
    //控制只能在图片内移动
    double minX = imgView.frame.origin.x+wSelect/2;
    double maxX = CGRectGetMaxX(imgView.frame)-wSelect/2;
    double minY = imgView.frame.origin.y+wSelect/2;
    double maxY = CGRectGetMaxY(imgView.frame)-wSelect/2;
    
    //移动图片
    if(type==PhotoSelect_type2)
    {
        minX = CGRectGetMaxX(selectView.frame)-imgView.frame.size.width/2;
        maxX = selectView.frame.origin.x+imgView.frame.size.width/2;
        minY = CGRectGetMaxY(selectView.frame)-imgView.frame.size.height/2;
        maxY = selectView.frame.origin.y+imgView.frame.size.height/2;
    }
    
    if(location.x<minX)
    {
        point.x = minX;
    }
    if(location.x>maxX)
    {
        point.x = maxX;
    }
    if(location.y<minY)
    {
        point.y = minY;
    }
    if(location.y>maxY)
    {
        point.y = maxY;
    }
    
    return point;
}

//拖动事件
- (void)panAction:(UIPanGestureRecognizer *)sender
{
    //CGPoint location = [sender locationInView:sender.view.superview];
    
    CGPoint tranPoint = [sender translationInView:self];
    CGFloat x = sender.view.center.x + tranPoint.x;
    CGFloat y = sender.view.center.y + tranPoint.y;
    
    if (sender.state != UIGestureRecognizerStateEnded && sender.state != UIGestureRecognizerStateFailed){
        //通过使用 locationInView 这个方法,来获取到手势的坐标
        
        sender.view.center = [self locationInImgView:CGPointMake(x, y)];
    }
    else if(sender.state == UIGestureRecognizerStateEnded)
    {
        //NSLog(@"~~~~x=%f  y=%f",location.x,location.y);
        
        xlocation = selectView.frame.origin.x - imgView.frame.origin.x;
        ylocation = selectView.frame.origin.y - imgView.frame.origin.y;
        
        isChange = YES;
    }
    
    [sender setTranslation:CGPointZero inView:self];
}

//缩放手势
- (void)pinchAction:(UIPinchGestureRecognizer *)sender
{
    UIView *view = sender.view;
    if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, sender.scale, sender.scale);
        if (imgView.frame.size.width < oldFrame.size.width) {
            
            if(isChange)
            {
                oldFrame.origin = imgView.frame.origin;
                isChange = NO;
            }
            imgView.frame = oldFrame;
            //让图片无法缩得比原图小
        }
        if (imgView.frame.size.width > oldFrame.size.width*2) {
    
            if(isChange)
            {
                largeFrame.origin = imgView.frame.origin;
                isChange = NO;
            }
            
            imgView.frame = largeFrame;
        }
        sender.scale = 1;
    }
}
@end
