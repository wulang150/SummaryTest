//
//  PageSelectView.m
//  SummaryTest
//
//  Created by  Tmac on 2017/7/5.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "PageSelectView.h"
#import "CommonFun.h"

@interface PageSelectView()
{
    NSMutableArray *circleArr;
    
    CGFloat ly;     //距离父类的y
    
    UIView *centerView;
}
@end

@implementation PageSelectView

- (id)initWithCenter:(CGFloat)y pageCount:(NSInteger)pageCount
{
    if(self = [super init])
    {
        ly = y;
        _pageCount = pageCount;
        _curPage = 0;
        _onColor = [UIColor grayColor];
        _offColor = [UIColor lightGrayColor];
        _radius = 8;
        _spaceLeg = 14;
        circleArr = [[NSMutableArray alloc] initWithCapacity:10];
        
        _imgSize = CGSizeMake(_radius*4, _radius*4);
    }
    
    return self;
}

- (void)updateView
{
    [centerView removeFromSuperview];
    [circleArr removeAllObjects];
    
    for(NSInteger i=0;i<_pageCount;i++)
    {
        CGFloat x = 0;
        if(i!=0)
            x = _spaceLeg;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, ly, _radius*2, _radius*2)];
        imgView.layer.cornerRadius = _radius;
        imgView.backgroundColor = _offColor;
        if(i==_curPage)
        {
            if(_selectImg)      //先调整高度
            {
                imgView.backgroundColor = [UIColor clearColor];
                imgView.layer.cornerRadius = 0;
                imgView.image = _selectImg;
                CGRect iframe = imgView.frame;
                iframe.size.height = _imgSize.height;
                imgView.frame = iframe;
            }
            else
                imgView.backgroundColor = _onColor;
        }
        [circleArr addObject:imgView];
    }
    
    centerView = [CommonFun gainHorAutoView:circleArr viewX:0 viewY:0 align:1];
    if(_selectImg&&_curPage<circleArr.count)    //调整最后的中心位置和宽度
    {
        UIImageView *selecedView = [circleArr objectAtIndex:_curPage];
        CGPoint centerPoint = selecedView.center;
        CGRect iframe = selecedView.frame;
        iframe.size = CGSizeMake(_imgSize.width, _imgSize.height);
        selecedView.frame = iframe;
        selecedView.center = centerPoint;
        
    }
    
    //横向居中于父类
    self.frame = CGRectMake((SCREEN_WIDTH-centerView.bounds.size.width)/2, ly, centerView.bounds.size.width, centerView.bounds.size.height);
    [self addSubview:centerView];
}

@end
