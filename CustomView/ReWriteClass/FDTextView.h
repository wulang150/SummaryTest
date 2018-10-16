//
//  FDTextView.h
//  SimpleTest
//
//  Created by  Tmac on 16/8/26.
//  Copyright © 2016年 Tmac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FDTextView;

@protocol FDTextViewDelegate <NSObject, UIScrollViewDelegate>

@optional

- (BOOL)FDTextViewShouldBeginEditing:(FDTextView *)textView ;
- (BOOL)FDTextViewShouldEndEditing:(FDTextView *)textView;

- (void)FDTextViewDidBeginEditing:(FDTextView *)textView;
- (void)FDTextViewDidEndEditing:(FDTextView *)textView;

- (BOOL)FDTextView:(FDTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)FDTextViewDidChange:(FDTextView *)textView;

//可输入的剩余字符数
- (void)FDTextView:(FDTextView *)textView maxNumLeave:(long)num;
@end

@interface FDTextView : UITextView

@property (nonatomic,strong) UILabel *placeholderView;
@property (nonatomic,strong) NSString *placeholder;
@property (nonatomic,weak) UIView *parentView;
@property (nonatomic,assign) int MaxNum;                //最大限制字符数量
@property (nonatomic,assign) BOOL isOneLine;            //是否只有一行
@property (nonatomic,assign) BOOL isAllowEmotion;       //是否支持表情
@property (nullable,nonatomic,weak) id<FDTextViewDelegate> FDdelegate;

//是否自动遮挡上移 superView：自动上移时候，移动的view，如果设置为空，默认是整个window上移
- (void)isAutoUp:(BOOL)isAutoUp superView:(UIView *)superView;
//开启自适应大小模式 mx：最大的宽度 my：最大的高度 大于或等于最大，都不会再改变
//如果默认设置的宽度大于mx，那么宽度不变，高度随输入换行变高
- (void)startAdjustWithMX:(NSInteger)mx MY:(NSInteger)my;
- (void)endAdjust;
@end
