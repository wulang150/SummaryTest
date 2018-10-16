//
//  FDTextView.m
//  SimpleTest
//
//  Created by  Tmac on 16/8/26.
//  Copyright © 2016年 Tmac. All rights reserved.
//

#import "FDTextView.h"

@interface FDTextView()
<UITextViewDelegate>
{
    float width,height;
    UIView *bgView;
    int placeFontSize;
    NSInteger MX;
    NSInteger MY;

    CGRect tmpFrame;
    
    BOOL statusW;           //w的状态
    int statusAdjust;       //适配的状态，0：无 1：设配宽度 2：设配高度
    
    NSInteger flag; //控制键盘监听的回调，一般即将显示会调用三次
    
    CGFloat maxHeight;      //键盘的最大高度
    __weak UIView *superView;      //自动上移时候，移动的view，如果设置为空，默认是整个window上移
    CGRect superRect;
}
@end

@implementation FDTextView

- (void) dealloc{
    NSLog(@"FDTextView dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    if(_isOneLine)
//        [self removeObserver:self forKeyPath:@"contentSize"];
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self createView];
    }
    
    return self;
}

- (void)createView
{
    flag = 1;
    statusAdjust = 0;
    tmpFrame = self.frame;
    MX = MY = 0;
    self.delegate = self;
    self.isAllowEmotion = YES;
    width = self.frame.size.width;
    height = self.frame.size.height;
    placeFontSize = 13;
    
    [self addSubview:self.placeholderView];

    //背景模板
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.width), ([UIScreen mainScreen].bounds.size.height))];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.tag = 555;
    bgView.alpha = 0.1;
    
    //点击事件
    UITapGestureRecognizer *singleTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTag)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [bgView addGestureRecognizer:singleTap];
    
}

- (UILabel *)placeholderView
{
    if(!_placeholderView)
    {
        _placeholderView = [[UILabel alloc] initWithFrame:CGRectZero];
        _placeholderView.font = [UIFont systemFontOfSize:placeFontSize];
        _placeholderView.textColor = [UIColor lightGrayColor];
        _placeholderView.userInteractionEnabled = NO;
        _placeholderView.numberOfLines = 0;
    }
    
    return _placeholderView;
}

- (void)bgTag
{
    [self resignFirstResponder];
}

- (void)isAutoUp:(BOOL)isAutoUp superView:(UIView *)_superView
{
    if(isAutoUp)
    {
        superView = _superView;
        superRect = _superView.frame;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    CGRect rect = [placeholder boundingRectWithSize:CGSizeMake(width-12, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:placeFontSize]} context:nil];
    float h = ceilf(rect.size.height);
    
    _placeholderView.frame = CGRectMake(6, (height-h)/2, width-12, h);
    _placeholderView.center = CGPointMake(width/2, height/2);
    _placeholderView.text = placeholder;
}

- (void)setIsOneLine:(BOOL)isOneLine
{
    _isOneLine = isOneLine;
    if(_isOneLine)
    {
        if(!self.font)
            self.font = [UIFont systemFontOfSize:self.bounds.size.height/2];
        self.returnKeyType = UIReturnKeyDone;
//        [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
//        [self observeValueForKeyPath:@"contentSize" ofObject:self change:nil context:nil];
    }
    else
    {
        self.returnKeyType = UIReturnKeyDefault;
    }
}

- (void)setMaxNum:(int)MaxNum
{
    _MaxNum = MaxNum;
}

- (void)startAdjustWithMX:(NSInteger)mx MY:(NSInteger)my
{
    MX = mx;
    MY = my;
    
    statusAdjust = MX>MY?1:2;
 
    if(MX<=self.frame.size.width&&statusAdjust==1)
        statusAdjust = 0;
    if(MY<=self.frame.size.height&&statusAdjust==2)
        statusAdjust = 0;
}
- (void)endAdjust
{
    if(statusAdjust==0)
        return;
    self.frame = tmpFrame;
    self.text = @"";
}

//自适应宽度
- (void)adJustForWidth
{
    if(statusAdjust!=1)
        return;
    CGSize size = CGSizeMake(CGFLOAT_MAX, tmpFrame.size.height);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil];
    CGRect curRect = [self.text boundingRectWithSize:size
                                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                          attributes:dic
                                             context:nil];
    
    UIFontDescriptor *ctfFont = self.font.fontDescriptor;
    NSNumber *fontSize = [ctfFont objectForKey:@"NSFontSizeAttribute"];
    //计算的宽度是文字的宽度，如果也放到这么长的textView中，是会换行的，textView.length=all字.length+一个字长（预留）
    CGFloat w = ceilf(curRect.size.width)+[fontSize floatValue];
    //CGFloat w = ceilf(curRect.size.width);
    statusW = NO;
    if(w<=tmpFrame.size.width)
    {
        CGRect iframe = self.frame;
        iframe.size.width = tmpFrame.size.width;
        self.frame = iframe;
        statusW = YES;
    }
    else if(w>tmpFrame.size.width&&w<MX)
    {
        CGRect iframe = self.frame;
        iframe.size.width = w;
        self.frame = iframe;
        statusW = YES;
    }
    
}
//自适应高度
- (void)adJustForHeight
{
    if(statusAdjust!=2)
        return;
    CGSize size = CGSizeMake(tmpFrame.size.width - 8, CGFLOAT_MAX);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil];
    CGRect curRect = [self.text boundingRectWithSize:size
                                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                          attributes:dic
                                             context:nil];
    
    //计算任务这个宽度不需换行，高度没变，但放到这个宽度的textView切换行了，所以宽度当少个字来计算，应该也是同上
    //下面加10只是为了显示更好看，上下有空隙，scrollView.contentOffset = CGPointMake(0, 0);使textView不往上推移一点，所以整体高度会遮住没移动的那部分，所以高度加上没推移的高度
    CGFloat h = ceilf(curRect.size.height);
    NSLog(@"height = %f font = %f",h,self.font.lineHeight);
    statusW = NO;
    if(h<=tmpFrame.size.height)
    {
        CGRect iframe = self.frame;
        iframe.size.height = tmpFrame.size.height;
        self.frame = iframe;
        statusW = YES;
    }
    else if(h>tmpFrame.size.height&&h<MY)
    {
        h = h + 10;
        CGRect iframe = self.frame;
        iframe.size.height = h;
        self.frame = iframe;
        statusW = YES;
    }
}
//处理自适应
- (void)doForAdjustView
{
    [self adJustForWidth];
    
    [self adJustForHeight];
    
}

- (void)willShow
{
    if(maxHeight<=0)
        return;

    //获取键盘的y轴距离
    float yheight = ([UIScreen mainScreen].bounds.size.height) - maxHeight;
    //获取输入控件的y轴距离
    UIView * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[self convertRect:self.bounds toView:window];
    
    if(superView)
        window = superView;
    float theight = rect.origin.y+rect.size.height;
    if(theight>yheight)
    {
        [UIView beginAnimations:nil context:nil];
        CGRect frame = window.frame;
        frame.origin.y = frame.origin.y - (theight-yheight>0?theight-yheight+2:0);
        window.frame = frame;
        [UIView setAnimationDuration:0.05];
        [UIView commitAnimations];
    }
}
#pragma keyboard notification
- (void)keyboardWillAppear:(NSNotification *)notification
{
    //FDLog(@"键盘即将弹出");
    if(!self.isFirstResponder)
    {
        return;
    }
    NSDictionary *useInfo = [notification userInfo];
    NSValue *aValue = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    if(maxHeight<keyboardRect.size.height)
    {
        maxHeight = keyboardRect.size.height;
    }
    if(flag)
    {
        //保证每次只执行一次
        [self performSelector:@selector(willShow) withObject:nil afterDelay:0.3];
        flag = 0;
    }
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    //FDLog(@"键盘即将消失");
    if(!self.isFirstResponder)
    {
        return;
    }
    [UIView beginAnimations:nil context:nil];
    UIView * window=[[[UIApplication sharedApplication] delegate] window];
    CGFloat autoY = 0;
    if(superView)
    {
        window = superView;
        autoY = superRect.origin.y;
    }
    CGRect frame = window.frame;
    frame.origin.y = autoY;
    window.frame = frame;
    [UIView setAnimationDuration:0.35];
    [UIView commitAnimations];
    
    flag = 1;
    
}


#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"])
    {
        UITextView *tv = object;
        CGFloat boundH = [tv bounds].size.height;
        CGFloat contentH = [tv contentSize].height;
        CGFloat deadSpace = boundH - contentH;
        NSLog(@"bh = %f ch = %f",boundH,contentH);
        CGFloat inset = MAX(0, deadSpace/2.0);
        tv.contentInset = UIEdgeInsetsMake(inset, tv.contentInset.left, inset, tv.contentInset.right);
        
//         _placeholderView.center = CGPointMake(tv.frame.size.width/2, tv.frame.size.height/2-inset);
    }
    
}

#pragma -mark textViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([_FDdelegate respondsToSelector:@selector(FDTextViewShouldBeginEditing:)])
    {
        [_FDdelegate FDTextViewShouldBeginEditing:self];
    }
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    UIView *view = [window viewWithTag:555];
    if(!view)
        [window addSubview:bgView];
    [_placeholderView setHidden:YES];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if([_FDdelegate respondsToSelector:@selector(FDTextViewDidChange:)])
    {
        [_FDdelegate FDTextViewDidChange:self];
    }
    if ([textView.text length] == 0)
    {
        [_placeholderView setHidden:NO];
        textView.contentOffset = CGPointMake(0, 0);
    }
    else
    {
        [_placeholderView setHidden:YES];
        
    }
    NSString *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    //对中文输入时候，高亮字符的处理
    if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"zh-Hans"]) {
        
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        //有高亮部分
        if(position)
            return;
    }
    //处理表情
    if(!self.isAllowEmotion&&existTextNum>1) //过滤掉表情
    {
        textView.text = [nsTextContent newfilterEmoji];
    }
    //处理最大的个数
    if(_MaxNum>0)
    {
        existTextNum = textView.text.length;
        if (existTextNum > _MaxNum)
        {
            NSString *tmpStr = [textView.text substringToLength:_MaxNum];
            [textView setText:tmpStr];
        }
        
        if([self.FDdelegate respondsToSelector:@selector(FDTextView:maxNumLeave:)])
        {
            [self.FDdelegate FDTextView:self maxNumLeave:MAX(0,_MaxNum - existTextNum)];
        }
    }
    
    //自适应控制
    [self doForAdjustView];
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if([_FDdelegate respondsToSelector:@selector(FDTextViewDidEndEditing:)])
    {
        [_FDdelegate FDTextViewDidEndEditing:self];
    }
    if ([textView.text length] == 0)
    {
        [_placeholderView setHidden:NO];
    }
    else
    {
        [_placeholderView setHidden:YES];
    }
    [bgView removeFromSuperview];
    [textView resignFirstResponder];
}

- (BOOL)textView:(FDTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([self.FDdelegate respondsToSelector:@selector(FDTextView:shouldChangeTextInRange:replacementText:)])
    {
        [self.FDdelegate FDTextView:textView shouldChangeTextInRange:range replacementText:text];
    }
    if(_isOneLine)
    {
        if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
            //在这里做你响应return键的代码
            [self resignFirstResponder];
            return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        }
        
        return YES;
    }
    else
        return YES;
    
}

#pragma mark --- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (statusW) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
}
@end
