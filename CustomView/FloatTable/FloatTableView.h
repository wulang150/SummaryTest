//
//  FloatTableView.h
//  Runner
//
//  Created by  Tmac on 16/1/14.
//  Copyright © 2016年 Janson. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FloatTableView;

@protocol FloatTableViewDelegate <NSObject>

@optional

- (void)floatTableView:(FloatTableView *)floatTableView didSelectedRowAtIndex:(NSInteger)Index;

@end

@protocol FloatTableViewDataSource <NSObject>

@required
- (NSString *)floatTableView:(FloatTableView *)floatTableView stringAtIndex:(NSInteger)Index;
- (NSInteger)numOfFloatTableView:(FloatTableView *)floatTableView;
@optional
- (UIImage *)floatTableView:(FloatTableView *)floatTableView imageAtIndex:(NSInteger)Index;
@end

@interface FloatTableView : UIView

@property (nonatomic,weak) id<FloatTableViewDelegate> delegate;
@property (nonatomic,weak) id<FloatTableViewDataSource> dataSource;

/**
 *
 建议宽度大于160
 *  @param frame frame
 *  @param _self 父类控制器
 *         hasImg 是否有左侧的图片
 *  @return return value description
 */
- (id)initWithFrame:(CGRect)frame superView:(UIViewController *)_self hasImg:(BOOL)hasImg;

- (void)setBgColor:(UIColor *)color;

- (void)reloadData;
- (void)show;
- (void)hiding;

//如果已经show了，再调用就hiding，已经hiding，调用就show
- (void)showOrHiding;
@end
