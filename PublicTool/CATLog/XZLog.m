
//
//  Created by zhuochunsheng on 16/6/30.
//  Copyright © 2016年 fenda. All rights reserved.
//

#import "XZLog.h"
#import <UIKit/UIKit.h>
#import <mach/mach_host.h>
#import <mach-o/ldsyms.h>

//log color
#define XCODE_COLORS_ESCAPE_MAC @"\033["
#define XCODE_COLORS_ESCAPE_IOS @"\xC2\xA0["

#if 0//TARGET_OS_IPHONE
#define XCODE_COLORS_ESCAPE  XCODE_COLORS_ESCAPE_IOS
#else
#define XCODE_COLORS_ESCAPE  XCODE_COLORS_ESCAPE_MAC
#endif

#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"
static NSMutableDictionary* colorDic = nil;
static NSMutableDictionary* bgColorDic = nil;

// 文件夹string
static NSString *logFilePath = nil;
static NSString *logDic      = nil;
static NSString *crashDic    = nil;

// 设置默认保留文件天数为5天
static NSInteger numberOfDaysToDelete = 3;

// logQueue
static dispatch_once_t logQueueCreatOnce;
static dispatch_queue_t logOperationQueue;

//默认颜色
static NSString *logColor = nil;

//关闭所有输出
static BOOL isCloseOut = NO;

void uncaughtExceptionHandler(NSException *exception){
    [XZLog logCrash:exception];
}

@implementation XZLog

#pragma mark --
#pragma mark -- public methods

+ (void)initLog{
    [self _initFile];
    logColor = FDColor(0, 0, 0);
    dispatch_once(&logQueueCreatOnce, ^{
        logOperationQueue =  dispatch_queue_create("com.xzlog.app.operationqueue", DISPATCH_QUEUE_SERIAL);
        
    });
    //崩溃日志
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
}

+ (void)logCrash:(NSException *)exception{
    if (!exception) return;
   
    //获取时间
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSString *timeStr=[dateFormatter stringFromDate:senddate];
    //获取系统语言
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *phoneLanguage = [languages objectAtIndex:0];
    
    NSString *crashLog = [NSString stringWithFormat:@"\ncrash time:%@\nexceptionType:%@\ncrash reason:%@\ncrash stack info:%@\niOS Version:%@ Language:%@\ncpuType:%@\nUUID:%@",timeStr,[exception name],[exception reason],[exception callStackSymbols],[[UIDevice currentDevice] systemVersion],phoneLanguage,[self gainCpuType],[self gainExecutableUUID]];
#ifdef DEBUG
    NSLog(@"%@",crashLog);
#endif
    if (!crashDic) {
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *crashDirectory = [documentsDirectory stringByAppendingString:@"/log/"];
        crashDic = crashDirectory;
    }
    
    NSString *fileName = [NSString stringWithFormat:@"CRASH_%@.log",[self _getCurrentTime]];
    NSString *filePath = [crashDic stringByAppendingString:fileName];
    
    NSError *error = nil;
    [crashLog writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];

    if (error) {
        NSLog(@"error is %@",error);
    }
    //保存要上传的的数据
//    [NetWorkFriend setErrorLogWithSystem:[[UIDevice currentDevice] systemVersion] language:phoneLanguage error:content];
}

//获取cpu类型
+ (NSString *)gainCpuType
{
    host_basic_info_data_t hostInfo;
    mach_msg_type_number_t infoCount;
    
    infoCount = HOST_BASIC_INFO_COUNT;
    host_info(mach_host_self(), HOST_BASIC_INFO, (host_info_t)&hostInfo, &infoCount);
    
    NSString *type = @"other";
    switch (hostInfo.cpu_type) {
        case CPU_TYPE_ARM:
//            NSLog(@"CPU_TYPE_ARM");
            type = @"ARM";
            break;
            
        case CPU_TYPE_ARM64:
//            NSLog(@"CPU_TYPE_ARM64");
            type = @"ARM64";
            break;
            
        case CPU_TYPE_X86:
//            NSLog(@"CPU_TYPE_X86");
            type = @"X86";
            break;
            
        case CPU_TYPE_X86_64:
//            NSLog(@"CPU_TYPE_X86_64");
            type = @"X86_64";
            break;
            
        default:
            break;
    }
    return type;
}
//获取运行文件的UUID
+ (NSString *)gainExecutableUUID
{
    const uint8_t *command = (const uint8_t *)(&_mh_execute_header + 1);
    for (uint32_t idx = 0; idx < _mh_execute_header.ncmds; ++idx) {
        if (((const struct load_command *)command)->cmd == LC_UUID) {
            command += sizeof(struct load_command);
            return [NSString stringWithFormat:@"%02X%02X%02X%02X-%02X%02X-%02X%02X-%02X%02X-%02X%02X%02X%02X%02X%02X",
                    command[0], command[1], command[2], command[3],
                    command[4], command[5],
                    command[6], command[7],
                    command[8], command[9],
                    command[10], command[11], command[12], command[13], command[14], command[15]];
        } else {
            command += ((const struct load_command *)command)->cmdsize;
        }
    }
    return nil;
}

/**
 *  设置文件夹保存几天的数据
 *
 *  @param number 多少天
 */
+(void)setNumberOfDaysToDelete:(NSInteger)number{
    numberOfDaysToDelete = number;
}

+(void)_initFile
{
    // 大文件的命名，例如2016-06-24，生成文件夹
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1 = [NSDate date];
    NSString *dateString1 = [dateFormatter1 stringFromDate:date1];
    
    // documentDirectory目录string
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *logDirectory = [documentsDirectory stringByAppendingFormat:@"/log/%@/",dateString1];
    NSString *crashDirectory = [documentsDirectory stringByAppendingFormat:@"/log/%@/",dateString1];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:logDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:logDirectory
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:crashDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:crashDirectory
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }

    logDic = logDirectory;
    crashDic = crashDirectory;
    
    //生成文件
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    NSString *fileNamePrefix = [dateFormatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"XZ_log_%@_logtraces.txt", fileNamePrefix];
    NSString *filePath = [logDirectory stringByAppendingPathComponent:fileName];
    logFilePath = filePath;

    // 文件如果不存在就创建
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    // 弄log文件路径里面的数组，删除文件
    NSError *error = nil;
    NSMutableArray *fileArrays = [NSMutableArray array];
    fileArrays = [NSMutableArray arrayWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[documentsDirectory stringByAppendingString:@"/log/"] error:&error]];
    
    // 移除根目录，删除多余的文件夹
    [fileArrays removeObject:@".DS_Store"];
    if(fileArrays.count>0)
    {
        NSString *minStr = [fileArrays objectAtIndex:0];
        
        // 移除最小那天的文件夹
        for (NSString *string in fileArrays) {
            if([string compare:minStr]<0)
                minStr = string;
        }
        if (fileArrays.count > numberOfDaysToDelete) {
            [[NSFileManager defaultManager] removeItemAtPath:[documentsDirectory stringByAppendingFormat:@"/log/%@",minStr] error:&error];
        }
    }
    
}

+ (NSString *)gainDateStr:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    NSString *fileNamePrefix = [dateFormatter stringFromDate:date];
    
    return fileNamePrefix;
}

+ (void)checkForNewFile
{
    static NSDate *lastDate = nil;
    NSDate *nowDate = [NSDate date];
    
    if(lastDate)
    {
        NSString *lastStr = [self gainDateStr:lastDate];
        NSString *nowStr = [self gainDateStr:nowDate];
        if(![lastStr isEqualToString:nowStr])        //不是同一天，创建新的文件
        {
            [self _initFile];
        }
    }
    lastDate = nowDate;
    
}

//

/**
 *  输入一个名称string和简单描述string、详细描述string
 *
 *  @param nameString      打印者的名称string
 *  @param simpleDescriptionString 简单描述string
 *  @param detailDescriptionString 详细描述string
 *  by xiaoZhuo   2016/06/29
 */
+ (void)logFromWhom:(NSString *)nameString andSimpleLogDescription:(NSString *)simpleDescriptionString andDetailLogDescription:(NSString *)detailDescriptionString andFileString:(NSString *)fileString
{
    NSString *contentStr = [[NSString alloc] initWithFormat:@"%@ %@ %@：%@",nameString,fileString,simpleDescriptionString,detailDescriptionString];
    
    NSLog(@"\033[" @"fg%@;" @"%@" XCODE_COLORS_RESET,logColor,contentStr);
    [[self class] writeDataToFileByString:contentStr];
}

/**
 *  输入一个名称string和简单描述string、详细描述string、字体颜色string
 *
 *  @param nameString      打印者的名称string
 *  @param simpleDescriptionString 简单描述string
 *  @param detailDescriptionString 详细描述string
 *  @param foreGroundColorString   字体颜色string
 *  by xiaoZhuo   2016/06/29
 */
+ (void)logFromWhom:(NSString *)nameString andSimpleLogDescription:(NSString *)simpleDescriptionString andDetailLogDescription:(NSString *)detailDescriptionString andFileString:(NSString *)fileString andColorString:(NSString *)foreGroundColorString
{
    NSString *contentStr = [[NSString alloc] initWithFormat:@"%@ %@ %@：%@",nameString,fileString,simpleDescriptionString,detailDescriptionString];
    NSLog(@"\033[" @"fg%@;" @"%@" XCODE_COLORS_RESET,foreGroundColorString,contentStr);
    
    [[self class] writeDataToFileByString:contentStr];
}

+ (void)logW:(NSString *)format, ...{
    va_list args;
    va_start(args, format);
    
    NSString *contentStr = [[NSString alloc] initWithFormat:format arguments:args];

    NSLog(@"%@",contentStr);
    
    [[self class] writeDataToFileByString:contentStr];
    va_end(args);
}

+ (void)logWToShow:(NSString *)format, ...NS_FORMAT_FUNCTION(1,2)
{
    va_list args;
    va_start(args, format);
    
    NSString *contentStr = [[NSString alloc] initWithFormat:format arguments:args];
    
    NSLog(@"%@",contentStr);
    
    [[self class] writeDataToFileByString:contentStr];
    va_end(args);
    
    //调用显示的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:XZLogShowMessage object:contentStr];
}

+ (void)logWithColor:(NSString *)color format:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    
    NSString *contentStr = [[NSString alloc] initWithFormat:format arguments:args];
    
    NSLog(XCODE_COLORS_ESCAPE @"fg%@;" @"%@" XCODE_COLORS_RESET,color,contentStr);
    
    [[self class] writeDataToFileByString:contentStr];
    va_end(args);
}

+ (void)logvformat:(NSString *)format vaList:(va_list)args{
    __block NSString *formatTmp = format;
    NSString *contentStr = [[NSString alloc] initWithFormat:formatTmp arguments:args];
    
    NSLog(XCODE_COLORS_ESCAPE @"fg%@;" @"%@" XCODE_COLORS_RESET,logColor,contentStr);
    
    [[self class] writeDataToFileByString:contentStr];
}

/**
 *  将打印的字符串string转化为data数据写入文件
 *
 *  @param string 打印的字符串string
 */
+ (void)writeDataToFileByString:(NSString *)string
{
    if(isCloseOut)      //不写入文件
        return;
    
    [self checkForNewFile];
    NSString *contentN = [string stringByAppendingString:@"\n"];
    NSString *content = [NSString stringWithFormat:@"%@ %@",[self _getCurrentTime], contentN];
    
    dispatch_async(logOperationQueue, ^{
        
        // 使用句柄写入文件
        NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:logFilePath];
        // 把句柄移到文件最后
        [file seekToEndOfFile];
        [file writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
        [file closeFile];
    });
}

/**
 *  获取当前时间，格式为yyyy-MM-dd hh:mm:ss
 *
 *  @return 当前时间string
 */
+(NSString *)_getCurrentTime
{
    NSDate *nowUTC = [NSDate date];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [format stringFromDate:nowUTC];
    
    return dateString;
}

@end
