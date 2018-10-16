//
//  XlabTools.m
//  ColorBand
//
//  Created by fly on 15/5/12.
//  Copyright (c) 2015年 com.fenda. All rights reserved.
//

#import "XlabTools.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "NSString+Extension.h"
@implementation XlabTools
{
    unsigned int crc_table[256];
    MBProgressHUD *loadView;
}
SINGLETON_SYNTHE

+(BOOL)isNetConnect
{
    Reachability *r=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    BOOL ret=TRUE;
    switch ([r currentReachabilityStatus])
    {
        case NotReachable:
            return FALSE;
            break;
        default:
            break;
    }
    
    return ret;
}

+(BOOL)getTimeSys
{
    //TURE为12小时制，否则为24小时制。
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = containsA.location != NSNotFound;
    return hasAMPM;
}

+(NSString *)getAmOrPm
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"a"];
    NSString *AMPMtext = [dateFormatter stringFromDate:[NSDate date]];
    if ([AMPMtext isEqualToString:@"AM"])
    {
        AMPMtext = @"上午";
    }
    else
    {
        AMPMtext = @"下午";
    }
    
    return AMPMtext;
}

+ (BOOL)isEqueltheStringArray:(NSMutableArray *)arr1 withOtherStringArray:(NSMutableArray *)arr2
{
    if (arr1.count != arr2.count) {
        return NO;
    }
    
    
    for (int i = 0; i < arr1.count; i++) {
        NSString *str1 = arr1[i];
        NSString *str2 = arr2[i];
        if (![str1 isEqualToString:str2]) {
            return NO;
        }
        
    }
    
    return YES;
}

//持久化NSString类型
+(void)setStringValue:(id)value defaultKey:(NSString *)defaultKey
{
    NSString *str = [NSString stringWithFormat:@"%@",value];
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:defaultKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(id)getStringValueFromKey:(NSString *)defaultKey
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultKey];
}

//持久化BOOL状态值
+(void)setBoolState:(BOOL)loginState defaultKey:(NSString *)defaultKey
{
    [[NSUserDefaults standardUserDefaults] setBool:loginState forKey:defaultKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)getBoolState:(NSString *)defaultKey
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:defaultKey];
}

//移除userDefault
+ (void)removeNsuserDefault:(NSString *)defaultKey
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:defaultKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//查看所有的userdefault的值
+ (void)showAllUserDefaultsData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic = [userDefaults dictionaryRepresentation];
    for (id  key in dic) {
        NSLog(@"\nkey = %@  value = %@",key,dic[key]);
    }
}
/**
 *  清除所有的存储本地的数据
 */
+ (void)clearAllUserDefaultsData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic = [userDefaults dictionaryRepresentation];
    for (id  key in dic) {
        [userDefaults removeObjectForKey:key];
    }
    [userDefaults synchronize];
}


//按首字母排序并拼接成字符串
+ (NSString *)getStrFromDic:(NSDictionary *)dic
{
    
    NSArray *kArrSort = [dic allKeys]; //这里是字母数组:,g,a,b.y,m……
    NSArray *resultkArrSort = [kArrSort sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSLog(@"按字母排序后%@",resultkArrSort);
    
    NSString* signStr = @"";
    for (int i = 0; i<resultkArrSort.count; i++) {
        signStr = [NSString stringWithFormat:@"%@%@%@",signStr,resultkArrSort[i],[dic objectForKey:resultkArrSort[i]]];
    }
    
    return signStr;
}

// 是否wifi
+ (BOOL) IsEnableWIFI
{
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

// 是否3G
+ (BOOL) IsEnable3G
{
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}


+(BOOL)isRetinaDisplay
{
    int scale = 1.0;
    UIScreen *screen = [UIScreen mainScreen];
    if([screen respondsToSelector:@selector(scale)])
        scale = screen.scale;
    
    if(scale == 2.0f) return YES;
    else return NO;
}

+(int)getSystemMainVersion
{
    //NSLog(@"%@",[[UIDevice currentDevice] systemVersion] );
    NSString *version = [[UIDevice currentDevice] systemVersion];
    NSArray *array = [version componentsSeparatedByString:@"."];
    //TODO: for iphone 4  ios 5
    return [[array objectAtIndex:0]intValue];
}



//是否是中文.包括繁体
+(BOOL)isChinese
{
    if([[self currentLanguage] compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame || [[self currentLanguage] compare:@"zh-Hant" options:NSCaseInsensitiveSearch]==NSOrderedSame)
    {
        return YES;
    }
    else
    {
        return NO;
        
    }
}


+(NSString*)currentLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = [languages objectAtIndex:0];
    return currentLang;
}


+(NSString *)deviceName
{
    UIDevice *device = [UIDevice currentDevice];
    return [device name];
}

+(NSUUID*)uuid
{
    UIDevice *device = [UIDevice currentDevice];
    return [device identifierForVendor];
}

+(NSString*)UUIDString
{
    return [[self uuid]UUIDString];
}

//hex 装换成Nsdata
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


/**
 压图片质量 不能循环多张
 
 @param image image
 @return Data
 */
+ (NSData *)zipImageWithImage:(UIImage *)image withMaxSize:(NSInteger)kBit
{
    if (!image) {
        return nil;
    }
    CGFloat maxFileSize = kBit*1024;
    CGFloat compression = 0.9f;
    NSData *compressedData = UIImageJPEGRepresentation(image, compression);
    int i = 0;
    while ([compressedData length] > maxFileSize) {
        compression *= 0.9;
        compressedData = UIImageJPEGRepresentation([[self class] compressImage:image newWidth:image.size.width*compression], compression);
        i++;
    }
    //NSLog(@"循环处理次数 === %d",i);
    return compressedData;
}

/**
 *  等比缩放本图片大小
 *
 *  @param newImageWidth 缩放后图片宽度，像素为单位
 *
 *  @return self-->(image)
 */
+ (UIImage *)compressImage:(UIImage *)image newWidth:(CGFloat)newImageWidth
{
    @autoreleasepool {
        if (!image) return nil;
        float imageWidth = image.size.width;
        float imageHeight = image.size.height;
        float width = newImageWidth;
        float height = image.size.height/(image.size.width/width);
        
        float widthScale = imageWidth /width;
        float heightScale = imageHeight /height;
        
        // 创建一个bitmap的context
        // 并把它设置成为当前正在使用的context
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        
        if (widthScale > heightScale) {
            [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
        }
        else {
            [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
        }
        
        // 从当前context中创建一个改变大小后的图片
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
        
        return newImage;
    }
}
//图片压缩处理500*500
+(UIImage *)scaleImage:(UIImage *)image tosize:(CGSize)size{
    UIImage *newImage;
    int h = image.size.height;
    int w = image.size.width;
    if (h <= size.height && w <= size.width) {
        newImage = image;
    }else{//等比缩放
        float newImageWidth = 0.0f;
        float newImageHeight = 0.0f;
        
        float whcare = (float)w/h;
        float hwcare = (float)h/w;
        if (w > h) {
            newImageWidth = (float)size.width;
            newImageHeight = size.width * hwcare;
        }else{
            newImageWidth = size.height*whcare;
            newImageHeight = (float)size.height;
        }
        CGSize newSize = CGSizeMake(newImageWidth, newImageHeight);
        UIGraphicsBeginImageContext(newSize);
        CGRect imageRect = CGRectMake(0.0, 0.0,newImageWidth,newImageHeight);
        [image drawInRect:imageRect];
        UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        newImage = newImg;
        
    }
    
    return newImage;
}

+(NSData *)imageData:(UIImage *)myimage
{
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(myimage, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(myimage, 0.3);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(myimage, 0.5);
        }
    }
    return data;
}


//获取字段长度
+ (CGSize)getSizeFromString:(NSString *)string withFont:(CGFloat)floatNumber wid:(CGFloat)wid
{
    CGSize size;
    if (iOS7) {
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:floatNumber],NSFontAttributeName,nil];
        size = [string boundingRectWithSize:CGSizeMake(wid,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    }else{
        //              size = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(SCREEN_WIDTH-80.0,MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    }
    return size;
}



//获取url链接字符串中的参数
+(NSString *) jiexi:(NSString *)CS webaddress:(NSString *)webaddress
{
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?|://)+%@=+([^&]*)(&|$)",CS];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:webaddress
                                      options:0
                                        range:NSMakeRange(0, [webaddress length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [webaddress substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        NSLog(@"分组2所对应的串:%@\n",tagValue);
        return tagValue;
    }
    return @"";
}

/**
 *  int类型的数据转换成NSData
 *
 *  @param operatetype 需要转换的int类型
 *
 *  @return 返回转换好的NSData类型
 */
+(NSData *)intTochar:(int)operatetype
{
    NSNumber *data = [NSNumber numberWithChar:operatetype];
    char value = [data charValue];
    NSMutableData *charData = [NSMutableData dataWithBytes:&value length:sizeof(char)];
    
    return charData;
}


//计算CRC值（128）
+ (uint16_t)creatCRCWith:(NSData *)data withLenth:(NSInteger)lenth
{
    uint16_t crc = 0xffff;
    Byte *testByte = (Byte *)[data bytes];
    for (int i = 0; i<lenth; i++)
    {
        crc = (unsigned char)(crc>>8)| (crc<<8);
        crc ^= testByte[i];
        crc ^= (unsigned char)(crc & 0xff)>>4;
        crc ^= (crc << 8)<<4;
        crc ^= ((crc & 0xff)<<4)<<1;
    }
    return crc;
}


//生成随机数
+ (NSString*) randomWithLengh:(int)randomLength
{
    static char* RANDOM_STR = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    static int RANDOM_STR_LEN = 62;
    
    NSMutableData* tmpBuf = [NSMutableData dataWithLength:randomLength];
    char* tmpPointer = [tmpBuf mutableBytes];
    for (int i = 0; i < randomLength; i++)
    {
        tmpPointer[i] = RANDOM_STR[arc4random() % RANDOM_STR_LEN];
    }
    NSString* result = [[NSString alloc] initWithData:tmpBuf encoding:NSASCIIStringEncoding];//[NSString stringWithCString:tmpPointer encoding:NSASCIIStringEncoding];
    
    return result;
}

//添加by Star
+ (BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL) isNumber:(NSString *)str
{
    for(int i=0;i<str.length;i++)
    {
        char a = [str characterAtIndex:i];
        if(a<'0'||a>'9')
            return NO;
    }
    
    return YES;
}

//两个字节的数据移位操作
+ (UInt16)NSDataToUInt16:(NSData*)data
{
    UInt16 number = 0;
    [data getBytes:&number length:sizeof(number)];
    number = (((number>>8)&0xFF)) | ((number<<8)&0xFF);
    return number;
}
//四个字节的数据移位操作
+ (UInt32) NSDataToUInt32:(NSData *)data
{
    UInt32 number  = 0;
    [data getBytes:&number length:sizeof(UInt32)];
    number = ((number&0xFF)<<24) | (((number>>8)&0xFF)<<16) | (((number>>16)&0xFF)<<8) | ((number >>24)&0xFF);
    return number;
}

//生成初始化的crc表
- (void)initCrcTable
{
    unsigned int c;
    unsigned int i,j;
    for (i = 0; i < 256; i ++)
    {
        c = (unsigned int)i;
        for (j = 0; j < 8; j ++)
        {
            if (c & 1)
            {
                c = 0xedb88320L ^ (c>>1);
            }
            else
            {
                c = c>>1;
            }
        }
        crc_table[i] = c;
    }
}
- (uint32_t)crc32WithData:(NSData *)data
{
    uint32_t crc = 0xffffffff;
    Byte *testByte = (Byte *)[data bytes];
    for (int i = 0; i < data.length; i ++)
    {
        crc = crc_table[(crc ^ testByte[i]) & 0xff] ^ (crc>>8);
    }
    return crc;
}


+ (int)timeFromDateString:(NSString *)dateString withType:(int)type
{
    if ([dateString containAnotherString:@":"])  //以 00:00 模式进来的时间
    {
        NSArray *array = [dateString componentsSeparatedByString:@":"];
        int hour = [array[0] intValue];
        int munite = [array[1] intValue];
        switch (type) {
            case 0:
                return hour;
                break;
            case 1:
                return munite;
                break;
            default:
               
                break;
        }
    }else if ([dateString containAnotherString:@"小时"])  //包含小时
    {
        NSArray *array = [dateString componentsSeparatedByString:@"小时"];
        NSString *hourStr = array[0];
        int hour = [hourStr intValue];
        
        NSString *minuteStr = array[1];
        NSArray *minArr = [minuteStr componentsSeparatedByString:@"分"];
        NSString *minStr = [minArr objectAtIndex:0];
        int minute = [minStr intValue];
        switch (type) {
            case 0:
                return hour;
                break;
            case 1:
                return minute;
                break;
            default:
                
                break;
        }
    }else //没有小时并且没有冒号则为纯数字：表示分钟
    {
        int mins = [dateString intValue];
        switch (type) {
            case 0:
                return mins/60;
                break;
            case 1:
                return mins%60;
                break;
            default:                
                break;
        }
    }
    return 0;
}
//将十进制转化为二进制,设置返回NSString长度
+ (NSString *)decimalTOBinary:(uint16_t)tmpid backLength:(int)length
{
    NSString *a = @"";
    while (tmpid)
    {
        a = [[NSString stringWithFormat:@"%d",tmpid%2] stringByAppendingString:a];
        if (tmpid/2 < 1)
        {
            break;
        }
        tmpid = tmpid/2 ;
    }
    
    if (a.length <= length)
    {
        NSMutableString *b = [[NSMutableString alloc]init];;
        for (int i = 0; i < length - a.length; i++)
        {
            [b appendString:@"0"];
        }
        a = [b stringByAppendingString:a];
    }
    return a;
    
}

+ (NSDictionary *)fitterDicNullValue:(NSDictionary *)dic
{
    NSMutableDictionary *mulDic = [dic mutableCopy];
    for(NSString *key in [dic allKeys])
    {
        NSString *value = dic[key];
        if(![value isKindOfClass:[NSString class]])
            continue;
        if(value.length<=0)
           [mulDic removeObjectForKey:key];
    }
    return mulDic;
}
// 模型转字典  注:模型里属性不能包含其他模型，只能是OC基础数据类型
+ (NSDictionary *)modelConvertToDictionary:(id)model
{
    if ([model isKindOfClass:[NSDictionary class]]) {
        return model;
    }
    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([model class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        const char* char_f =property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [props addObject:propertyName];
    }
    free(properties);
    NSDictionary *dic = [model dictionaryWithValuesForKeys:props];
    //如果遇到字典nil的值，最后转成NSNull类型
    return dic;
}

+ (id)jsonConvertToId:(NSString *)json
{
    NSData* data = [json dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers error:&error];
    if (error != nil) return nil;
    return result;
}
//获取模型属性数组
+ (NSArray *)getPropertiesFromModel:(id)model
{
    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([model class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        const char* char_f =property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [props addObject:propertyName];
    }
    free(properties);
    return props;
}
// 字典或数组转成 json 字符串
+ (NSString *)dictionaryConvertToJSONObjectStr:(id )dic
{
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonStr = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    return jsonStr;
}

+(NSString*)UrlencodeString:(NSString*)unencodedString
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}
+(void )array:(NSMutableArray *)mArray OrderByArray:(NSArray <NSNumber *>*)array
{
    for (NSNumber *num in array) {
        NSMutableArray *mArr = [array mutableCopy];
        [mArr removeObject:num];
        if ([mArr containsObject:num]) {
            NSLog(@"给的排序数组有问题");
            return;
        }
        if (num.intValue > mArray.count) {
            NSLog(@"给的排序数组有问题");
            return;
        }
    }
    
    NSMutableArray *newArr = [NSMutableArray new];
    for (int i = 0; i < array.count; i ++) {
        NSInteger index = [array[i] integerValue];
        [newArr addObject:mArray[index]];
    }
    
    [mArray removeObjectsInArray:newArr];
    [mArray insertObjects:newArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newArr.count)]];
}


#pragma mark --UIColor 转UIImage
/**
 *  UIColor 转UIImage
 *
 *  @param color <#color description#>
 *
 *  @return <#return value description#>
 */
+(UIImage*)ChangeUIColorToUIImage: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark --UIView转UIImage
/**
 *  UIView转UIImage
 *
 *  @param v <#v description#>
 *
 *  @return <#return value description#>
 */
+(UIImage*)convertViewToImage:(UIView*)v{
    
    //    UIGraphicsBeginImageContext(v.bounds.size);
    //
    //    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    //
    //    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    //
    //    UIGraphicsEndImageContext();
    //
    //    return image;
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



#pragma mark --十六进制转换为普通字符串的。
/**
 *  十六进制转换为普通字符串的。
 *
 *  @param hexString <#hexString description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)stringFromHexString:(NSString *)hexString { //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
}

#pragma mark --普通字符串转换为十六进制的。
/**
 *  普通字符串转换为十六进制的。
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
/**
 *  颜色转换 IOS中十六进制的颜色转换为UIColor
 *
 *  @param color <#color description#>
 *
 *  @return <#return value description#>
 */
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


/**
 *  绘图
 *
 *  @param colorName <#colorName description#>
 *
 *  @return <#return value description#>
 */
+(UIImage *)drawcolorInImage:(NSString *)colorName{
    CGRect rect = CGRectMake(0, 0, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context,
                                   [[self colorWithHexString:colorName] CGColor]);
    //  [[UIColor colorWithRed:222./255 green:227./255 blue: 229./255 alpha:1] CGColor]) ;
    CGContextFillRect(context, rect);
    UIImage * imge;// = [[UIImage alloc] init];
    imge = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imge;
    
}

#pragma mark --图片缩放到指定大小尺寸
/**
 *  图片缩放到指定大小尺寸
 *
 *  @param img  <#img description#>
 *  @param size <#size description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

//把NSlog输出到txt文件中去,用于真机模拟
+ (void) redirectConsoleLogToDocumentFolder
{
    
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [paths objectAtIndex:0];
    //
    //
    //    //    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",[DateAndTimehandle getCurentDateByType:@"yyyy-MM-dd HH:mm:ss" withUTC:NO]]];
    //
    //
    //
    //
    //    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.txt",LOGINFO_APPEXCEPTION,LOGINFO_APPOUTPUT]];
    
    NSString * str = [[XlabTools sharedInstance] creatFileDictionaryWithFile:[NSString stringWithFormat:@"%@.txt",@"hello"] withfile:@"hello"];
    
    freopen([str cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}

- (NSString *)creatFileDictionaryWithFile:(NSString *)file  withfile:(NSString *)fileName
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName];
    BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    NSAssert(bo,@"创建目录失败");
    
    NSString *result = [path stringByAppendingPathComponent:file];
    return result;
}

+ (NSString *)getNetWorkStates
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children)
    {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")])
        {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            
            switch (netType)
            {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state =  @"2G";
                    break;
                case 2:
                    state =  @"3G";
                    break;
                case 3:
                    state =   @"4G";
                    break;
                case 5:
                    state =  @"wifi";
                    break;
                default:
                    break;
            }
        }
        
    }
    //根据状态选择
    return state;
}

//获取当前的UIViewController
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}


@end


