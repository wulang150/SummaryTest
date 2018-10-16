//
//  BottomSelectView.m
//  SummaryTest
//
//  Created by  Tmac on 2017/7/11.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "BottomSelectView.h"
#import "CommonFun.h"

@interface BottomSelectView()
{
    NSArray *imageArr;
    NSArray *imageSelectedArr;
    NSArray *titleArr;
    UIColor *titleColor;
    UIColor *titleSelectedColor;
    
    NSInteger num;
}
@end

@implementation BottomSelectView

- (id)initWithFrame:(CGRect)frame images:(NSArray *)images selectedImages:(NSArray *)selectedImages
             titles:(NSArray *)titles titleColor:(UIColor *)_titleColor titleSelectedColor:(UIColor *)_titleSelectedColor
{
    if(self = [super initWithFrame:frame])
    {
        imageArr = images;
        imageSelectedArr = selectedImages;
        titleArr = titles;
        titleColor = _titleColor?_titleColor:[UIColor grayColor];
        titleSelectedColor = _titleSelectedColor;
        
        num = titleArr.count>images.count?titleArr.count:images.count;
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    for(UIView *view in self.subviews)
        [view removeFromSuperview];
    
    [self createView];
}

- (void)createView
{
    if(num<=0)
        return;
    
    CGFloat w = self.bounds.size.width/num;
    CGFloat imgW = w*2/5;
    CGFloat imgH = self.bounds.size.height/2;
    imgW = imgH = imgW>imgH?imgH:imgW;
    
    if(_imgH<=0)
        _imgH = imgH;
    if(_imgW<=0)
        _imgW = imgW;
    
    if(!_font)
        _font = [UIFont systemFontOfSize:12];
    NSMutableArray *imageMul = [NSMutableArray new];
    NSMutableArray *titleMul = [NSMutableArray new];
    for(int i = 0;i<num;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.frame = CGRectMake(i*w, 0, w, self.bounds.size.height);
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        //图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _imgW, _imgH)];
        if(i>=imageArr.count)
        {
            imageView.frame = CGRectZero;
        }
        else
        {
            UIImage *image = imageArr[i];
            if([image isKindOfClass:[UIImage class]])
                imageView.image = image;
            else
                imageView.frame = CGRectZero;
        }
        imageView.userInteractionEnabled = NO;
        imageView.clipsToBounds = YES;
        
        //标题
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, 0, 0)];
        titleLab.textColor = titleColor;
        titleLab.font = _font;
        if(i<titleArr.count)
            titleLab.text = [titleArr objectAtIndex:i];
        titleLab.userInteractionEnabled = NO;
        
        UIView *view = [CommonFun fitToCenter:btn childs:@[imageView,titleLab] subAlign:1 isHor:NO];
        view.userInteractionEnabled = NO;
        
        [imageMul addObject:imageView];
        [titleMul addObject:titleLab];
    }
    
    _imageViewArr = [imageMul copy];
    _titleViewArr = [titleMul copy];
}


- (void)buttonAction:(UIButton *)sender
{
    //全部恢复原始状态
    int i = 0;
    for(UIImageView *imageView in _imageViewArr)
    {
        if(i>=imageArr.count)
            break;
        
        UIImage *image = imageArr[i];
        if(![image isKindOfClass:[UIImage class]])
            continue;

        imageView.image = image;
        i++;
    }

    for(UILabel *lab in _titleViewArr)
    {
        lab.textColor = titleColor;
    }
    
    //设置选中的状态
    UIImageView *selectedImageView = [_imageViewArr objectAtIndex:sender.tag];
    UILabel *selectedTitleView = [_titleViewArr objectAtIndex:sender.tag];
    
    if(sender.tag<imageSelectedArr.count)
        selectedImageView.image = imageSelectedArr[sender.tag];
    
    if(titleSelectedColor)
        selectedTitleView.textColor = titleSelectedColor;
    
    if([self.delegate respondsToSelector:@selector(didSelectedBottomSelectView:index:selectedImage:selectedTitle:)])
    {
        [_delegate didSelectedBottomSelectView:self index:sender.tag selectedImage:selectedImageView selectedTitle:selectedTitleView];
    }
}

@end
