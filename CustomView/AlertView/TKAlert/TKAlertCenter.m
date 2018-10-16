//
//  TKAlertCenter.m
//  Created by Devin Ross on 9/29/10.
//
/*
 
 tapku || http://github.com/devinross/tapkulibrary
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "TKAlertCenter.h"
#import "UIView+TKCategory.h"

#pragma mark - TKAlertCenter
@implementation TKAlertCenter

#pragma mark Init & Friends
+ (TKAlertCenter*) defaultCenter {
	__strong static TKAlertCenter *defaultCenter = nil;
	if (!defaultCenter) {
		defaultCenter = [[TKAlertCenter alloc] init];
	}
	return defaultCenter;
}
- (id) init{
	if(!(self=[super init])) return nil;
	
	_alerts = [[NSMutableArray alloc] init];
	_alertView = [[TKAlertView alloc] init];
	_active = NO;
	
	
	_alertFrame = [UIScreen mainScreen].applicationFrame;

	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardDidHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationWillChange:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];

	return self;
}
- (void) dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Show Alert Message
- (void) showAlerts{
	
	if([_alerts count] < 1) {
		_active = NO;
		return;
	}
	
	_active = YES;
	_alertView.transform = CGAffineTransformIdentity;
	_alertView.alpha = 0;
	[[UIApplication sharedApplication].keyWindow addSubview:_alertView];

	
	
	NSArray *ar = _alerts[0];
	
	UIImage *img = nil;
	if([ar count] > 1) img = _alerts[0][1];
	
	[_alertView setImage:img];

	if([ar count] > 0) [_alertView setMessageText:_alerts[0][0]];
	
	
	
	_alertView.center = CGPointMake(_alertFrame.origin.x+_alertFrame.size.width/2, _alertFrame.origin.y+_alertFrame.size.height/2);
		
	
	CGRect rr = _alertView.frame;
	rr.origin.x = (int)rr.origin.x;
	rr.origin.y = (int)rr.origin.y;
	_alertView.frame = rr;
	
	UIInterfaceOrientation o = [UIApplication sharedApplication].statusBarOrientation;
	CGFloat degrees = 0;
	if(o == UIInterfaceOrientationLandscapeLeft ) degrees = -90;
	else if(o == UIInterfaceOrientationLandscapeRight ) degrees = 90;
	else if(o == UIInterfaceOrientationPortraitUpsideDown) degrees = 180;
	_alertView.transform = CGAffineTransformMakeRotation(degrees * M_PI / 180);
	_alertView.transform = CGAffineTransformScale(_alertView.transform, 2, 2);
	
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationStep2)];
	_alertView.transform = CGAffineTransformMakeRotation(degrees * M_PI / 180);
	_alertView.frame = CGRectIntegral(_alertView.frame);
	_alertView.alpha = 1;
	[UIView commitAnimations];
	
	
}
- (void) animationStep2{
	[UIView beginAnimations:nil context:nil];

	// depending on how many words are in the text
	// change the animation duration accordingly
	// avg person reads 200 words per minute
	NSArray * words = [_alerts[0][0] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	double duration = MAX(((double)[words count]*60.0/200.0),1.4f)+1;
	
	[UIView setAnimationDelay:duration];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationStep3)];
	
	UIInterfaceOrientation o = [UIApplication sharedApplication].statusBarOrientation;
	CGFloat degrees = 0;
	if(o == UIInterfaceOrientationLandscapeLeft ) degrees = -90;
	else if(o == UIInterfaceOrientationLandscapeRight ) degrees = 90;
	else if(o == UIInterfaceOrientationPortraitUpsideDown) degrees = 180;
	_alertView.transform = CGAffineTransformMakeRotation(degrees * M_PI / 180);
	_alertView.transform = CGAffineTransformScale(_alertView.transform, 0.5, 0.5);
	
	_alertView.alpha = 0;
	[UIView commitAnimations];
}
- (void) animationStep3{
	
	[_alertView removeFromSuperview];
	[_alerts removeObjectAtIndex:0];
	[self showAlerts];
	
}
- (void) postAlertWithMessage:(NSString*)message image:(UIImage*)image{
	if(message && image)
		[_alerts addObject:@[message,image]];
	else if(message)
		[_alerts addObject:@[message]];
	else if(image)
		[_alerts addObject:@[image]];
	if(!_active) [self showAlerts];
}
- (void) postAlertWithMessage:(NSString*)message{
	[self postAlertWithMessage:message image:nil];
}


#pragma mark System Observation Changes
CGRect subtractRect(CGRect wf,CGRect kf);
CGRect subtractRect(CGRect wf,CGRect kf){
	
	if(!CGPointEqualToPoint(CGPointZero,kf.origin)){
		
		if(kf.origin.x>0) kf.size.width = kf.origin.x;
		if(kf.origin.y>0) kf.size.height = kf.origin.y;
		kf.origin = CGPointZero;
		
	}else{
		
		
		kf.origin.x = abs(kf.size.width - wf.size.width);
		kf.origin.y = abs(kf.size.height -  wf.size.height);
		
		
		if(kf.origin.x > 0){
			CGFloat temp = kf.origin.x;
			kf.origin.x = kf.size.width;
			kf.size.width = temp;
		}else if(kf.origin.y > 0){
			CGFloat temp = kf.origin.y;
			kf.origin.y = kf.size.height;
			kf.size.height = temp;
		}
		
	}
	return CGRectIntersection(wf, kf);

}
- (void) keyboardWillAppear:(NSNotification *)notification {
	
	NSDictionary *userInfo = [notification userInfo];
	NSValue* aValue = userInfo[UIKeyboardFrameEndUserInfoKey];
	CGRect kf = [aValue CGRectValue];
	CGRect wf = [UIScreen mainScreen].applicationFrame;
	
	[UIView beginAnimations:nil context:nil];
	_alertFrame = subtractRect(wf,kf);
	_alertView.center = CGPointMake(_alertFrame.origin.x+_alertFrame.size.width/2, _alertFrame.origin.y+_alertFrame.size.height/2);

	[UIView commitAnimations];

}
- (void) keyboardWillDisappear:(NSNotification *) notification {
	_alertFrame = [UIScreen mainScreen].applicationFrame;

}
- (void) orientationWillChange:(NSNotification *) notification {
	
	NSDictionary *userInfo = [notification userInfo];
	NSNumber *v = userInfo[UIApplicationStatusBarOrientationUserInfoKey];
	UIInterfaceOrientation o = [v intValue];
	
	
	CGFloat degrees = 0;
	if(o == UIInterfaceOrientationLandscapeLeft ) degrees = -90;
	else if(o == UIInterfaceOrientationLandscapeRight ) degrees = 90;
	else if(o == UIInterfaceOrientationPortraitUpsideDown) degrees = 180;
	
	[UIView beginAnimations:nil context:nil];
	_alertView.transform = CGAffineTransformMakeRotation(degrees * M_PI / 180);
	_alertView.frame = CGRectMake((int)_alertView.frame.origin.x, (int)_alertView.frame.origin.y, (int)_alertView.frame.size.width, (int)_alertView.frame.size.height);
	[UIView commitAnimations];
	
}

- (void) showAlertWithMessage:(NSString *)message AddToView:(UIView *)view
{
    CGFloat x = view.frame.origin.x;
    CGFloat y = view.frame.origin.y;
    CGFloat w = view.frame.size.width;
    CGFloat h = view.frame.size.height;
    
    //    if (iOS7) {
    //        w = view.frame.size.height;
    //         h = view.frame.size.width;
    //    }
    
    
    
    if (HUDView) {
        [self removeHUDView];
    }
    
    HUDView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, w, h)];
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor colorWithRed:44/255.0 green:44/255.0 blue:44/255.0 alpha:0.75];
    bgView.clipsToBounds = YES;
    bgView.layer.cornerRadius = 5;
    
    
    UILabel *titleLable = [UILabel new];
    
    titleLable.font = [UIFont systemFontOfSize:16];
    
    titleLable.text = message;
    
    //多行显示
    titleLable.numberOfLines = 0;
    
    titleLable.textColor = [UIColor whiteColor];
    
    
    // titleLable.backgroundColor = [UIColor clearColor];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    [paragraphStyle setLineSpacing:10];
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName: paragraphStyle};
    
    //计算文本的大小
    CGSize titleSize = [message boundingRectWithSize:CGSizeMake(200, 250) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:attributes context:nil].size;
    
    // titleLable.frame =CGRectMake((w-titleSize.width)/2, (h-titleSize.height)/2,titleSize.width ,titleSize.height);
    
    titleLable.frame =CGRectMake(7.5, 7.5,titleSize.width ,titleSize.height);
    titleLable.textAlignment = NSTextAlignmentCenter;
    
    bgView.frame = CGRectMake( w/2-(titleLable.frame.size.width/2 + 7.5), h/2-(titleLable.frame.size.height/2 + 7.5) , titleLable.frame.size.width + 15, titleLable.frame.size.height + 15);
    
    
    [bgView addSubview:titleLable];
    
    [HUDView addSubview:bgView];
       
    [view addSubview:HUDView];
    
    //2秒后删除
    [self performSelector:@selector(removeHUDView) withObject:nil afterDelay:2.0f];
}
- (void)removeHUDView
{
    if (HUDView) {
        [HUDView removeFromSuperview];
    }
    
}


@end