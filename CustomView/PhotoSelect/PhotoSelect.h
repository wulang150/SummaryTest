//
//  PhotoSelect.h
//  Runner
//
//  Created by  Tmac on 16/5/12.
//  Copyright © 2016年 Janson. All rights reserved.
//

#import <UIKit/UIKit.h>
enum{
    PhotoSelect_type1 = 1,      //只能移动框，并且框只在图片内
    PhotoSelect_type2,          //框固定，移动和缩放图片
};

@interface PhotoSelect : UIView

- (id)initWithImage:(UIImage *)img;

- (id)initWithImage:(UIImage *)img type:(int)type;

@property (nonatomic,strong) void(^callBack)(UIImage *img);
@end
