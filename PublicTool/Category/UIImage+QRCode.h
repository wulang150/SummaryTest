//
//  UIImage+QRCode.h
//  QRTest
//
//  Created by Janson on 17/1/6.
//  Copyright © 2017年 Janson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QRCode)
/*!
 * 返回默认的中间带头像的二维码
 */
+ (UIImage *)imageOfDefaultQRFromURL: (NSString *)networkAddress
                         insertImage: (UIImage *)insertImage;
/*!
 * 通过链接地址生成二维码图片以及设置二维码宽度和颜色，在二维码中间插入圆角图片
 */
+ (UIImage *)imageOfQRFromURL: (NSString *)networkAddress
                     codeSize: (CGFloat)codeSize
                          red: (NSUInteger)red
                        green: (NSUInteger)green
                         blue: (NSUInteger)blue
                  insertImage: (UIImage *)insertImage
                  roundRadius: (CGFloat)roundRadius;

// 获取纯色图片
+ (UIImage *)ImageWithFillColor:(UIColor *)backColor;

/*!
 * 给传入的图片设置圆角后返回圆角图片
 */
+ (UIImage *)imageOfRoundRectWithImage: (UIImage *)image size: (CGSize)size radius: (CGFloat)radius;

@end
