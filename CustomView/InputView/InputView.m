//
//  InputView.m
//  Runner
//
//  Created by  Tmac on 16/8/31.
//  Copyright © 2016年 Janson. All rights reserved.
//

#import "InputView.h"
#import "NSString+EMOEmoji.h"

#define MaxTextViewHeight 80 //限制文字输入的高度

@interface InputView()
<UITextViewDelegate>
{
    UIView *inputView;
    NSString *initValue;
    UIView *subView;
    UIView *superView;
    CGRect superRect;
    
    NSInteger flag; //控制键盘监听的回调，一般即将显示会调用三次
    //NSString *prvStr;
    
    CGFloat maxHeight;      //键盘的最大高度
    
    CGFloat inputH;     //整个input的高度
    BOOL statusTextView;    //是否改变了输入框高度

}
@end

@implementation InputView

- (id)initWithStr:(NSString *)value
{
    if(self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)])
    {
        NSString *tmpStrVal = [[NSUserDefaults standardUserDefaults] objectForKey:@"InputView"];
        initValue = (value.length<=0?tmpStrVal:value);
        self.isAllowEmotion = YES;
        [self createView];
    }
    
    return self;
}

- (id)initWithStr:(NSString *)value subView:(UIView *)_subView superView:(UIView *)_superView
{
    if(self = [self initWithStr:value])
    {
        subView = _subView;
        superView = _superView;
        superRect = superView.frame;
    }
    
    return self;
}


- (void)dealloc
{
    NSLog(@"InputView dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    flag = 1;
    inputH = 44;
    // 键盘高度变化通知，ios5.0新增的
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.2;
    [self addSubview:bgView];
    
    inputView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, inputH)];
    inputView.backgroundColor = [UIColor whiteColor];
    [self addSubview:inputView];
    
    [self drawTextView];
    
    //点击事件
    UITapGestureRecognizer *singleTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tap)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:singleTap];

}
//重新构造inputView，其他类型输入框
- (void)resetInputView
{
    for(UIView *view in inputView.subviews)
        [view removeFromSuperview];
    
    _textField = [[UITextView alloc] initWithFrame:CGRectZero];
    _textField.font = [UIFont fontWithName:@"Arial" size:16];
    _textField.text = initValue;
    _textField.layer.borderWidth = 1;
    _textField.layer.borderColor = [UIColor grayColor].CGColor;
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeySend;
    [inputView addSubview:_textField];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(4);
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-4);
        make.right.mas_equalTo(-10);
    }];
}
//第一种类型的输入框
- (void)drawTextView
{
    if(_textField)
       [_textField removeFromSuperview];
    
    CGFloat textW = (SCREEN_WIDTH - 10*2)*4/5;
    NSLog(@"textW = %f",textW);
    _textField = [[UITextView alloc] initWithFrame:CGRectZero];
    _textField.font = [UIFont fontWithName:@"Arial" size:16];
    _textField.text = initValue;
    _textField.delegate = self;
    [inputView addSubview:_textField];
    
    //输入框下面的线
    UIView *buttomLine = [[UIView alloc] initWithFrame:CGRectZero];
    buttomLine.backgroundColor = ColorRGB(181, 200, 254);
    [inputView addSubview:buttomLine];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.layer.borderWidth = 0;
    okBtn.layer.cornerRadius = 7.0;
    okBtn.backgroundColor = [UIColor blueColor];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:14];
    okBtn.tag = 100;
    [okBtn addTarget:self action:@selector(btnTap) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:okBtn];
    [self bringSubviewToFront:inputView];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(4);
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-4);
        make.width.mas_equalTo(textW);
    }];
    
    [buttomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_textField.mas_bottom);
        make.left.and.right.mas_equalTo(_textField);
        make.height.mas_equalTo(1);
    }];
    
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(_textField.mas_right);
        make.height.mas_equalTo(30);
    }];
}

- (void)setInputFormat:(int)inputFormat
{
    //现在默认都加入特殊字符处理
    _inputFormat = inputFormat|INPUT_SPECIALCHAR;

    if(_inputFormat&INPUT_CONTENT)  //说说评论
    {
        [self resetInputView];
    }
    else
    {
        
        if(_inputFormat&INPUT_PHONE||_inputFormat&INPUT_HOMENUMBER||_inputFormat&INPUT_QQ)
            self.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        if(_inputFormat&INPUT_EMAIL)
            self.textField.keyboardType = UIKeyboardTypeEmailAddress;
        if(_inputFormat&INPUT_URL)
            self.textField.keyboardType = UIKeyboardTypeURL;
    }
}

- (BOOL)checkForFormat
{
    NSString *str = _textField.text;
    if(str.length==0)   //允许填空
        return YES;
    if(_inputFormat&INPUT_PHONE)
    {
        return [str isValidPhoneNumber];
    }
    if(_inputFormat&INPUT_HOMENUMBER)
    {
        return [str isValidHomeNumber];
    }
    if(_inputFormat&INPUT_EMAIL)
    {
        return [str isValidEmail];
    }
    if(_inputFormat&INPUT_WECHAT)
    {
        return [str isValidWeChat];
    }
    if(_inputFormat&INPUT_QQ)
    {
        return [str isValidQQ];
    }
    if(_inputFormat&INPUT_WEIBO)
    {
        return [str isValidWeiBo];
    }
    if(_inputFormat&INPUT_URL)
    {
        return [str isValidWeb];
    }
    if(_inputFormat&INPUT_SPECIALCHAR)
    {
        return ![self checkSpecialChar:str];
    }
    
    return YES;
}

- (BOOL)checkSpecialChar:(NSString *)str
{
//    if([str containsString:@"\\"]||[str containsString:@"'"]||[str containsString:@"\""])
//    {
//        [CommonFunc showShortMsg:@"含有特殊\\'\"符号"];
//        return YES;
//    }
    
    return NO;
}

- (void)show
{
    [_textField becomeFirstResponder];
    UIView *view = [[UIApplication sharedApplication].delegate window];
    [view addSubview:self];
}

//点击其它部位
- (void)tap
{
    [[NSUserDefaults standardUserDefaults] setObject:_textField.text forKey:@"InputView"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //[_textField resignFirstResponder];
    if(self.callBackWithHeight)
    {
        self.callBackWithHeight(@"",0);
    }
    [self removeFromSuperview];
}
//点击确定按钮的
- (void)btnTap
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"InputView"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *text = [_textField.text trimLeftAndRight];
    if(self.maxNum>0)
        text = [text substringToLength:self.maxNum];
    if(self.callBack)
    {
        if([self checkForFormat])
        {
            self.callBack(text);
        }
        else
            self.callBack(nil);
    }
    
    if(self.callBackWithHeight)
    {
        if([self checkForFormat])
        {
            self.callBackWithHeight(text,0);
        }
        else
            self.callBackWithHeight(nil,0);
    }
    
    [self removeFromSuperview];
}

- (void)setMaxNum:(int)maxNum
{
    if(initValue.length>maxNum)
    {
        initValue = [initValue substringToLength:maxNum];
    }
    _textField.text = initValue;
    _maxNum = maxNum;
}

- (void)willShow
{
    if(maxHeight<=0)
        return;
    
    CGFloat high = maxHeight+inputView.frame.size.height;
    if(self.callBackWithHeight)
        self.callBackWithHeight(@"",high);
}
#pragma mark - Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification
{
    //会多次执行，注意
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    if(maxHeight<endFrame.size.height)
    {
        maxHeight = endFrame.size.height;
    }
    if(flag)
    {
        //保证每次只执行一次
        [self performSelector:@selector(willShow) withObject:nil afterDelay:0.3];
        flag = 0;
    }
    void(^animations)() = ^{
        
        CGRect frame1 = inputView.frame;
        frame1.origin.y = endFrame.origin.y - inputView.frame.size.height;
        inputView.frame = frame1;
        
        
        //上移动界面
        UIView *view = [[UIApplication sharedApplication].delegate window];
        CGRect myRect = [subView convertRect:subView.bounds toView:view];
        float sy = myRect.origin.y+myRect.size.height-inputView.frame.origin.y;
        if(subView&&superView)
            view = superView;
        if(sy>0)  //盖住了控件
        {
            myRect = view.frame;
            myRect.origin.y -= sy;
            view.frame = myRect;
        }
        
        
    };
    
    if(maxHeight>0)
    [UIView animateWithDuration:duration delay:0.03f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
    
}

- (void)keyboardDidShow:(NSNotification *)notification
{

}

- (void)keyboardWillHide:(NSNotification *)notification
{


    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
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
    [UIView setAnimationDuration:0.3];
    [UIView commitAnimations];
}


#pragma -mark textViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //不支持系统表情的输入
    if(!self.isAllowEmotion)
    {
        //下面这个判断，现在基本无效，不知原因
        if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
            return NO;
        }
        
    }
    
    if(self.inputFormat&INPUT_CONTENT)
    {
        if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
            //在这里做你响应return键的代码
            [self btnTap];
            return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        }
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *nsTextContent = textView.text;
    NSInteger textNum = nsTextContent.length;

    //对中文输入时候，高亮字符的处理
    if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"zh-Hans"]) {
        
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        //有高亮部分
        if(position)
            return;
    }
    //过滤表情
    if(!self.isAllowEmotion)
    {
        textView.text = [nsTextContent newfilterEmoji];
    }

    //最大字数控制
    textNum = textView.text.length;
    if (textNum > self.maxNum&&self.maxNum>0)
    {
        NSString *tmpStr = [textView.text substringToLength:self.maxNum];
        [textView setText:tmpStr];
        [PublicFunction showLoading:@"已到最大字数"];
    }
    
    //---- 计算高度 ---- 动态改变输入框高度
    CGFloat textW = textView.frame.size.width-12;
    CGSize size = CGSizeMake(textW, CGFLOAT_MAX);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:textView.font,NSFontAttributeName, nil];
    CGFloat curheight = [textView.text boundingRectWithSize:size
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:dic
                                                    context:nil].size.height;
    curheight = ceilf(curheight)+4*2;
    CGFloat y = CGRectGetMaxY(inputView.frame);
    if(curheight<inputH)
    {
        inputView.frame = CGRectMake(0, y-inputH, inputView.frame.size.width, inputH);
        statusTextView = YES;
    }
    else if(curheight<MaxTextViewHeight)
    {
        curheight = textView.contentSize.height+8;
        //NSLog(@"curh = %f con = %f",curheight,textView.contentSize.height);
        inputView.frame = CGRectMake(0, y-curheight, inputView.frame.size.width, curheight);
        statusTextView = YES;
    }
    else
    {
        statusTextView = NO;
    }

}

#pragma mark --- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (statusTextView == YES) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
}
@end
