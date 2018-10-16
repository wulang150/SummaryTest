//
//  PublicFunction.h
//  houseManage
//
//  Created by zhu xian on 12-3-3.
//  Copyright 2012 z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AddressBook/AddressBook.h>
#import <MBProgressHUD.h>

@interface PublicFunction : NSObject

+ (void ) hiddenHUD;
+ (MBProgressHUD *) showLoading:(NSString *)title;
+ (MBProgressHUD *) showTouchLoading:(NSString *)title;
+ (MBProgressHUD *) showLoading:(NSString *)message hiddenAfterDelay:(int)second;
+ (MBProgressHUD *) showNoHiddenLoading:(NSString *)title;

//UI视图快捷创建
+(UIImageView *) getImageView:(CGRect)frame imageName:(NSString *)imageName;

//UI视图快捷创建
+(UITextView *) getTextView:(CGRect)frame text:(NSString *)text size:(int)size;
+(UITextField *) getTextFieldInControl:(id)control frame:(CGRect)frame  tag:(NSInteger)tag  returnType:(NSString *)returnType text:(NSString *)text placeholder:(NSString *)placeholder;
+(UITextField *) addTextField:(CGRect)frame  tag:(NSInteger)tag returnType:(NSString *)returnType;


//UI视图快捷创建
+(UILabel *) getlabel:(CGRect)frame text:(NSString *)text textSize:(int)size  textColor:(UIColor *)textColor textBgColor:(UIColor *)bgcolor  textAlign:(NSString *)align;
+(UILabel *) getlabel:(CGRect)frame text:(NSString *)text font:(UIFont *)font;
+(UILabel *) getlabel:(CGRect)frame text:(NSString *)text;
+(UILabel *) getlabel:(CGRect)frame text:(NSString *)text size:(int)size align:(NSString *)align;
+(UILabel *) getlabel:(CGRect)frame text:(NSString *)text size:(int)size;
+(UILabel *) getlabel:(CGRect)frame text:(NSString *)text imageName:(NSString *)imageName;
+(UILabel *) getlabel:(CGRect)frame text:(NSString *)text fontSize:(int)fontSize color:(UIColor *)color align:(NSString *)align;
+(UILabel *) getlabel:(CGRect)frame text:(NSString *)text align:(NSString *)align;
+(UILabel *) getlabel:(CGRect)frame text:(NSString *)text fontSize:(int)fontSize color:(UIColor *)color;
+(UILabel *) getlabel:(CGRect)frame text:(NSString *)text color:(UIColor *)color size:(NSInteger)size;
+(UILabel *) getlabel:(CGRect)frame text:(NSString *)text BGColor:(UIColor *)BGColor textColor:(UIColor *)textColor size:(NSInteger)size;

//UI视图快捷创建
+(UITextView *)getTextViewInControl:(id)control frame:(CGRect)frame  tag:(NSInteger)tag returnType:(NSString *)returnType;
+(UITextField *)getTextFieldInControl:(id)control frame:(CGRect)frame  tag:(NSInteger)tag returnType:(NSString *)returnType;

//UI视图快捷创建
+(UIButton *) getButtonInControl:(id)control frame:(CGRect)frame  title:(NSString *)title align:(NSString *)align  color:(UIColor *)color fontsize:(int)fontsize tag:(int)tag clickAction:(SEL)clickAction imageName:(NSString *)imageName;
+(UIButton *) getButtonInControl:(id)control frame:(CGRect)frame imageName:(NSString *)imageName title:(NSString *)title clickAction:(SEL)clickAction;
+(UIButton *) getButtonInControl:(id)control frame:(CGRect)frame  title:(NSString *)title align:(NSString *) align  color:(UIColor *)color fontsize:(int)fontsize tag:(int)tag clickAction:(SEL)clickAction;
+(UIButton *) getButtonInControl:(id)control frame:(CGRect)frame imageName:(NSString *)imageName title:(NSString *)title  tag:(int)tag clickAction:(SEL)clickAction;
+(UIButton *) getButtonInControl:(id)control frame:(CGRect)frame normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName title:(NSString *)title  tag:(int)tag clickAction:(SEL)clickAction;
//UI控件操作
//图像操作
+ (UIImage *) getThumbnailImage:(UIImage *)image width:(int)width height:(int)height;
+ (UIImage *) getImage:(UIImage *)image width:(int)width height:(int)height;
+ (UIImage *) getImage:(NSString *)imageName;
+ (UIImage *) creatTwoCodeImageWithURL:(NSString *)url;  //通过字符串生成二维码图像
+ (UIImage *) getImageFromView: (UIView *)theView;       //获取当前视图截图
+ (UIImage *)imagesMergeWith:(NSArray *)images andSize:(CGSize)size; //将四张以内图片合并为一张

//颜色操作
+ (UIColor *) colorFromHexString:(NSString *)hexString;
+ (UIColor *) getColorByImage:(NSString *)imageName;

//date操作
+ (NSString *) getDateTime:(NSString *)format date:(NSDate *)date; //返回相应模式的Date字符串yyyy-MM-dd HH:mm:ss:fff 
+ (BOOL) dateCompare:(NSString *)from to:(NSString *)to; //比较两个日期的大小
+ (NSString *) getMonthFromNow:(int)month;
+ (NSArray *) getDayOfWeek:(NSString *)dateTime;
+ (NSString *) getLastMonth;
+ (NSArray *) getdaysArrayByTheDate:(NSString *)dateStr withType:(NSString *)type;
+ (NSInteger ) daysWithinEraFromDate:(NSString *)beforeDay toDate:(NSString *)behindDay;
+ (NSString *) getTomorrowAndYesterDayByCurrentDate:(NSString *)date byIndex:(NSInteger)index withType:(NSString *)type;

//启动设备应用
//电话 = “telprompt://10086” 短信 = “sms://10086” 邮件 = "mailto://123@qq.com"
+ (void)openUrl:(NSString *)urlStr;
+ (void)telephoneToSomebody:(NSString *)urlStr;
+ (void)sendMessageToSomebody:(NSString *)urlStr;
+ (void)sendEmailToSomebody:(NSString *)urlStr;

//用户权限操作（不知道有啥用。。。）
+ (BOOL) addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
+ (BOOL) addDontBackUpCaches;
+ (BOOL) getPowerByType:(NSString *)type andAddEditDel:(NSString *)addEditDel;
+ (BOOL) canDelete;

//检测格式
+ (BOOL) isIp:(NSString *)checkString;    //检测IP格式
+ (BOOL) isDate:(NSString *)checkString;  //检测日期格式
+ (BOOL) isAlphaNumeric:(NSString *)checkString; //检测数字字母汉字
+ (BOOL) isEmail:(NSString *)checkString;  //检测email格式
+ (BOOL) isValidInput:(NSString *)checkString; //检测数字字母下划线
+ (BOOL) isIdCarNumber:(NSString *)checkString;  //检测email格式
+ (BOOL) isFloat:(NSString *)checkString;
+ (BOOL) isNumber:(NSString *)checkString;

//富文本
+ (NSAttributedString *)stringConvertToAttrWith:(NSString *)string; //数字与其他文本分开处理

//字符串的一些操作（蓝牙数据交互字符转换用）
+ (NSString *) stringcnFromHexString:(NSString *)hexString;
+ (NSString *) stringFromHexString:(NSString *)hexString;
+ (NSString *) intToHexString:(NSInteger)value;
+ (NSString *) hexToString:(NSInteger)value;
+ (NSString *) stringFromHex:(NSString *)str;
+ (NSString *) stringToHex:(NSString *)str;
+ (NSString *) hexRepresentationWithSpaces_AS:(NSData *)data;
+ (NSString *) stringTransform:(NSString *)chinese;  //汉字转拼音

//蓝牙交互
+ (NSData *) HexStringToData:(NSString *)command;//将16进制字符原封不动转nsdata
+ (NSData *) hexStringToNSData:(NSString *)command;
+ (NSData *) bytesFromHexString:(NSString *)aString;
+ (NSData *) getValidCharsForData:(NSData *)data withLength:(NSInteger)length;//根据所需要的最大长度取出有效的data数据，以确保转换成字符时不会乱码


+ (BOOL)appHasNewVersion;



//截屏
+ (UIImage*)screenshot;
@end
