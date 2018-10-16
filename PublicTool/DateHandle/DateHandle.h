//
//  DateHandle.h
//  FD018
//
//  Created by DONGWANG on 16/7/18.
//  Copyright © 2016年 DONGWANG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHandle : NSObject


/**
 *  获取当前日期
 *
 *  @param type  日期格式
 *  @param isuct 是否为utc日期
 *
 *  @return NSString
 */
+ (NSString *)getCurentDateByType:(NSString *)type withUTC:(BOOL)isuct;
/**
 *  获取当前时间的时间戳
 *
 *  2016/07/18 modify By Aney
 *  @return 返回当前时间的时间戳
 */
+ (NSString *)getCurrentTimeStamp;
/**
 *  获取当前手机系统的时区
 *  2016/07/18 modify By Aney
 *  @return 返回获取到的时区，-为西区，+为东区
 */
+ (SInt8)getSystemTimeZone;

/**
 *  将时间戳转换成NSDate,加上时区偏移
 *  2016/07/18 modify By Aney
 *  @param timeStamp 时间戳
 *
 *  @return 返回对应时区的时间
 */
+ (NSDate*)convertTimeStampToNSDate:(NSString*)timeStamp;

//时间撮转换成格式时间
+(NSString *)convertTimeStampToStringDate:(NSString *)timeStamp formate:(NSString *)formate;

/**
 *  计算同一时代（AD|BC）两个日期午夜之间的天数，参数格式必须为yyyy-MM-dd
 *  2016/07/18 modify By Aney
 *  @param beforeDay 前一个日期
 *  @param behindDay 后一个日期
 *
 *  @return 两个日期相隔的天数
 */
+ (NSInteger)getDaysOffsetFromDate:(NSString *)beforeDay toDate:(NSString *)behindDay;
//两个日期相隔的月份
+ (NSInteger)getMonOffsetFromDate:(NSString *)beforeDay toDate:(NSString *)behindDay;
//返回两个日期间的所有日期 参数格式必须为yyyy-MM-dd
+ (NSArray *)getAllDateFromDate:(NSString *)beforeDay toDate:(NSString *)behindDay;
//返回两个日期间的所有月份 参数格式必须为yyyy-MM-dd
+ (NSArray *)getAllMonFromDate:(NSString *)beforeDay toDate:(NSString *)behindDay;
/**
 *  当前日期的前后第几天,index值为正则是今天以后的日期
 *  2016/07/18 modify By Aney
 *  @param date  需要获取的前后日期的基准日期
 *  @param index 与基准日期相隔的天数，+为将来，-为过去
 *  @param formatter  自定义日期格式
 *
 *  @return 返回对应的日期
 */
+ (NSString *)getBeforeOrBehindDayByReferenceDate:(NSString *)date byIndex:(NSInteger)index withFormatter:(NSString *)formatter;

/*
    前后月份，有年份的处理
    date:yyyy-MM-dd或者yyyy-MM
    type = 0前一个，1后一个
 */
+ (NSString *)getBeforeOrBehindDMonByDate:(NSString *)date type:(int)type;
/**
 *  根据日期，获取该日期所在周，月，年的开始日期，结束日期
 *  2016/07/18 modify By Aney
 *  @param dateStr 基准日期，格式：@"yyyy-MM-dd"
 *  @param unit   对应获取的 周，月，年
 *
 *  @return 对应的周、月、年的数组
 */
+ (NSArray *)getFirstAndLastDay:(NSString *)dateStr ofUnit:(int)unit;
/**
 *  根据时间字符串获得当前星期几
 *  2016/07/18 modify By Aney
 *  @param string 基准时间格式为：@"yyyy-MM-dd"
 *
 *  @return 返回当前的星期
 */
+ (NSString *)getWeekDayFromDate:(NSString *)string;
//返回当前日期的星期，1，2，3，4，5，6，7   从周日开始
+ (NSInteger )getWeekIndexFromData:(NSString *)data;
/**
 根据日期获取该日期所在月的所有日期
 2016/12/06 modify By Aney
 @param dateStr 基准日期
 @param type 基准日期对应的格式如：@"yyyy-MM-dd"
 @return 返回改日期所在月的所有日期
 */
+ (NSArray *)getMonthAllDaysByDate:(NSString *)dateStr withType:(NSString *)type;

/**
 *  把UTC时间转换成本地时间
 *  2016/07/18 modify By Aney
 *  @param dateUTCStr 对应的UTC时间
 *  @param formatter       时间格式类型
 *
 *  @return 返回对应的本地时间
 */
+ (NSString *)convertUTCDateToLocalDate:(NSString *)dateUTCStr WithFormatter:(NSString *)formatter;
/**
 *  UTC时间转成本地时间撮
 *  2016/07/18 modify By Aney
 *  @param utcTime UTC对应的时间
 *  @param formatter    时间格式
 *
 *  @return 返回对应的时间戳
 */
+(NSTimeInterval)getNSTimeIntervalLocalTimeFromUTC:(NSString *)utcTime WithFormatter:(NSString *)formatter;
/**
 *  获取当前时间的前后的时间，间距secondsPerDay秒
 *  2016/07/18 modify By Aney
 *  @param date          对应的时间与Type匹配
 *  @param secondInterval 相隔的秒数
 *  @param formatter          时间的格式
 *
 *  @return 返回对应的时间
 */
+ (NSString *)getBeforeOrBehindDateFromDate:(NSString *)date withSecondInterval:(NSTimeInterval)secondInterval WithFormatter:(NSString *)formatter;
/**
 *  判断是否为闰年
 *  2016/07/18 modify By Aney
 *  @param year 对应的年份
 *
 *  @return 返回的BOOL值
 */
+(BOOL)isLeapYear:(NSString *)year;
/**
 *  字符串时间转换为NSDate
 *  2016/07/18 modify By Aney
 *  @param timerStr 字符串时间
 *  @param type     对应字符串时间的格式
 *
 *  @return 返回NSDate
 */
+(NSDate *)stringToDate:(NSString *)timerStr withtype:(NSString *)type;
/**
 *  NSDate转字符串时间
 *  2016/07/18 modify By Aney
 *  @param aDate NSDate格式的日期
 *  @param type  对应格式化的类型
 *
 *  @return 返回转换好的日期
 */
+(NSString *)dateToString:(NSDate *)aDate withType:(int)type;


/**
 *  获取单个日期或时间，年、月、日、时、分、秒
 *  2016/08/01 modify By Payne
 *
 *  @param index  NSInteger 代表单个日期或时间，年、月、日、时、分、秒
 *
 *  @return index
 */
+ (NSInteger)getCurrentDateorTimeWithIndex:(NSInteger)index date:(NSDate *)date;


///**
// *  得到制定时间的时间戳
// *
// *  @param timeType 时间 格式许为：yyyy-MM-dd HH-mm-ss
// *
// *  @return 返回时间戳
// */
+ (int)getTimeTem:(NSString *)timeType;

/**
 *  得到制定时间的时间戳
 *
 *  @param timeType 特定时间
 *  @param type     特定时间的格式
 *
 *  @return 返回特定时间的格式
 */
+ (double)getTimeTem:(NSString *)timeType withType:(NSString *)type;


/**
 * 将秒转换成时分秒
 * 2016/12/12 modify By Payne
 @param totalSeconds 秒
 @return 返回时分秒
 */
+ (NSString *)timeFormatted:(NSString *)totalSeconds;

/**
 *  获取当前手机系统的时区
 *
 *  @return 返回获取到的时区，-为西区，+为东区
 */
+ (SInt8)getTimeZone;

//type是转换的格式不一样0是HH:mm其他数是yyyyMMddHHmmss
+(NSDate *)StringToDate:(NSString *)timerStr withtype:(int)type;


/**
 判断当前时间是否属于传入的开始时间以及结束时间范围内
 
 @param stratTime 开始时间格式：XXXX-XX-XX
 @param endTime 结束时间格式：XXXX-XX-XX
 @return 返回判断结果
 */
+ (BOOL)belongFrom:(NSString *)stratTime toTme:(NSString *)endTime;

/**
 *  日期格式转换 yyyy-MM-dd/yyyyMMdd/yyyy:MM:dd的相互转换
 *
 *  @param date       日期参数
 *  @param beforeType 需要转换的日期格式
 *  @param resultType 转换后的日期格式
 *
 *  @return 返回需要的日期格式
 */
+ (NSString *)getTheDateFrom:(NSString *)date withBeforeType:(NSString *)beforeType withresultType:(NSString *)resultType;


/********************添加的方法字符串与日期之间的转换************************/


//获取当前时间来填充登陆时的model
+ (NSString*) stringOfCurrentTime;

/**
 *  获取某个日期的单个日期或时间，月、日
 *
 *typeStr 原来的日期的格式
 *
 *  @return NSString
 */
+(NSString *)getdateFomatMonthOrDay:(NSString *)dateStr withType:(NSString *)typeStr;


/**
 *
 *获取某个日期的月份
 * 这个日期的格式是yyyy-MM-dd
 */
+(NSString *)getDateMonth:(NSString *)dateStr;

//通过时间戳获取对应的小时与分钟
+ (NSString *)getDateHourMM:(NSString *)time;

//计算两个日期之间的天数
+(NSInteger) calcDaysFromBegin:(NSDate *)inBegin end:(NSDate *)inEnd;

//获取某个日期前后几个月的日期
+(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month;
/**
 *  合并两个日期的格式，yyyy-MM-dd 转换为 MM/dd-dd（type 为0） 或者MM/dd（type 1）
 *
 *  @param firstStr 第一个日期
 *  @param nextStr  第二个日期
 *  @param type     类型
 *
 *  @return 返回合并好的日期
 */
+ (NSString *)dateStringConbine:(NSString *)firstStr withString:(NSString *)nextStr withType:(int)type;
//时间撮转换成格式时间
+(NSString *)getTimeTempToDate:(NSString *)timeTemp formate:(NSString *)formate;

/**
 *  字符串转日期
 *
 *  @param timerStr 日期
 *  @param timeType 字符串类型
 *
 *  @return 返回指定类型的字符串
 */
+(NSDate *)stringConventToDate:(NSString *)timerStr withtype:(NSString *)timeType;

@end
