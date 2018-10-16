//
//  CommonFun.h
//  SummaryTest
//
//  Created by  Tmac on 2017/6/29.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonFun : NSObject



/**
 属性字符串拼接
 
 @param val 第一个字符串
 @param valAttr 字体大小和色值的数组 直接用通用写法 [UIFont systemFontOfSize:20]
 @param unit 第二字符串
 @param unitAttr 字体大小和色值的数组
 @return 字符串
 */
+ (NSAttributedString *)gainSimpleAttrStr:(NSString *)val valAttr:(NSArray *)valAttr unit:(NSString *)unit unitAttr:(NSArray *)unitAttr;
//属性字符串拼接，正常写法，{NSFontAttributeName:[UIFont systemFontOfSize:42],NSForegroundColorAttributeName:RGB(151, 152, 153)
+ (NSAttributedString *)gainAttrStr:(NSString *)val valAttr:(NSDictionary *)valAttr unit:(NSString *)unit unitAttr:(NSDictionary *)unitAttr;

//竖向自动布局view， align 0：左对齐 1：居中 2：右对齐
+ (UIView *)gainVerAutoView:(NSArray *)subView viewX:(CGFloat)viewX viewY:(CGFloat)viewY align:(int)align;
//横向自动布局view， align 0：上部对齐 1：居中 2：下部对齐
+ (UIView *)gainHorAutoView:(NSArray *)subView viewX:(CGFloat)viewX viewY:(CGFloat)viewY align:(int)align;

//距离右边距的控件布局，距离右边的有时候不好控制
//看第一个子类View的x和y来控制内部view在父类的位置，（注意）其中的x的相对父类右边距的距离
+ (UIView *)fitToRight:(UIView *)parent childs:(NSArray *)childs align:(int)align isHor:(BOOL)isHor;
/*调整自动view到父类，
 看第一个子类View的x和y来控制内部view在父类的位置(如果x==0横向居中，y==0竖向居中)
 
 isHor：YES横向(内部view的align 0：上部对齐 1：居中 2：下部对齐)  NO竖向(align 0：左对齐 1：居中 2：右对齐)
 */
+ (UIView *)fitToCenter:(UIView *)parent childs:(NSArray *)childs subAlign:(int)subAlign isHor:(BOOL)isHor;

//获取自动适配的lab
+ (UILabel *)getAutoLab:(CGRect)frame text:(NSString *)text font:(UIFont *)font color:(UIColor *)color;
//自动调整字体大小来设配大小，宽高自设配，当宽大于给的宽度，就通过调整字体大小，而不是换行
+ (UILabel *)getAutoFontLab:(CGRect)frame text:(NSString *)text font:(UIFont *)font;
//合并字符串
+ (NSString *)mergeStr:(int)num,...;

/*
*  传入point，返回point.x对应的字节数距离
*  比如说，一个view里面有个UIlable(labView)，UIlable里面含有带有属性的文字。当点击了lab，本来只能知道其中的point，现在要把这个point转为点击了文字哪个范围，即是点击文字的哪一个字节
*  @param point 点击事件相对于view的point
*  @param textRect labView相对于view的rect
@param labView labView
*  @return 点击文字的哪一个字节
*/
+ (CFIndex)characterIndexAtPoint:(CGPoint)point textRect:(CGRect)textRect labView:(UILabel *)labView;

//最后一次执行这函数的时间与上一次的时间差，返回时间戳，以秒为毫秒为单位
+ (UInt64)runGapTime;

//获取当前的UIViewController
+ (UIViewController *)getCurrentVC;
@end
