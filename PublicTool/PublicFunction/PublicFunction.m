//
//  PublicFunction.m
//  houseManage
//
//  Created by zhu xian on 12-3-3.
//  Copyright 2012 z. All rights reserved.
//

#import "PublicFunction.h"

#include <sys/xattr.h>
#import <sys/sysctl.h>
#include <unistd.h>
#include <netdb.h>

static UIWindow *comShowView;

@implementation PublicFunction


+ (MBProgressHUD *)showLoading:(NSString *)title
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeCustomView;
    //    hud.labelText = title;
    hud.detailsLabelText = title;
    hud.detailsLabelFont = [UIFont systemFontOfSize:13];
    hud.detailsLabelColor = [UIColor blackColor];
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.color = [UIColor whiteColor];
    
    [hud hide:YES afterDelay:2];
    
    return hud;
    
}

//static MBProgressHUD *hud;
+ (MBProgressHUD *)showLoading:(NSString *)message hiddenAfterDelay:(int)second
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [MBProgressHUD hideAllHUDsForView:window animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = message;
    hud.mode = MBProgressHUDModeCustomView;
    [hud hide:YES afterDelay:second];
    return hud;
}


+ (MBProgressHUD *)showTouchLoading:(NSString *)title
{

    if(comShowView)
        [MBProgressHUD hideAllHUDsForView:comShowView animated:YES];
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    comShowView = window;
    [MBProgressHUD hideAllHUDsForView:window animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    UITapGestureRecognizer *HUDSingleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    [hud addGestureRecognizer:HUDSingleTap];
    
    hud.labelText = title;
    
    return hud;
}

+ (MBProgressHUD *)showNoHiddenLoading:(NSString *)title
{
    if(comShowView)
        [MBProgressHUD hideAllHUDsForView:comShowView animated:YES];
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    comShowView = window;
    [MBProgressHUD hideAllHUDsForView:window animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    
    hud.labelText = title;
    
    return hud;
}

+ (void)hiddenHUD
{
    
    if(!comShowView)
    {
        UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
        comShowView = window;

    }
    
    [MBProgressHUD hideAllHUDsForView:comShowView animated:YES];
    comShowView = nil;
}


+(void)singleTap:(UITapGestureRecognizer*)sender
{
    NSLog(@"singleTap");
    //do what you need.
    [self hiddenHUD];
}

+(NSString *)getLastMonth
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = -1;
    NSDate *oneMonthFromNow = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
    return [self getDateTime:@"yyyy-MM" date:oneMonthFromNow];
}


+(BOOL)dateCompare:(NSString *)from to:(NSString *)to
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate * dateOne = [dateFormat dateFromString:from];
    NSDate * dateTwo =  [dateFormat dateFromString:to];
    
    if([dateOne compare:dateTwo] == NSOrderedAscending)
    {
         //NSLog(@"one 小于 two");
        return TRUE;
    }
    else
    {
        return  FALSE;
    }


}
+(NSArray *)getDayOfWeek:(NSString *)dateTime
{
       NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    // Calculate first day in week
    NSDate *today = [formatter dateFromString:dateTime];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents     = [gregorian components:NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:today];
 
    NSDateComponents *componentsToSubtract  = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: (0 - [weekdayComponents weekday]) + 2];
    [componentsToSubtract setHour: 0 - [weekdayComponents hour]];
    [componentsToSubtract setMinute: 0 - [weekdayComponents minute]];
    [componentsToSubtract setSecond: 0 - [weekdayComponents second]];
    
    //NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    //Create date for first day in week
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:today options:0];
    NSMutableArray *arrDays=[[NSMutableArray alloc] initWithCapacity:0];
    //By adding 6 to the date of the first day, we can get the last day, in our example Sunday.
    NSDateComponents *componentsToAdd = [gregorian components:NSDayCalendarUnit fromDate:beginningOfWeek];
    for (int i=0; i<7; i++)
    {
        
        [componentsToAdd setDay:i];
        
        NSDate *dayOfWeek = [gregorian dateByAddingComponents:componentsToAdd toDate:beginningOfWeek options:0];
        
        NSString *stringFromDate = [formatter stringFromDate:dayOfWeek];
        
        NSLog(@"dayOfWeek=%@",stringFromDate);
        
        [arrDays addObject:stringFromDate];
    }
    
    

    
    NSArray *arr=[NSArray arrayWithArray:arrDays];
   
  
    
    return arr;
}

+(NSString *)getMonthFromNow:(int)month
{
    NSDateComponents *components = [[NSDateComponents alloc] init] ;
    components.month = month;
    NSDate *oneMonthFromNow = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
    return [self getDateTime:@"yyyy-MM-dd" date:oneMonthFromNow];
}

+(NSString *)getDateTime:(NSString *)format date:(NSDate *)date
{
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:format];
	
	NSString *theDate = [dateFormat stringFromDate:date];
	NSString *ret=[NSString stringWithFormat:@"%@",theDate];
	return ret;
}

//根据日期获取该日期所在月的所有日期
+ (NSArray *)getdaysArrayByTheDate:(NSString *)dateStr withType:(NSString *)type{
    
    NSMutableArray *dateArray = [NSMutableArray new];
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:type];
    NSDate* newDate = [inputFormatter dateFromString:dateStr];
    
    if (newDate == nil) {
        newDate = [NSDate date];
    }
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitMonth;
    
    BOOL ok = [calendar rangeOfUnit:unitFlags startDate:&beginDate interval:&interval forDate:newDate];
    
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return nil;
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:type];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];//一个月的第一天
    NSString *endString = [myDateFormatter stringFromDate:endDate];//一个月的最后一天
    
    NSInteger num = [self daysWithinEraFromDate:beginString toDate:endString];
    
    [dateArray addObject:[NSNumber numberWithInt:[[beginString componentsSeparatedByString:@"-"][2] intValue]]];
    
    for (int i = 1; i<=num; i++) {//当前日期所在月对应的日期
        NSString *dateString = [self getTomorrowAndYesterDayByCurrentDate:beginString byIndex:i withType:type];
        [dateArray addObject:[NSNumber numberWithInt:[[dateString componentsSeparatedByString:@"-"][2] intValue]]];
    }
    return dateArray;
}

//计算同一时代（AD|BC）两个日期午夜之间的天数，参数格式必须为yyyy-MM-dd
+ (NSInteger)daysWithinEraFromDate:(NSString *)beforeDay toDate:(NSString *)behindDay
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* startDate = [inputFormatter dateFromString:beforeDay];
    NSDate *endDate = [inputFormatter dateFromString:behindDay];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    
    return [components day];
}

//当前日期的前后第几天,index值为正则是今天以后的日期
+ (NSString *)getTomorrowAndYesterDayByCurrentDate:(NSString *)date byIndex:(NSInteger)index withType:(NSString *)type
{
    NSTimeInterval secondsPerDay = 24 * 60 * 60*index;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:type];
    NSDate* today = [inputFormatter dateFromString:date];
    NSDate *tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    NSString * globalDate=[inputFormatter stringFromDate:tomorrow];
    
    return globalDate;
}

+(BOOL) isIdCarNumber:(NSString *)checkString
{
	NSString *emailRegex = @"^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$"; 
	NSString *emailRegex2 = @"^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$";
	
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];  
    NSPredicate *emailTest2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex2];  
    
    if ([emailTest evaluateWithObject:checkString]||[emailTest2 evaluateWithObject:checkString]) {
        return TRUE;
    }
	else {
		return FALSE ;
	}
	
}
+(UIImageView *)getImageView:(CGRect)frame imageName:(NSString *)imageName
{
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:frame];
    imageView.image=[UIImage imageNamed:imageName];
    
    return imageView;
}

+(UIImage *)getImage:(NSString *)imageName
{
	if ([imageName rangeOfString:@"."].location != NSNotFound)
    {
		NSArray *names = [imageName componentsSeparatedByString: @"."];
		return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[names objectAtIndex:0] ofType:[names objectAtIndex:1]]];
	}
	else
    {
		return nil;
	}
}

+ (UIImage *) creatTwoCodeImageWithURL:(NSString *)url
{
    CIFilter *fiter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [fiter setDefaults];
    NSData *data = [url dataUsingEncoding:NSUTF8StringEncoding];
    [fiter setValue:data forKey:@"inputMessage"];
    CIImage *outputImage = [fiter outputImage];
    
    //UIImage *image = [[UIImage alloc] initWithCIImage:outputImage];
    //UIImage *image = [UIImage imageWithCIImage:outputImage scale:20.0 orientation:UIImageOrientationUp];
    UIImage *image = [[self class] createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
    return image;
}
//对生成的二维码图片控制大小
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

+ (UIImage *) getImageFromView: (UIView *)theView
{
    //参数：范围，是否非透明，缩放
    UIGraphicsBeginImageContextWithOptions(theView.frame.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
+ (UIImage *)imagesMergeWith:(NSArray *)images andSize:(CGSize)size
{
    if (images.count == 0) {
        return nil;
    }
    
    UIImage *mergeImage;
    NSInteger count = images.count;
    CGFloat width = size.width;
    
    UIGraphicsBeginImageContext(size);
    //背景色填充
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, ColorRGB(241,241,241).CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    switch (count) {
        case 1:
        {
            UIImage *image1 = images[0];
            [image1 drawInRect:CGRectMake(0, 0, width, width)];
        }
            break;
        case 2:
        {
            UIImage *image1 = images[0];
            UIImage *image2 = images[1];
            
            [image1 drawInRect:CGRectMake(0, width/4, width/2-1, width/2-1)];
            [image2 drawInRect:CGRectMake(width/2+1,  width/4, width/2-1, width/2-1)];
        }
            break;
        case 3:
        {
            UIImage *image1 = images[0];
            UIImage *image2 = images[1];
            UIImage *image3 = images[2];
            
            [image1 drawInRect:CGRectMake(width/4, 0, width/2-1, width/2-1)];
            [image2 drawInRect:CGRectMake(0, width/2+1, width/2-1, width/2-1)];
            [image3 drawInRect:CGRectMake(width/2+1,  width/2+1, width/2-1, width/2-1)];
        }
            
            break;
        case 4:
        {
            UIImage *image1 = images[0];
            UIImage *image2 = images[1];
            UIImage *image3 = images[2];
            UIImage *image4 = images[3];
            
            [image1 drawInRect:CGRectMake(0, 0, width/2-1, width/2-1)];
            [image2 drawInRect:CGRectMake(width/2+1, 0, width/2-1, width/2-1)];
            [image3 drawInRect:CGRectMake(0, width/2+1, width/2-1, width/2-1)];
            [image4 drawInRect:CGRectMake(width/2+1,  width/2+1, width/2-1, width/2-1)];
        }
            break;
            
        default:
            break;
    }
    mergeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return mergeImage;
}


+(UIColor *)getColorByImage:(NSString *)imageName
{
	if ([imageName rangeOfString:@"."].location != NSNotFound) 
    {
		NSArray *names = [imageName componentsSeparatedByString: @"."];
        return [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[names objectAtIndex:0] ofType:[names objectAtIndex:1]]]];
	}
	else 
    {
		return nil;
	}
}

+(BOOL) isFloat:(NSString *)checkString
{
	NSString *Regex = @"^[+|-]?\d*\.?\d*$";  
    NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];  
    return [Test evaluateWithObject:checkString];
}
+(BOOL) isNumber:(NSString *)checkString
{
    if ([checkString isEqualToString:@"0"]||[checkString isEqualToString:@"0.0"])
    {
        return TRUE;
    }
    NSLog(@"checkString=%@",checkString);
    checkString=[[checkString  stringByReplacingOccurrencesOfString:@"." withString:@""] stringByReplacingOccurrencesOfString:@"0.0" withString:@"0"];
	NSString *Regex = @"^[0-9]*[1-9][0-9]*$";  //@"^[+|-]?\d*\.?\d*$";  //
    NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",Regex];  
    return [Test evaluateWithObject:checkString];
}

+(BOOL) isAlphaNumeric:(NSString *)checkString
{
	
	NSCharacterSet *alphaSet = [NSCharacterSet alphanumericCharacterSet];
	return [[checkString stringByTrimmingCharactersInSet:alphaSet] isEqualToString:@""];
	
}

+(BOOL) isEmail:(NSString *)checkString
{
	NSString *emailRegex = @"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$";  
	
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];  
    return [emailTest evaluateWithObject:checkString];
}

+(BOOL)isValidInput:(NSString *)checkString
{
	
	NSString *stricterFilterString = @"^[A-Z0-9a-z._\u4e00-\u9fa5]+$";
	
	NSString *emailRegex = stricterFilterString;
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
	return [emailTest evaluateWithObject:checkString];
}
//检测日期
+(BOOL) isDate:(NSString *)checkString
{
	NSString *emailRegex = @"^\d{4}-\d{2}-\d{2}$";  
	
    NSPredicate *DateTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];  
    return [DateTest evaluateWithObject:checkString];
}
//缩略图
+ (UIImage *) getImage:(UIImage *)image width:(int)width height:(int)height
{
	NSLog(@"scaleFromImage.....");
	CGSize size = CGSizeMake(width,height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return newImage;
}

+(UITextField *)addTextField:(CGRect)frame  tag:(NSInteger)tag returnType:(NSString *)returnType
{
    UITextField  *TextField=[[UITextField alloc] initWithFrame:frame];
	//TextField.delegate = self;
	TextField.tag=tag;
	TextField.textAlignment = NSTextAlignmentLeft;
	TextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	TextField.returnKeyType = UIReturnKeyNext;
	TextField.font=[UIFont fontWithName:@"Arial" size:16];
	TextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	TextField.layer.cornerRadius=2.0f;
    TextField.layer.masksToBounds=YES;
    TextField.layer.borderColor=[[UIColor grayColor] CGColor];
    TextField.layer.borderWidth= 1.0f;
    TextField.textColor =[UIColor blackColor];
    if ([returnType isEqualToString:@"next"]) {
        TextField.returnKeyType = UIReturnKeyNext;
    }
    else {
        TextField.returnKeyType = UIReturnKeyDone;
    }
    UIView *leftView=[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 5.0f,30.0f)];
    TextField.leftView=leftView;
	TextField.leftViewMode = UITextFieldViewModeAlways;
	
    
    return TextField;
    
}

+(void)addLeftView:(UITextField *)textField
{
	UIView *leftView=[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 15.0f,30.0f)];
	UIButton *btnLeftImg = [UIButton buttonWithType:UIButtonTypeCustom];
	[btnLeftImg setBackgroundImage:[UIImage imageNamed:@"leftPoint.png"] forState:UIControlStateNormal];
	btnLeftImg.frame = CGRectMake(5.0f, 10.0f, 9.0f,9.0f);
	[leftView addSubview:btnLeftImg];
	textField.leftView=leftView;
	textField.leftViewMode = UITextFieldViewModeAlways;
	
}

+(UILabel *)getlabel:(CGRect)frame text:(NSString *)text BGColor:(UIColor *)BGColor textColor:(UIColor *)textColor size:(NSInteger)size
{
	UILabel *labelRemark=[[UILabel alloc] initWithFrame:frame];
	labelRemark.textColor = textColor;
	labelRemark.font = [UIFont fontWithName:@"Arial" size:size];
	labelRemark.lineBreakMode = NSLineBreakByWordWrapping;
	labelRemark.numberOfLines = 0;
    labelRemark.backgroundColor=BGColor;
    labelRemark.highlightedTextColor=[UIColor grayColor];
	labelRemark.text=text;
	return labelRemark;
}

+(UILabel *)getlabel:(CGRect)frame text:(NSString *)text color:(UIColor *)color size:(NSInteger)size
{
	
	UILabel *labelRemark=[[UILabel alloc] initWithFrame:frame];
	labelRemark.textColor = color;
    labelRemark.text=text;
	labelRemark.font = [UIFont fontWithName:@"Arial" size:size];
	labelRemark.lineBreakMode = NSLineBreakByWordWrapping;
	labelRemark.numberOfLines = 0;
    labelRemark.textAlignment=NSTextAlignmentLeft;
    labelRemark.backgroundColor=[UIColor clearColor];
    labelRemark.highlightedTextColor=[UIColor grayColor];
	
	return labelRemark;
}
+(UILabel *)getlabel:(CGRect)frame text:(NSString *)text fontSize:(int)fontSize color:(UIColor *)color
{
	UILabel *labelPrice=[[UILabel alloc] initWithFrame:frame];
	labelPrice.textColor = color;
	labelPrice.font = [UIFont fontWithName:@"Arial" size:fontSize];
	labelPrice.lineBreakMode = NSLineBreakByWordWrapping;
	labelPrice.numberOfLines = 0;
    labelPrice.backgroundColor=[UIColor whiteColor];
	labelPrice.text=text;
	return labelPrice;
}
+(UILabel *)getlabel:(CGRect)frame text:(NSString *)text fontSize:(int)fontSize color:(UIColor *)color align:(NSString *)align
{
	UILabel *labelPrice=[[UILabel alloc] initWithFrame:frame];
	labelPrice.textColor = color;
	labelPrice.font = [UIFont fontWithName:@"Arial" size:fontSize];
	labelPrice.lineBreakMode = NSLineBreakByWordWrapping;
	labelPrice.numberOfLines = 0;
    if([align isEqualToString:@"right"])
    {
        labelPrice.textAlignment=NSTextAlignmentRight;
    }
    else if([align isEqualToString:@"center"])
    {
        labelPrice.textAlignment=NSTextAlignmentCenter;
    }
    else
    {
        labelPrice.textAlignment=NSTextAlignmentLeft;
    }
    
   // labelPrice.backgroundColor=[UIColor whiteColor];
	labelPrice.text=[NSString stringWithFormat:@"%@",text];
	return labelPrice;
}
+(UILabel *)getlabel:(CGRect)frame text:(NSString *)text imageName:(NSString *)imageName
{
	UILabel *labelRemark=[[UILabel alloc] initWithFrame:frame];
	
    if (imageName.length>0) {
        labelRemark.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:imageName]];
    }
    
	labelRemark.lineBreakMode = NSLineBreakByWordWrapping;
	labelRemark.numberOfLines = 0;
    if (text.length>0) {
        labelRemark.textColor = [UIColor blackColor];
        labelRemark.font = [UIFont fontWithName:@"Arial" size:16];
        labelRemark.text=text;
    }
	
	return labelRemark;
}
+(UITextView *)getTextView:(CGRect)frame   text:(NSString *)text size:(int)size
{
    
    UITextView *textView=[[UITextView alloc] initWithFrame:frame];
    textView.editable=FALSE;
	textView.font=[UIFont fontWithName:@"Arial" size:size];
    textView.text=text;
    return textView;
    
}
+(UILabel *)getlabel:(CGRect)frame text:(NSString *)text font:(UIFont *)font
{
    UILabel *labelRemark=[[UILabel alloc] initWithFrame:frame];
    labelRemark.textColor = [UIColor grayColor];
    labelRemark.font = font;
    labelRemark.highlightedTextColor=[UIColor redColor];
    
    labelRemark.lineBreakMode = NSLineBreakByWordWrapping;
    labelRemark.numberOfLines = 0;
    // [labelRemark sizeToFit];
    labelRemark.text=text;
  
    
    //labelRemark.adjustsFontSizeToFitWidth=YES;
    return labelRemark ;
}

+(UILabel *)getlabel:(CGRect)frame text:(NSString *)text size:(int)size
{
	UILabel *labelRemark=[[UILabel alloc] initWithFrame:frame];
    labelRemark.text = text;
    
    labelRemark.font = [UIFont systemFontOfSize:size];
    
	labelRemark.lineBreakMode = NSLineBreakByWordWrapping;
   
	return labelRemark ;
}

+(UILabel *)getlabel:(CGRect)frame text:(NSString *)text align:(NSString *)align
{
    if ([text rangeOfString:@".00"].location!=NSNotFound) {
        text=[text stringByReplacingOccurrencesOfString:@".00" withString:@""];
    }
	UILabel *labelPrice=[[UILabel alloc] initWithFrame:frame];
	labelPrice.textColor = [UIColor blackColor];
	labelPrice.font = [UIFont fontWithName:@"Arial" size:15];
	labelPrice.lineBreakMode = NSLineBreakByWordWrapping;
    //labelPrice.backgroundColor=[UIColor whiteColor];
	labelPrice.numberOfLines = 0;
    if([align isEqualToString:@"right"])
    {
        labelPrice.textAlignment=NSTextAlignmentRight;
    }
    else if([align isEqualToString:@"center"])
    {
        labelPrice.textAlignment=NSTextAlignmentCenter;
    }
    else
    {
    labelPrice.textAlignment=NSTextAlignmentLeft;
    }
    
	labelPrice.text=text;
    
    CGSize  labelsize=[labelPrice.text sizeWithFont:labelPrice.font constrainedToSize:CGSizeMake(frame.size.width, 15000) lineBreakMode:NSLineBreakByWordWrapping];
    
    if (labelsize.height>frame.size.height) 
    labelPrice.frame=CGRectMake(frame.origin.x,frame.origin.y, frame.size.width,  labelsize.height);
    
	return labelPrice ;
}
+(UILabel *)getlabel:(CGRect)frame text:(NSString *)text textSize:(int)size  textColor:(UIColor *)textColor textBgColor:(UIColor *)bgcolor  textAlign:(NSString *)align
{
    if ([text rangeOfString:@".00"].location!=NSNotFound) {
        text=[text stringByReplacingOccurrencesOfString:@".00" withString:@""];
    }
	UILabel *labelPrice=[[UILabel alloc] initWithFrame:frame];
	labelPrice.textColor = textColor;
	labelPrice.font = [UIFont fontWithName:@"Arial" size:size];
	labelPrice.lineBreakMode = NSLineBreakByWordWrapping;
    //修改by Star
    if (bgcolor) {
           labelPrice.backgroundColor=bgcolor;
    }
     labelPrice.numberOfLines = 0;
    if([align isEqualToString:@"right"])
    {
        labelPrice.textAlignment=NSTextAlignmentRight;
    }
    else if([align isEqualToString:@"center"])
    {
        labelPrice.textAlignment=NSTextAlignmentCenter;
    }
    
	labelPrice.text=text;
    CGSize  labelsize=[labelPrice.text sizeWithFont:labelPrice.font constrainedToSize:CGSizeMake(frame.size.width, 15000) lineBreakMode:NSLineBreakByWordWrapping];
    if (labelsize.height>frame.size.height) 
    labelPrice.frame=CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,  labelsize.height);
	return labelPrice;
}
+(UILabel *)getlabel:(CGRect)frame text:(NSString *)text  size:(int)size align:(NSString *)align
{
    if ([text rangeOfString:@".00"].location!=NSNotFound) {
        text=[text stringByReplacingOccurrencesOfString:@".00" withString:@""];
    }
	UILabel *labelPrice=[[UILabel alloc] initWithFrame:frame] ;
	labelPrice.textColor = [UIColor blackColor];
	labelPrice.font = [UIFont fontWithName:@"Arial" size:size];
	labelPrice.lineBreakMode = NSLineBreakByWordWrapping;
    labelPrice.backgroundColor=[UIColor whiteColor];
	labelPrice.numberOfLines = 0;
    if([align isEqualToString:@"right"])
    {
        labelPrice.textAlignment=NSTextAlignmentRight;
    }
    else if([align isEqualToString:@"center"])
    {
        labelPrice.textAlignment=NSTextAlignmentCenter;
    }
    
	labelPrice.text=text;
    CGSize  labelsize=[labelPrice.text sizeWithFont:labelPrice.font constrainedToSize:CGSizeMake(frame.size.width, 15000) lineBreakMode:NSLineBreakByWordWrapping];
    if (labelsize.height>frame.size.height) 
    labelPrice.frame=CGRectMake(frame.origin.x,frame.origin.y, frame.size.width,  labelsize.height);
	return labelPrice;
}
+(UILabel *)getlabel:(CGRect)frame text:(NSString *)text
{
	UILabel *labelRemark=[[UILabel alloc] initWithFrame:frame];
    labelRemark.text=text;
	labelRemark.textColor = [UIColor blackColor];
    labelRemark.backgroundColor=[UIColor clearColor];
	labelRemark.font = [UIFont fontWithName:@"Arial" size:16];
	labelRemark.lineBreakMode = NSLineBreakByWordWrapping;
	labelRemark.numberOfLines = 0;
	
    CGSize  labelsize=[labelRemark.text sizeWithFont:labelRemark.font constrainedToSize:CGSizeMake(frame.size.width, 15000) lineBreakMode:NSLineBreakByWordWrapping];
    if (labelsize.height>frame.size.height) 
    labelRemark.frame=CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,  labelsize.height);
    
	return labelRemark;
}


+(UITextField *)getTextFieldInControl:(id)control frame:(CGRect)frame  tag:(NSInteger)tag returnType:(NSString *)returnType
{
    
    UITextField  *TextField=[[UITextField alloc] initWithFrame:frame];
	//TextField.delegate = self;
	TextField.tag=tag;
	TextField.textAlignment = NSTextAlignmentLeft;
	TextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	TextField.returnKeyType = UIReturnKeyNext;
	TextField.font=[UIFont fontWithName:@"Arial" size:16+2];
	TextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	TextField.layer.cornerRadius=2.0f;
    TextField.layer.masksToBounds=YES;
    TextField.layer.borderColor=[[UIColor blackColor] CGColor];
    TextField.layer.borderWidth= 1.0f;
    TextField.backgroundColor=[UIColor whiteColor];
    if ([returnType isEqualToString:@"next"])
    {
        TextField.returnKeyType = UIReturnKeyNext;
    }
    else {
        TextField.returnKeyType = UIReturnKeyDone;
    }
    UIView *leftView=[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 5.0f,30.0f)];
	TextField.leftView=leftView;
    TextField.delegate=control;
	TextField.leftViewMode = UITextFieldViewModeAlways;
	
    
    UIButton* btnDowd= [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDowd setImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
    [btnDowd setFrame:CGRectMake(0,0, 32,32)];
    [btnDowd  addTarget:TextField action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 32);
    btnDowd.frame = CGRectOffset(btnDowd.frame, SCREEN_WIDTH - btnDowd.bounds.size.width, 0);
    [view addSubview:btnDowd];
    TextField.inputAccessoryView =view;
     
   
    return TextField;
    
}
+(UITextField *)getTextFieldInControl:(id)control frame:(CGRect)frame  tag:(NSInteger)tag  returnType:(NSString *)returnType text:(NSString *)text placeholder:(NSString *)placeholder
{
    
    UITextField  *TextField=[[UITextField alloc] initWithFrame:frame];
	//TextField.delegate = self;
	TextField.tag=tag;
	TextField.textAlignment = NSTextAlignmentLeft;
	TextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	TextField.returnKeyType = UIReturnKeyNext;
	TextField.font=[UIFont fontWithName:@"Arial" size:16+2];
	TextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	TextField.layer.cornerRadius=2.0f;
    TextField.layer.masksToBounds=YES;
    TextField.layer.borderColor=[[UIColor grayColor] CGColor];
    TextField.layer.borderWidth= 1.0f;
    TextField.backgroundColor=[UIColor whiteColor];
    TextField.text=text;
    TextField.placeholder=placeholder;
     [TextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];//取消自动首字母大写
    if ([returnType isEqualToString:@"next"])
    {
        TextField.returnKeyType = UIReturnKeyNext;
    }
    else {
        TextField.returnKeyType = UIReturnKeyDone;
    }
    UIView *leftView=[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 5.0f,30.0f)];
	TextField.leftView=leftView;
    TextField.delegate=control;
	TextField.leftViewMode = UITextFieldViewModeAlways;
	
    
    UIButton* btnDowd= [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDowd setImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
    [btnDowd setFrame:CGRectMake(0,0, 32,32)];
    [btnDowd  addTarget:TextField action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 32);
    btnDowd.frame = CGRectOffset(btnDowd.frame, SCREEN_WIDTH - btnDowd.bounds.size.width, 0);
    [view addSubview:btnDowd];
    TextField.inputAccessoryView =view;
    return TextField;
    
}
+(NSData*)hexStringToNSData:(NSString *)command
{
    //NSString *command = @"72ff63cea198b3edba8f7e0c23acc345050187a0cde5a9872cbab091ab73e553";
    command = [command stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *commandToSend= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [command length]/2; i++) {
        byte_chars[0] = [command characterAtIndex:i*2];
        byte_chars[1] = [command characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [commandToSend appendBytes:&whole_byte length:1];
    }
    NSLog(@"%@", commandToSend);
    return commandToSend;
}

+(NSData*) bytesFromHexString:(NSString *)aString
{
    NSString *theString = [[aString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:nil];
    
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= theString.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [theString substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        if ([scanner scanHexInt:&intValue])
            [data appendBytes:&intValue length:1];
    }
    return data;
}
// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    if (hexString==nil) {
        hexString=@"#009393";
    }
    
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


+ (NSData *)getValidCharsForData:(NSData *)data withLength:(NSInteger)length
{
    NSInteger len = data.length;
    length = MIN(len, length);
    Byte bit[length];
    [data getBytes:&bit length:length];
    
    NSInteger validLength = 0;
    for (int i = 0; i <= length; )
    {
        validLength = i;
        NSInteger l;
        Byte byte = bit[i];
        if (byte >= 0xFC) // lenght 6
            l = 6;//6字节 1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
        else if (byte >= 0xF8)
            l = 5;//5字节 111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
        else if (byte >= 0xF0)
            l = 4;//4字节 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
        else if (byte >= 0xE0)
            l = 3;//3字节 1110xxxx 10xxxxxx 10xxxxxx
        else if (byte >= 0xC0)
            l = 2;//2字节 110xxxxx 10xxxxxx
        else
            l = 1;//1字节 0xxxxxxx
        
        i += l;
    }
    data = [data subdataWithRange:NSMakeRange(0, validLength)];
    return data;
}
+(UITextView *)getTextViewInControl:(id)control frame:(CGRect)frame  tag:(NSInteger)tag returnType:(NSString *)returnType
{
    
    UITextView *textView=[[UITextView alloc] initWithFrame:frame];
	textView.delegate = control;
	textView.tag=tag;
	textView.textAlignment = NSTextAlignmentLeft;
	textView.font=[UIFont fontWithName:@"Arial" size:16+2];
	textView.layer.cornerRadius=2.0f;
    textView.layer.masksToBounds=YES;
    textView.layer.borderColor=[[UIColor grayColor] CGColor];
    textView.layer.borderWidth= 1.0f;
    
    if ([returnType isEqualToString:@"next"])
    {
        textView.returnKeyType = UIReturnKeyNext;
    }
    else {
        textView.returnKeyType = UIReturnKeyDone;
    }
    UIButton* btnDowd= [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDowd setImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
    [btnDowd setFrame:CGRectMake(0,0, 32,32)];
    [btnDowd  addTarget:textView action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 32);
    btnDowd.frame = CGRectOffset(btnDowd.frame, SCREEN_WIDTH - btnDowd.bounds.size.width, 0);
    [view addSubview:btnDowd];
    textView.inputAccessoryView =view;
    return textView;
    
}

+(UITextField *)getTextField:(CGRect)frame  tag:(NSInteger)tag returnType:(NSString *)returnType
{
    
    UITextField  *TextField=[[UITextField alloc] initWithFrame:frame];
	//TextField.delegate = self;
	TextField.tag=tag;
	TextField.textAlignment = NSTextAlignmentLeft;
	TextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	TextField.returnKeyType = UIReturnKeyNext;
	TextField.font=[UIFont fontWithName:@"Arial" size:16+2];
	TextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	TextField.layer.cornerRadius=2.0f;
    TextField.layer.masksToBounds=YES;
    TextField.layer.borderColor=[[UIColor blackColor] CGColor];
    TextField.layer.borderWidth= 1.0f;
     TextField.backgroundColor=[UIColor whiteColor];
    if ([returnType isEqualToString:@"next"]) {
        TextField.returnKeyType = UIReturnKeyNext;
    }
    else {
        TextField.returnKeyType = UIReturnKeyDone;
    }
    UIView *leftView=[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 5.0f,30.0f)];
	TextField.leftView=leftView;
	TextField.leftViewMode = UITextFieldViewModeAlways;
	
    
    UIButton* btnDowd= [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDowd setImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
    [btnDowd setFrame:CGRectMake(0,0, 32,32)];
    [btnDowd  addTarget:TextField action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 32);
    btnDowd.frame = CGRectOffset(btnDowd.frame, SCREEN_WIDTH - btnDowd.bounds.size.width, 0);
    [view addSubview:btnDowd];
    TextField.inputAccessoryView =view;
    
    return TextField;
    
}
+(UISegmentedControl *)getSegmentedControl:(NSArray *)buttonNames
{
    //NSArray *buttonNames = [NSArray arrayWithObjects:type1,type2,type3,type4,type5,nil];
    
    UISegmentedControl* segmentedControl = [[UISegmentedControl alloc] initWithItems:buttonNames];
    segmentedControl.frame=CGRectMake(0, 0, SCREEN_WIDTH, 36);
    //segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    //segmentedControl.selectedSegmentIndex=UISegmentedControlNoSegment;
    //segmentedControl.segmentedControlStyle = 0;
    segmentedControl.selectedSegmentIndex=0;
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:@"Arial" size:16], UITextAttributeFont,
                                [UIColor blackColor], UITextAttributeTextColor,
                                nil];
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor greenColor] forKey:UITextAttributeTextColor];
    [segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
    [segmentedControl setBackgroundImage:[UIImage imageNamed:@"buttonGray"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmentedControl setBackgroundImage:[UIImage imageNamed:@"buttonBlue"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    return segmentedControl;
}

+(BOOL)getPowerByType:(NSString *)type andAddEditDel:(NSString *)addEditDel
{
    //获取用户 销售 采购 的相应 新增 修改删除权限
  if ([self canDelete]){return TRUE; }
    
    int index=0;
    int powerIndex=0;
    
    if ([type isEqualToString:@"purchase"]) {index=1;}
     else if ([type isEqualToString:@"sell"]) {index=2;}
     else if ([type isEqualToString:@"account"]) {index=3;}
     else if ([type isEqualToString:@"basedata"]) {index=4;}
    
    if ([addEditDel isEqualToString:@"add"]) {powerIndex=0;}
    else if ([addEditDel isEqualToString:@"delete"]) {powerIndex=1;}
    else if ([addEditDel isEqualToString:@"edit"]) {powerIndex=2;}
    else if ([addEditDel isEqualToString:@"search"]) {powerIndex=3;}
    
    
   NSString *userPower=[[NSUserDefaults standardUserDefaults] stringForKey:@"Power"];
   if (userPower!=nil)
   {
      // [FileManage saveCrash:[NSString stringWithFormat:@"userPower=%@",userPower]];
       if ([userPower rangeOfString:@"#"].location!=NSNotFound) {
           NSArray *arr=[userPower componentsSeparatedByString:@"#"];
           if (index<arr.count) {
               userPower=[arr objectAtIndex:index];
               NSArray *arrr=[userPower componentsSeparatedByString:@"."];
               if (arrr.count>0)
               {
                   if ([[arrr objectAtIndex:powerIndex] isEqualToString:@"1"])
                   {
                       return TRUE;
                   }
                   else
                   {
                       return FALSE;
                   }
               }
              return FALSE;
           }
          return FALSE;
       }
       return FALSE;
    }
    else
    {
        return TRUE;
    }
}


+(BOOL)canDelete
{
    NSString *userRole=[[NSUserDefaults standardUserDefaults] stringForKey:@"userRole"];
    //[FileManage saveCrash:[NSString stringWithFormat:@"check can delete userRole =%@",userRole]];
    if (userRole!=nil)
    {
        if ([userRole isEqualToString:@"2"])
        {
           
            return FALSE;
        }
        else
        {
          return TRUE;
        }
    }
    else{
        return TRUE;
    }
}

+(UIButton *)getButtonInControl:(id)control frame:(CGRect)frame imageName:(NSString *)imageName title:(NSString *)title clickAction:(SEL)clickAction
{
	UIButton *btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
	if (imageName.length>0)
    {
        //修改by STar
		[btnCamera setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
	}
	if (title.length>0)
    {
		[btnCamera setTitle:title forState:UIControlStateNormal];
        [btnCamera setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnCamera.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        btnCamera.titleLabel.numberOfLines=0;
        btnCamera.layer.cornerRadius = 3; // this value vary as per your desire
        btnCamera.clipsToBounds = YES;
         btnCamera.titleLabel.font=[UIFont fontWithName:@"Arial" size:16];
	}
    
	btnCamera.frame = frame;
	[btnCamera addTarget:control action:clickAction forControlEvents:UIControlEventTouchUpInside];
	return btnCamera;
}
+(UIButton *)getButtonInControl:(id)control frame:(CGRect)frame imageName:(NSString *)imageName title:(NSString *)title  tag:(int)tag clickAction:(SEL)clickAction
{
	UIButton *btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
	if (imageName.length>0)
    {
		[btnCamera setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
	}
	if (title.length>0)
    {
		[btnCamera setTitle:title forState:UIControlStateNormal];
        [btnCamera setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnCamera.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        btnCamera.titleLabel.numberOfLines=0;
         btnCamera.titleLabel.adjustsFontSizeToFitWidth=YES;
        btnCamera.titleLabel.font=[UIFont fontWithName:@"Arial" size:16];
       
            btnCamera.layer.cornerRadius = 3; // this value vary as per your desire
            btnCamera.clipsToBounds = YES;
        
        
	}
    
    btnCamera.tag=tag;
	btnCamera.frame = frame ;
	[btnCamera addTarget:control action:clickAction forControlEvents:UIControlEventTouchUpInside];
	return btnCamera;
}

+(UIButton *)getButtonInControl:(id)control frame:(CGRect)frame normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName title:(NSString *)title  tag:(int)tag clickAction:(SEL)clickAction
{
    UIButton *btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    if (normalImageName.length>0)
    {
        [btnCamera setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    }
    if (selectedImageName.length>0)
    {
        [btnCamera setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    }
    if (title.length>0)
    {
        [btnCamera setTitle:title forState:UIControlStateNormal];
        [btnCamera setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnCamera.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        btnCamera.titleLabel.numberOfLines=0;
        btnCamera.titleLabel.adjustsFontSizeToFitWidth=YES;
        btnCamera.titleLabel.font=[UIFont fontWithName:@"Arial" size:16];
        
        btnCamera.layer.cornerRadius = 3; // this value vary as per your desire
        btnCamera.clipsToBounds = YES;
    }
    
    btnCamera.tag=tag;
    btnCamera.frame = frame ;
    [btnCamera addTarget:control action:clickAction forControlEvents:UIControlEventTouchUpInside];
    return btnCamera;
}

+(UIButton *)getButtonInControl:(id)control frame:(CGRect)frame  title:(NSString *)title align:(NSString *)align  color:(UIColor *)color fontsize:(int)fontsize tag:(int)tag clickAction:(SEL)clickAction imageName:(NSString *)imageName
{
    UIButton *btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    if (imageName.length>0)
    {
        [btnCamera setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (title.length>0)
    {
        [btnCamera setTitle:title forState:UIControlStateNormal];
        [btnCamera setTitleColor:color forState:UIControlStateNormal];
        btnCamera.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        btnCamera.titleLabel.numberOfLines=0;
        btnCamera.titleLabel.adjustsFontSizeToFitWidth=YES;
        // btnCamera.titleLabel.backgroundColor=UIColorFromRGB(0xFCFCFC);
        btnCamera.titleLabel.font=[UIFont fontWithName:@"Arial" size:fontsize];
        if ([align isEqualToString:@"left"]) {
            btnCamera.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
        else  if ([align isEqualToString:@"right"]) {
            btnCamera.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
        
        else {
            btnCamera.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }
        btnCamera.layer.cornerRadius = 3; // this value vary as per your desire
        btnCamera.clipsToBounds = YES;
        
    }
    
    btnCamera.tag=tag;
    btnCamera.frame = frame ;
    [btnCamera addTarget:control action:clickAction forControlEvents:UIControlEventTouchUpInside];
    return btnCamera;
}

+(UIButton *)getButtonInControl:(id)control frame:(CGRect)frame  title:(NSString *)title align:(NSString *)align  color:(UIColor *)color fontsize:(int)fontsize tag:(int)tag clickAction:(SEL)clickAction
{
	UIButton *btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];

	if (title.length>0)
    {
		[btnCamera setTitle:title forState:UIControlStateNormal];
        [btnCamera setTitleColor:color forState:UIControlStateNormal];
        btnCamera.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        btnCamera.titleLabel.numberOfLines=0;
        btnCamera.titleLabel.adjustsFontSizeToFitWidth=YES;
       // btnCamera.titleLabel.backgroundColor=UIColorFromRGB(0xFCFCFC);
        btnCamera.titleLabel.font=[UIFont fontWithName:@"Arial" size:fontsize];
        if ([align isEqualToString:@"left"]) {
             btnCamera.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
        else  if ([align isEqualToString:@"right"]) {
            btnCamera.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
        
        else {
            btnCamera.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }
        btnCamera.layer.cornerRadius = 3; // this value vary as per your desire
        btnCamera.clipsToBounds = YES;
      
	}
    
    btnCamera.tag=tag;
	btnCamera.frame = frame ;
	[btnCamera addTarget:control action:clickAction forControlEvents:UIControlEventTouchUpInside];
	return btnCamera;
}

+ (UIImage *) getThumbnailImage:(UIImage *)image width:(int)width height:(int)height
{
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  [UIImage imageWithData:UIImageJPEGRepresentation(newImage,0.5f)];
}
- (NSString *) platformString {
    // Gets a string with the device model
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch (1 Gen)";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch (2 Gen)";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch (3 Gen)";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch (4 Gen)";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    
    return platform;
}
+ (NSAttributedString *)stringConvertToAttrWith:(NSString *)string
{
    //其他文本
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *attrs = @{NSFontAttributeName             :[UIFont systemFontOfSize:12],
                            NSForegroundColorAttributeName  :[UIColor lightGrayColor]
                            };
    [attrStr addAttributes:attrs range:NSMakeRange(0, attrStr.length)];
    //数字富文本
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9.*]" options:0 error:nil];
    NSArray* matches = [regex matchesInString:string
                                      options:NSMatchingWithoutAnchoringBounds
                                        range:NSMakeRange(0, string.length)];
    for (NSTextCheckingResult* result in [matches reverseObjectEnumerator])
    {
        
        NSRange matchRange = [result range];
        NSDictionary *attr = @{NSFontAttributeName             :[UIFont systemFontOfSize:24],
                               NSForegroundColorAttributeName  :[UIColor blackColor]
                               };
        [attrStr addAttributes:attr range:matchRange];
        
    }
    return attrStr;
}
+(NSString *)stringcnFromHexString:(NSString *)hexString
{  // eg. hexString = @"8c376b4c"
    //16进制转中文
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:NSUnicodeStringEncoding];
    //    printf("%s\n", myBuffer);
    free(myBuffer);
    
    NSString *temp1 = [unicodeString stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *temp2 = [temp1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *temp3 = [[@"\"" stringByAppendingString:temp2] stringByAppendingString:@"\""];
    NSData *tempData = [temp3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *temp4 = [NSPropertyListSerialization propertyListFromData:tempData
                                                       mutabilityOption:NSPropertyListImmutable
                                                                 format:NULL
                                                       errorDescription:NULL];
    NSString *string = [temp4 stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
    
    NSLog(@"-------string----%@", string); //8c376b4c 输出 谷歌
    return string;
}

+(NSString *)stringFromHexString:(NSString *)hexString
{
    /*
     // The hex codes should all be two characters.
     if (([hexString length] % 2) != 0)
     return nil;
     
     NSMutableString *string = [NSMutableString string];
     
     for (NSInteger i = 0; i < [hexString length]; i += 2) {
     
     NSString *hex = [hexString substringWithRange:NSMakeRange(i, 2)];
     NSInteger decimalValue = 0;
     sscanf([hex UTF8String], "%x", &decimalValue);
     [string appendFormat:@"%c", decimalValue];
     }
     */
    
    NSMutableString * newString = [[NSMutableString alloc] init];
    int i = 0;
    while (i < [hexString length])
    {
        NSString * hexChar = [hexString substringWithRange: NSMakeRange(i, 2)];
        int value = 0;
        sscanf([hexChar cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
        [newString appendFormat:@"%c", (char)value];
        i+=2;
    }
    
    return [NSString stringWithFormat:@"%@",newString];
}
+(NSString*)intToHexString:(NSInteger)value
{
    //return [[NSString alloc] initWithFormat:@"%X", value];
    return [[NSString alloc] initWithFormat:@"%lX", value];
}
+(NSString*)hexToString:(NSInteger)value
{
    //return [[NSString alloc] initWithFormat:@"%X", value];
    return [[NSString alloc] initWithFormat:@"%lX", value];
    //strtoul([@"0x14" UTF8String],0,16);
}

+ (NSString *) stringFromHex:(NSString *)str
{
    NSMutableData *stringData = [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [str length] / 2; i++) {
        byte_chars[0] = [str characterAtIndex:i*2];
        byte_chars[1] = [str characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [stringData appendBytes:&whole_byte length:1];
    }
    NSLog(@"stringData=%@",stringData);
    return [[NSString alloc] initWithData:stringData encoding:NSASCIIStringEncoding];
}

+ (NSString *) stringToHex:(NSString *)str
{   //2342342转换成ASCII码
    /*
     NSUInteger len = [str length];
     unichar *chars = malloc(len * sizeof(unichar));
     [str getCharacters:chars];
     
     NSMutableString *hexString = [[NSMutableString alloc] init];
     
     for(NSUInteger i = 0; i < len; i++ )
     {
     [hexString appendString:[NSString stringWithFormat:@"%x", chars[i]]];
     }
     free(chars);
     
     return [hexString;
     */
    NSUInteger len = [str length];
    unichar *chars = malloc(len * sizeof(unichar));
    [str getCharacters:chars];
    
    NSMutableString *hexString = [[NSMutableString alloc] init];
    
    for(NSUInteger i = 0; i < len; i++ )
    {
        // [hexString [NSString stringWithFormat:@"%02x", chars[i]]]; /*previous input*/
        [hexString appendFormat:@"%02x", chars[i]]; /*EDITED PER COMMENT BELOW*/
    }
    free(chars);
    NSLog(@"hexString =%@",hexString);
    return hexString;
    
}
+(NSString*)hexRepresentationWithSpaces_AS:(NSData *)data
{//只能小写转大写好像没什么用
    BOOL spaces=YES;
    const unsigned char* bytes = (const unsigned char*)[data bytes];
    NSUInteger nbBytes = [data length];
    //If spaces is true, insert a space every this many input bytes (twice this many output characters).
    static const NSUInteger spaceEveryThisManyBytes = 4UL;
    //If spaces is true, insert a line-break instead of a space every this many spaces.
    static const NSUInteger lineBreakEveryThisManySpaces = 4UL;
    const NSUInteger lineBreakEveryThisManyBytes = spaceEveryThisManyBytes * lineBreakEveryThisManySpaces;
    NSUInteger strLen = 2*nbBytes + (spaces ? nbBytes/spaceEveryThisManyBytes : 0);
    
    NSMutableString* hex = [[NSMutableString alloc] initWithCapacity:strLen];
    for(NSUInteger i=0; i<nbBytes; ) {
        [hex appendFormat:@"%02X", bytes[i]];
        //We need to increment here so that the every-n-bytes computations are right.
        ++i;
        
        if (spaces) {
            if (i % lineBreakEveryThisManyBytes == 0) [hex appendString:@"\n"];
            else if (i % spaceEveryThisManyBytes == 0) [hex appendString:@" "];
        }
    }
    return hex;
}

+ (NSString *)stringTransform:(NSString *)chinese
{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return [pinyin uppercaseString];
}
+(void)openUrl:(NSString *)urlStr{
    //注意url中包含协议名称，iOS根据协议确定调用哪个应用，例如发送邮件是“sms://”其中“//”可以省略写成“sms:”(其他协议也是如此)
    NSURL *url=[NSURL URLWithString:urlStr];
    UIApplication *application=[UIApplication sharedApplication];
    if(![application canOpenURL:url]){
        NSLog(@"无法打开\"%@\"，请确保此应用已经正确安装.",url);
        return;
    }
    [[UIApplication sharedApplication] openURL:url];
}

+ (void)telephoneToSomebody:(NSString *)phoneNumber
{
        NSString *url=[NSString stringWithFormat:@"tel://%@",phoneNumber];//这种方式会直接拨打电话
//    NSString *url=[NSString stringWithFormat:@"telprompt://%@",phoneNumber];//这种方式会提示用户确认是否拨打电话
    [[self class] openUrl:url];
}

+ (void)sendMessageToSomebody:(NSString *)phoneNumber
{
    NSString *url=[NSString stringWithFormat:@"sms://%@",phoneNumber];
    [[self class] openUrl:url];
}

+ (void)sendEmailToSomebody:(NSString *)mailAddress
{
    NSString *url=[NSString stringWithFormat:@"mailto://%@",mailAddress];
    [[self class] openUrl:url];
}

+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    //加上离线属性防止备份到iClound
    if ([[NSFileManager defaultManager] fileExistsAtPath: [URL path]])
    {
        NSString *strVersion = [[UIDevice currentDevice] systemVersion];
        float fVersion = 0.0;
        if(strVersion.length > 0)
        {
            fVersion = [strVersion floatValue];
        }
        
         if (fVersion > 5.0 && fVersion < 5.1)
         {
             assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
             
             const char* filePath = [[URL path] fileSystemRepresentation];
             
             const char* attrName = "com.apple.MobileBackup";
             u_int8_t attrValue = 1;
             
             int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
             return result == 0;
             
         
         }
        else if (fVersion >= 5.0)
        {
            assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
            NSError *error = nil;
            
            BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                            
                                          forKey: NSURLIsExcludedFromBackupKey error: &error];
            
            if(!success)
            {
                
                NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
                
            }
            
            return success;
        }
        
       
    }
    return false;
    
}




+(BOOL)addDontBackUpCaches
{
    NSURL *urlDefault = nil;
    NSString *strDic = nil;
    
    NSString *strVersion = [[UIDevice currentDevice] systemVersion];
    float fVersion = 0.0;
    if(strVersion.length > 0)
        fVersion = [strVersion floatValue];
    
    if (fVersion == 5.0)
    {
        strDic = [NSString stringWithFormat:@"%@/Library/Caches/",
                  NSHomeDirectory()];
    }
    else
    {
        strDic = [NSString stringWithFormat:@"%@/Library/%@/",
                  NSHomeDirectory(),
                  [[NSBundle mainBundle] bundleIdentifier]];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:strDic])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:strDic withIntermediateDirectories:YES attributes:nil error:nil];
    }
    urlDefault = [NSURL fileURLWithPath:strDic];
    [self addSkipBackupAttributeToItemAtURL:urlDefault];
    return TRUE;
}

+ (NSData *) HexStringToData:(NSString *)command
{
    command = [command stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *commandToSend= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [command length]/2; i++) {
        byte_chars[0] = [command characterAtIndex:i*2];
        byte_chars[1] = [command characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [commandToSend appendBytes:&whole_byte length:1];
    }
    NSLog(@"commandToSend=%@", commandToSend);
    return commandToSend;
}


+(void)saveIsNeedLoginToBuy:(NSString  *)IsNeedLoginToBuy
{//是否要求登录才能购买
    [[NSUserDefaults standardUserDefaults] setValue:IsNeedLoginToBuy forKey:@"IsNeedLoginToBuy"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//检测IP格式
+(BOOL) isIp:(NSString *)checkString
{
    NSString *emailRegex = @"^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}



#define  iosLanguage  [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode]
#define iosCountryCode  [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode]
#define  APPID  @""

+(BOOL)appHasNewVersion
{
    
    NSString *appInfoUrl = [NSString stringWithFormat:@"https://itunes.apple.com/%@/lookup?id=%@",@"cn",APPID];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:appInfoUrl]];
    [request setHTTPMethod:@"GET"];
    
    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection  sendSynchronousRequest:request returningResponse: &response error: &error];
    if (!data) {
        return NO;
    }
    NSString *output = [NSString stringWithUTF8String:[data bytes]];
    
    NSError *e = nil;
    NSData *jsonData = [output dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error: &e];
    
    NSArray *arr=[jsonDict objectForKey:@"results"];
    if (arr&&arr.count>0)
    {
        NSString *version = [[arr objectAtIndex:0] objectForKey:@"version"];
        NSString *appShortVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        if ([version floatValue]>[appShortVersion floatValue])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    return NO;
}


+ (UIImage*)screenshot
{
    
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (&UIGraphicsBeginImageContextWithOptions)
    {
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    }
    else{
        // UIGraphicsBeginImageContext(imageSize);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            [[window layer] renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
