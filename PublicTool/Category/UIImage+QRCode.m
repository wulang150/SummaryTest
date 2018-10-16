//
//  UIImage+QRCode.m
//  QRTest
//
//  Created by Janson on 17/1/6.
//  Copyright © 2017年 Janson. All rights reserved.
//

#import "UIImage+QRCode.h"

@implementation UIImage (QRCode)

// 装载二维码的 imageView 最好以白色为主色调 
+ (UIImage *)imageOfDefaultQRFromURL: (NSString *)networkAddress
                         insertImage: (UIImage *)insertImage
{
    return [self imageOfQRFromURL:networkAddress codeSize:0 red:0.0f green:0.0f blue:0.0f insertImage:insertImage roundRadius:20];
}


#pragma mark - public
/*!
 * @function imageOfQRFromURL: codeSize: red: green: blue: insertImage: roundRadius:
 *
 * @abstract
 * 通过链接地址生成二维码图片以及设置二维码宽度和颜色，在二维码中间插入圆角图片
 */
+ (UIImage *)imageOfQRFromURL: (NSString *)networkAddress
                     codeSize: (CGFloat)codeSize            // 参数可忽略
                          red: (NSUInteger)red
                        green: (NSUInteger)green
                         blue: (NSUInteger)blue
                  insertImage: (UIImage *)insertImage
                  roundRadius: (CGFloat)roundRadius
{
    if (!networkAddress || (NSNull *)networkAddress == [NSNull null]) { return nil; }
    /** 颜色不可以太接近白色*/
    NSUInteger rgb = (red << 16) + (green << 8) + blue;
    NSAssert((rgb & 0xffffff00) <= 0xd0d0d000, @"The color of QR code is two close to white color than it will diffculty to scan");
    codeSize = [self validateCodeSize: codeSize];
    
    CIImage * originImage = [self createQRFromAddress: networkAddress];
    UIImage * progressImage = [self excludeFuzzyImageFromCIImage: originImage size: codeSize];       //到了这里二维码已经可以进行扫描了
    
    UIImage * effectiveImage = [self imageFillBlackColorAndTransparent: progressImage red: red green: green blue: blue];  //进行颜色渲染后的二维码
    
    return [self imageInsertedImage: effectiveImage insertImage: insertImage radius: roundRadius];
}



#pragma mark - private

/*!
 * @function ProviderReleaseData
 *
 * @abstract
 * 回调函数
 */
void ProviderReleaseData(void * info, const void * data, size_t size) {
    free((void *)data);
}

/**
 *  控制二维码尺寸在合适的范围内
 */
+ (CGFloat)validateCodeSize: (CGFloat)codeSize
{
    codeSize = MAX(200, codeSize);
    codeSize = MIN(CGRectGetWidth([UIScreen mainScreen].bounds) - 100, codeSize);
    return codeSize;
}

/*!
 * @function createQRFromAddress:
 *
 * @abstract
 * 通过链接地址生成原生的二维码图（由于大小不好控制，需要加工）
 */
+ (CIImage *)createQRFromAddress: (NSString *)networkAddress
{
    NSData * stringData = [networkAddress dataUsingEncoding: NSUTF8StringEncoding];
    
    CIFilter * qrFilter = [CIFilter filterWithName: @"CIQRCodeGenerator"];
    
    [qrFilter setValue: stringData forKey: @"InputMessage"];
    [qrFilter setValue: @"H" forKey: @"inputCorrectionLevel"];
    
    return qrFilter.outputImage;
}

/*!
 * @function createNonInterpolatedImageFromCIImage: size:
 *
 * @abstract
 * 对生成的原始二维码进行加工，返回大小适合的黑白二维码图。因此还需要进行颜色填充
 */
+ (UIImage *)excludeFuzzyImageFromCIImage: (CIImage *)image size: (CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size / CGRectGetWidth(extent), size / CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    
    //创建灰度色调空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext * context = [CIContext contextWithOptions: nil];
    CGImageRef bitmapImage = [context createCGImage: image fromRect: extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage: scaledImage];
}

/*!
 * @function imageFillBlackColorToTransparent: red: green: blue:
 *
 * @abstract
 * 对加工过的黑白二维码进行颜色填充，并转换成透明背景
 */
+ (UIImage *)imageFillBlackColorAndTransparent: (UIImage *)image red: (NSUInteger)red green: (NSUInteger)green blue: (NSUInteger)blue
{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t * rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
    
    //创建RGB色调空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, (CGRect){(CGPointZero), (image.size)}, image.CGImage);
    
    //遍历像素
    int pixelNumber = imageHeight * imageWidth;
    [self fillWhiteToTransparentOnPixel: rgbImageBuf pixelNum: pixelNumber red: red green: green blue: blue];
    
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace, kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider, NULL, true, kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    UIImage * resultImage = [UIImage imageWithCGImage: imageRef];
    
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    return resultImage;
}

/*!
 * @function fillWhiteToTransparentOnPixel: pixelNum: red: green: blue:
 *
 * @abstract
 * 遍历所有像素点，将白色区域填充为透明色
 */
+ (void)fillWhiteToTransparentOnPixel: (uint32_t *)rgbImageBuf pixelNum: (int)pixelNum red: (NSUInteger)red green: (NSUInteger)green blue: (NSUInteger)blue
{
    uint32_t * pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {
        if ((*pCurPtr & 0xffffff00) < 0x99999900)
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t * ptr = (uint8_t *)pCurPtr;
            ptr[3] = red;
            ptr[2] = green;
            ptr[1] = blue;
        }
        else {
            //将白色变成透明色
            uint8_t * ptr = (uint8_t *)pCurPtr;
            ptr[0] = 0;
        }
    }
}

/*!
 * @function imageInsertedImage: insertImage:
 *
 * @abstract
 * 在渲染后的二维码图上进行图片插入，如插入图为空，直接返回二维码图
 */
+ (UIImage *)imageInsertedImage: (UIImage *)originImage insertImage: (UIImage *)insertImage radius: (CGFloat)radius
{
    if (!insertImage) { return originImage; }
    
    insertImage = [UIImage imageOfRoundRectWithImage: insertImage size: insertImage.size radius: radius];
    
    // 生成白色底图
    UIImage * whiteBG = [self ImageWithFillColor:[UIColor whiteColor]];
    whiteBG = [UIImage imageOfRoundRectWithImage: whiteBG size: whiteBG.size radius: radius];
    
    //白色边缘宽度
    const CGFloat whiteSize = 3.0f; // 露出边框
    CGSize brinkSize = CGSizeMake(originImage.size.width / 3, originImage.size.height / 3);
    CGFloat brinkX = (originImage.size.width - brinkSize.width) * 0.5;
    CGFloat brinkY = (originImage.size.height - brinkSize.height) * 0.5;
    
    CGSize imageSize = CGSizeMake(brinkSize.width - 2 * whiteSize, brinkSize.height - 2 * whiteSize);
    CGFloat imageX = brinkX + whiteSize;
    CGFloat imageY = brinkY + whiteSize;
    
// 不带Options参数会模糊 类似textLayer15521054559
    UIGraphicsBeginImageContextWithOptions(originImage.size, NO,[UIScreen mainScreen].scale);
    [originImage drawInRect: (CGRect){ 0, 0, (originImage.size) }];
    [whiteBG drawInRect: (CGRect){ brinkX, brinkY, (brinkSize) }];
    [insertImage drawInRect: (CGRect){ imageX, imageY, (imageSize) }];
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    return resultImage;
}


// 纯色图片
+ (UIImage *)ImageWithFillColor:(UIColor *)backColor
{
    CGSize imageSize =CGSizeMake(100,100);
    UIGraphicsBeginImageContextWithOptions(imageSize,0, [UIScreen mainScreen].scale);
    [backColor set];
    UIRectFill(CGRectMake(0,0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pressedColorImg;
}

/**********************  圆角设置   ************************/

#pragma mark - public
/*!
 * @function imageOfRoundRectWithImage: radius:
 *
 * @abstract
 * 给传入的图片设置圆角后返回圆角图片
 */
+ (UIImage *)imageOfRoundRectWithImage: (UIImage *)image size: (CGSize)size radius: (CGFloat)radius
{
    if (!image || (NSNull *)image == [NSNull null]) { return nil; }
    
    const CGFloat width = size.width;
    const CGFloat height = size.height;
    
    radius = MAX(5.f, radius);
    radius = MIN(50.f, radius);        // 最大 50% 的圆角，也就是圆形
    radius = radius/100.0 * size.width;
    
    UIImage * img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    //绘制圆角
    CGContextBeginPath(context);
    addRoundRectToPath(context, rect, radius, img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage: imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
    
}

#pragma mark - private
/**
 *  给上下文添加圆角蒙版
 */
void addRoundRectToPath(CGContextRef context, CGRect rect, float radius, CGImageRef image)
{
    float width, height;
    if (radius == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    width = CGRectGetWidth(rect);
    height = CGRectGetHeight(rect);
    
    //裁剪路径
    CGContextMoveToPoint(context, width, height / 2);
    CGContextAddArcToPoint(context, width, height, width / 2, height, radius);
    CGContextAddArcToPoint(context, 0, height, 0, height / 2, radius);
    CGContextAddArcToPoint(context, 0, 0, width / 2, 0, radius);
    CGContextAddArcToPoint(context, width, 0, width, height / 2, radius);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    CGContextRestoreGState(context);
}



@end
