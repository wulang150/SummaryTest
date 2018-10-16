//
//  XlabTools.h
//  ColorBand
//
//  Created by fly on 15/5/12.
//  Copyright (c) 2015年 com.fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@class MBProgressHUD;
@interface XlabTools : NSObject
{
    MBProgressHUD *_loadingView;
    NSUInteger _loadingCount;
}

#define SINGLETON_SYNTHE \
+ (id)sharedInstance\
{\
static id shared = nil;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken,\
^{\
shared = [[self alloc]init];\
});\
return shared;\
}



#define SINGLETON + (id)sharedInstance;

SINGLETON



//检测是否有网络
+(BOOL)isNetConnect;
// 是否wifi
+ (BOOL) IsEnableWIFI;
// 是否3G
+ (BOOL) IsEnable3G;



//判断当前时间的制式
+(BOOL)getTimeSys;
//判断当前是上下午
+(NSString *)getAmOrPm;
//持久化数据
+(void)setStringValue:(id)value defaultKey:(NSString *)defaultKey;
//获取持久化的数据
+(id)getStringValueFromKey:(NSString *)defaultKey;
//持久化BOOL状态值
+(void)setBoolState:(BOOL)loginState defaultKey:(NSString *)defaultKey;
+(BOOL)getBoolState:(NSString *)defaultKey;

//移除userDefault
+ (void)removeNsuserDefault:(NSString *)defaultKey;

//查看所有的userdefault的值
+ (void)showAllUserDefaultsData;
/**
 *  清除所有的存储本地的数据
 */
+ (void)clearAllUserDefaultsData;

//按首字母排序并拼接成字符串
+ (NSString *)getStrFromDic:(NSDictionary *)dic;

+(BOOL)isRetinaDisplay;
+(int)getSystemMainVersion;

//装字符串的数组,对比
+ (BOOL)isEqueltheStringArray:(NSMutableArray *)arr1 withOtherStringArray:(NSMutableArray *)arr2;

+(BOOL)isChinese;
+(NSString*)currentLanguage;
+(NSString *)deviceName;

+(NSUUID*)uuid;
+(NSString*)UUIDString;


+(NSData*)hexStringToNSData:(NSString *)command;
+(NSData*)bytesFromHexString:(NSString *)aString;


// 等比例压缩高清 kBit 压缩后的数据大小
+ (NSData *)zipImageWithImage:(UIImage *)image withMaxSize:(NSInteger)kBit;
//图片等比压缩处理500*500
+ (UIImage *)scaleImage:(UIImage *)image tosize:(CGSize)size;
//根据图片大小，适当进行图片压缩
+(NSData *)imageData:(UIImage *)myimage;

//获取字段长度
+ (CGSize)getSizeFromString:(NSString *)string withFont:(CGFloat)floatNumber wid:(CGFloat)wid;

//获取url链接字符串中的参数
+ (NSString *)jiexi:(NSString *)CS webaddress:(NSString *)webaddress;
/**
 *  int类型的数据转换成NSData
 *
 *  @param operatetype 需要转换的int类型
 *
 *  @return 返回转换好的NSData类型
 */
+(NSData *)intTochar:(int)operatetype;

//计算CRC值（128）
+ (uint16_t)creatCRCWith:(NSData *)data withLenth:(NSInteger)lenth;

// 随机数（8~20位长，允许0-9数字和a-zA-Z字母），用于关联所生成的验证码图形信息。
+ (NSString*)randomWithLengh:(int)randomLength;

//两个字节的数据移位操作
+ (UInt16)NSDataToUInt16:(NSData*)data;
//四个字节的数据移位操作
+ (UInt32) NSDataToUInt32:(NSData *)data;

+ (int)timeFromDateString:(NSString *)dateString withType:(int)type;
//将十进制转化为二进制,设置返回NSString长度
+ (NSString *)decimalTOBinary:(uint16_t)tmpid backLength:(int)length;

//生成crc值用到的两个方法
- (void)initCrcTable;
- (uint32_t)crc32WithData:(NSData *)data;

/****************** by Janson ************************/

//过滤字典中空的值
+ (NSDictionary *)fitterDicNullValue:(NSDictionary *)dic;
// 模型转字典
+ (NSDictionary *)modelConvertToDictionary:(id)model;
//json字符串转类型
+ (id)jsonConvertToId:(NSString *)json;
//获取模型属性数组
+ (NSArray *)getPropertiesFromModel:(id)model;
// 字典转成 json 字符串
+ (NSString *)dictionaryConvertToJSONObjectStr:(id)dic;
//url编码
+(NSString*)UrlencodeString:(NSString*)unencodedString;
//数组按给定序号重新排列
+(void )array:(NSMutableArray *)mArray OrderByArray:(NSArray <NSNumber *>*)array;

/********************* by  zhuochunsheng****************/
/**
 *  UIColor 转UIImage
 */
+(UIImage*)ChangeUIColorToUIImage: (UIColor*) color;

/**
 *  UIView转UIImage
 */
+(UIImage*)convertViewToImage:(UIView*)v;

/**
 *  十六进制转换为普通字符串的。
 */
+ (NSString *)stringFromHexString:(NSString *)hexString;

/**
 *  普通字符串转换为十六进制的。
 */
+ (NSString *)hexStringFromString:(NSString *)string;

/**
 *  颜色转换 IOS中十六进制的颜色转换为UIColor
 */
+ (UIColor *) colorWithHexString: (NSString *)color;

/**
 *  绘图
 */
+(UIImage *)drawcolorInImage:(NSString *)colorName;

/**
 *  图片缩放到指定大小尺寸
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

+ (void) redirectConsoleLogToDocumentFolder;

//获取网络状态
+ (NSString *)getNetWorkStates;
//获取当前的UIViewController
+ (UIViewController *)getCurrentVC;
@end
