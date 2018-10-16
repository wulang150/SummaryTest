//
//  DateHandle.m
//  FD018
//
//  Created by DONGWANG on 16/7/18.
//  Copyright © 2016年 DONGWANG. All rights reserved.
//

#import "DateHandle.h"

@implementation DateHandle
/**
 *  获取当前时间的时间戳
 *
 *  2016/07/18 modify By Aney
 *  @return 返回当前时间的时间戳
 */
+ (NSString *)getCurrentTimeStamp
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSString *timeStamp = [NSString stringWithFormat:@"%.0f", interval];
    NSLog(@"NSTimeInterval:～～～～～～～～～%@",timeStamp);
    return timeStamp;
}

//获取当前日期
+ (NSString *)getCurentDateByType:(NSString *)type withUTC:(BOOL)isuct{
    
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (isuct) {
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormatter setTimeZone:timeZone];
    }
    [dateFormatter setDateFormat:type];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSString *locationString=[dateFormatter stringFromDate:senddate];
    //NSLog(@"当前日期:%@",locationString);
    return locationString;
}

/**
 *  获取当前手机系统的时区
 *  2016/07/18 modify By Aney
 *  @return 返回获取到的时区，-为西区，+为东区
 */
+ (SInt8)getSystemTimeZone
{
    NSTimeZone *systemTimeZone = [NSTimeZone systemTimeZone];
    SInt8 offset = systemTimeZone.secondsFromGMT/3600;
    
    NSLog(@"+>>>>>>%ld---%d",systemTimeZone.secondsFromGMT,offset);
    
    return offset;
}

/**
 *  将时间戳转换成NSDate,加上时区偏移
 *  2016/07/18 modify By Aney
 *  @param timeStamp 时间戳
 *
 *  @return 返回对应时区的时间
 */
+ (NSDate*)convertTimeStampToNSDate:(NSString*)timeStamp
{
    if (timeStamp != nil)
    {

        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp intValue]];
        return date;
        
    }
    else
    {
        return nil;
    }

}

//时间撮转换成格式时间
+(NSString *)convertTimeStampToStringDate:(NSString *)timeStamp formate:(NSString *)formate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp intValue]];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}


/**
 *  计算同一时代（AD|BC）两个日期午夜之间的天数，参数格式必须为yyyy-MM-dd
 *  2016/07/18 modify By Aney
 *  @param beforeDay 前一个日期
 *  @param behindDay 后一个日期
 *
 *  @return 两个日期相隔的天数
 */
+ (NSInteger)getDaysOffsetFromDate:(NSString *)beforeDay toDate:(NSString *)behindDay
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [inputFormatter dateFromString:beforeDay];
    NSDate *endDate = [inputFormatter dateFromString:behindDay];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger startDay = [gregorian ordinalityOfUnit:NSCalendarUnitDay inUnit: NSCalendarUnitEra forDate:startDate];
    NSInteger endDay =  [gregorian ordinalityOfUnit:NSCalendarUnitDay inUnit: NSCalendarUnitEra forDate:endDate];
    return (endDay - startDay);
}

//两个日期相隔的月份
+ (NSInteger)getMonOffsetFromDate:(NSString *)beforeDay toDate:(NSString *)behindDay
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [inputFormatter dateFromString:beforeDay];
    NSDate *endDate = [inputFormatter dateFromString:behindDay];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger startDay = [gregorian ordinalityOfUnit:NSCalendarUnitMonth inUnit: NSCalendarUnitEra forDate:startDate];
    NSInteger endDay =  [gregorian ordinalityOfUnit:NSCalendarUnitMonth inUnit: NSCalendarUnitEra forDate:endDate];
    return (endDay - startDay);
}

//返回两个日期间的所有日期 参数格式必须为yyyy-MM-dd
+ (NSArray *)getAllDateFromDate:(NSString *)beforeDay toDate:(NSString *)behindDay
{
    NSInteger offDay = [self getDaysOffsetFromDate:beforeDay toDate:behindDay];
    
    NSMutableArray *dateArr = [NSMutableArray new];
    
    if([beforeDay compare:behindDay]>=0)
    {
        [dateArr addObject:behindDay];
        return dateArr;
    }
    for(int i = 0;i<=offDay;i++)
    {
        NSString *date = [self getBeforeOrBehindDayByReferenceDate:beforeDay byIndex:i withFormatter:@"yyyy-MM-dd"];
        if(date)
            [dateArr addObject:date];
    }
    if(dateArr.count==0)
        [dateArr addObject:behindDay];
    return dateArr;
}
//返回两个日期间的所有月份中间那天 参数格式必须为yyyy-MM-dd
+ (NSArray *)getAllMonFromDate:(NSString *)beforeDay toDate:(NSString *)behindDay
{
    NSArray *beforeArr = [beforeDay componentsSeparatedByString:@"-"];
    if(beforeArr.count<2)
        return nil;
    NSArray *behindArr = [behindDay componentsSeparatedByString:@"-"];
    if(behindArr.count<2)
        return nil;
    
    beforeDay = [NSString stringWithFormat:@"%@-%@",beforeArr[0],beforeArr[1]];
    behindDay = [NSString stringWithFormat:@"%@-%@",behindArr[0],behindArr[1]];
    
    NSMutableArray *mulArr = [NSMutableArray new];
    [mulArr addObject:beforeDay];
    if([beforeDay compare:behindDay]>=0)
    {
        return mulArr;
    }
    beforeDay = [self getBeforeOrBehindDMonByDate:beforeDay type:1];
    while (![beforeDay isEqualToString:behindDay])
    {
        [mulArr addObject:beforeDay];
        beforeDay = [self getBeforeOrBehindDMonByDate:beforeDay type:1];
    }
    [mulArr addObject:behindDay];
    return mulArr;
}

/**
 *  当前日期的前后第几天,index值为正则是今天以后的日期
 *  2016/07/18 modify By Aney
 *  @param date  需要获取的前后日期的基准日期
 *  @param index 与基准日期相隔的天数，+为将来，-为过去
 *  @param formatter  自定义日期格式
 *
 *  @return 返回对应的日期
 */
+ (NSString *)getBeforeOrBehindDayByReferenceDate:(NSString *)date byIndex:(NSInteger)index withFormatter:(NSString *)formatter
{
    NSTimeInterval secondsPerDay = 24 * 60 * 60 * index;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];

    [inputFormatter setDateFormat:formatter];
    
    NSDate *today = [inputFormatter dateFromString:date];
    NSDate *tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    NSString * globalDate=[inputFormatter stringFromDate:tomorrow];
    
    return globalDate;
}

/*
 前后月份，有年份的处理
 date:yyyy-MM-dd或者yyyy-MM
 type = 0前一个，1后一个
 */
+ (NSString *)getBeforeOrBehindDMonByDate:(NSString *)date type:(int)type
{
    NSArray *arr = [date componentsSeparatedByString:@"-"];
    if(arr.count<2)
        return nil;
    
    int index = type;
    if(type==0)
    {
        index = -1;
    }
    
    NSString *timeStr = [NSString stringWithFormat:@"%@-%@-15",arr[0],arr[1]];
    NSTimeInterval secondsPerDay = 24 * 60 * 60 * 20 * index;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *today = [inputFormatter dateFromString:timeStr];
    
    [inputFormatter setDateFormat:@"yyyy-MM"];
    NSDate *tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    NSString * globalDate=[inputFormatter stringFromDate:tomorrow];
    
    return globalDate;
}

/**
 *  根据日期，获取该日期所在周，月，年的开始日期，结束日期
 *  2016/07/18 modify By Aney
 *  @param dateStr 基准日期，格式：@"yyyy-MM-dd"
 *  @param unit   对应获取的 周，月，年
 *
 *  @return 对应的周、月、年的数组
 */
+ (NSArray *)getFirstAndLastDay:(NSString *)dateStr ofUnit:(int)unit
{
    
    NSMutableArray *dateArray = [NSMutableArray new];
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* newDate = [inputFormatter dateFromString:dateStr];
    
    if (newDate == nil)
    {
        newDate = [NSDate date];
    }
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSInteger unitFlags =0;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//设定周日为周首日
    switch (unit)
    {
        case 0://周
        {
            
            unitFlags =  NSCalendarUnitWeekOfMonth;
            
        }
            break;
        case 1://月
        {
            unitFlags = NSCalendarUnitMonth;
        }
            break;
        case 2://年
        {
            unitFlags = NSCalendarUnitYear;
        }
            break;
            
        default:
            break;
    }
    
    BOOL ok = [calendar rangeOfUnit:unitFlags startDate:&beginDate interval:&interval forDate:newDate];
    
    if (ok)
    {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }
    else
    {
        return nil;
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];//一周/一个月/一年的第一天
    NSString *endString = [myDateFormatter stringFromDate:endDate];//一周/一个月/一年的最后一天
    
    NSInteger num = [self getDaysOffsetFromDate:beginString toDate:endString];
    
    if ( unit == 0)
    {//周
        NSString *finalStrf = [beginString componentsSeparatedByString:@"-"][2];
        NSString *dateWeekf = [self getWeekDayFromDate:beginString];
        [dateArray addObject:@[finalStrf, dateWeekf,beginString]];
        
        for (int i = 1; i<=num; i++)
        {//当前日期所在周对应的日期和星期
            NSString *dateString = [self getBeforeOrBehindDayByReferenceDate:beginString byIndex:i withFormatter:@"yyyy-MM-dd"];
            NSString *finalStr = [dateString componentsSeparatedByString:@"-"][2];
            NSString *dateWeek = [self getWeekDayFromDate:dateString];
            [dateArray addObject:@[finalStr, dateWeek,dateString]];//天，星期，完整日期
        }
    }
    else if (unit == 1)
    {//月
        
        [dateArray addObject:beginString];
        for (int i = 1; i<=num; i++)
        {//当前日期所在月对应的日期
            NSString *dateString = [self getBeforeOrBehindDayByReferenceDate:beginString byIndex:i withFormatter:@"yyyy-MM-dd"];
            [dateArray addObject:dateString];
        }
    }
    else
    {//年
        
        NSMutableArray *datas = [NSMutableArray new];
        [datas addObject:beginString];
        for (int i = 1; i<=num; i++)
        {//当前日期一年对应的日期
            NSString *dateString = [self getBeforeOrBehindDayByReferenceDate:beginString byIndex:i withFormatter:@"yyyy-MM-dd"];
            [datas addObject:dateString];
        }
        
        
    }
    
    return dateArray;
}


/**
 *  根据时间字符串获得当前星期几
 *  2016/07/18 modify By Aney
 *  @param string 基准时间格式为：@"yyyy-MM-dd"
 *
 *  @return 返回当前的星期
 */
+ (NSString *)getWeekDayFromDate:(NSString *)string
{

    NSInteger week = [self getWeekIndexFromData:string];
    
    NSString*weekStr=nil;
    switch (week)
    {
        case 1:
        {
            weekStr = @"Sun";
        }
            break;
        case 2:
        {
            weekStr = @"Mon";
        }
            break;
        case 3:
        {
            weekStr = @"Tue";
        }
            break;
        case 4:
        {
            weekStr = @"Wed";
        }
            break;
        case 5:
        {
            weekStr = @"Thu";
        }
            break;
        case 6:
        {
            weekStr = @"Fri";
        }
            break;
        case 7:
        {
            weekStr = @"Sat";
        }
            break;
        default:
            break;
    }
    
    return weekStr;
}
//返回当前日期的星期，1，2，3，4，5，6，7
+ (NSInteger )getWeekIndexFromData:(NSString *)data
{
    //根据字符串转换成一种时间格式 供下面解析
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* inputDate = [inputFormatter dateFromString:data];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute |  NSCalendarUnitSecond;
    
    
    comps = [calendar components:unitFlags fromDate:inputDate];
    
    NSInteger week = [comps weekday];
    
    return week;
}

/**
 根据日期获取该日期所在月的所有日期
 2016/12/06 modify By Aney
 @param dateStr 基准日期
 @param type 基准日期对应的格式如：@"yyyy-MM-dd"
 @return 返回改日期所在月的所有日期
 */
+ (NSArray *)getMonthAllDaysByDate:(NSString *)dateStr withType:(NSString *)type
{
    
    NSMutableArray *dateArray = [NSMutableArray new];
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:type ];//@"yyyy-MM-dd"];
    NSDate* newDate = [inputFormatter dateFromString:dateStr];
    
    if (newDate == nil)
    {
        newDate = [NSDate date];
    }
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitMonth;
    
    BOOL ok = [calendar rangeOfUnit:unitFlags startDate:&beginDate interval:&interval forDate:newDate];
    
    if (ok)
    {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }
    else
    {
        return nil;
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];//一个月的第一天
    NSString *endString = [myDateFormatter stringFromDate:endDate];//一个月的最后一天
    
    NSInteger num = [self getDaysOffsetFromDate:beginString toDate:endString];
    
    [dateArray addObject:[NSNumber numberWithInt:[[beginString componentsSeparatedByString:@"-"][2] intValue]]];
    
    for (int i = 1; i<=num; i++)
    {//当前日期所在月对应的日期
        NSString *dateString = [self getBeforeOrBehindDayByReferenceDate:beginString byIndex:i withFormatter:0];
        [dateArray addObject:[NSNumber numberWithInt:[[dateString componentsSeparatedByString:@"-"][2] intValue]]];
    }
    
    return dateArray;
}


/**
 *  把UTC时间转换成本地时间
 *  2016/07/18 modify By Aney
 *  @param dateUTCStr 对应的UTC时间
 *  @param formatter       时间格式类型
 *
 *  @return 返回对应的本地时间
 */
+ (NSString *)convertUTCDateToLocalDate:(NSString *)dateUTCStr WithFormatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:formatter];
    
    NSDate *anyDate = [dateFormatter dateFromString:dateUTCStr];
    
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset ;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    
    NSString *localTimeStr = [dateFormatter stringFromDate:destinationDateNow];
    //    NSLog(@"~~~~~~当前utc时间~~%@~~~对应的本地时间~~~%@",dateStr,localTimeStr);
    
    return localTimeStr;
}

/**
 *  UTC时间转成本地时间撮
 *  2016/07/18 modify By Aney
 *  @param utcTime UTC对应的时间
 *  @param formatter    时间格式
 *
 *  @return 返回对应的时间戳
 */
+(NSTimeInterval)getNSTimeIntervalLocalTimeFromUTC:(NSString *)utcTime WithFormatter:(NSString *)formatter
{
    //UTC时间转本地时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:formatter];
    NSDate *anyDate = [dateFormatter dateFromString:utcTime];
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval intervalnum = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:intervalnum sinceDate:anyDate];
    //本地时间
    NSString *localTimeStr = [dateFormatter stringFromDate:destinationDateNow];
    
    NSDate *date = [dateFormatter dateFromString:localTimeStr];
    NSTimeInterval interval = [date timeIntervalSince1970];
    
    //     NSLog(@"+>>>utc%@>>>local:%@>>>>%f",utcTime,localTimeStr,interval);
    return interval;
}

/**
 *  获取当前时间的前后的时间，间距secondsPerDay秒
 *  2016/07/18 modify By Aney
 *  @param date          对应的时间与Type匹配
 *  @param secondInterval 相隔的秒数
 *  @param formatter          时间的格式
 *
 *  @return 返回对应的时间
 */
+ (NSString *)getBeforeOrBehindDateFromDate:(NSString *)date withSecondInterval:(NSTimeInterval)secondInterval WithFormatter:(NSString *)formatter
{
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:formatter];
    NSDate *currentTime = [inputFormatter dateFromString:date];
    NSDate *nextTime = [currentTime dateByAddingTimeInterval:secondInterval];
    NSString * nextTimeStr = [inputFormatter stringFromDate:nextTime];
    //    NSLog(@"~~~~~%@",nextTimeStr);
    return nextTimeStr;
}



/**
 *  判断是否为闰年
 *  2016/07/18 modify By Aney
 *  @param year 对应的年份
 *
 *  @return 返回的BOOL值
 */
+(BOOL)isLeapYear:(NSString *)year
{
    BOOL result  = YES;
    NSString *yearStr = [[year componentsSeparatedByString:@"-"] objectAtIndex:0];
    int y = [yearStr intValue];
    if (((y % 4  == 0) && (y % 100 != 0))|| (y % 400 == 0))
    {
        result = YES;
    }
    else
    {
        result = NO;
    }
    return result;
}

/**
 *  字符串时间转换为NSDate
 *  2016/07/18 modify By Aney
 *  @param timerStr 字符串时间
 *  @param type     对应字符串时间的格式
 *
 *  @return 返回NSDate
 */
+(NSDate *)stringToDate:(NSString *)timerStr withtype:(NSString *)type
{
    
    if (!timerStr)
    {
        return nil;
    }
    
    NSDateFormatter *inputFormatter = [NSDateFormatter new];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    [inputFormatter setDateFormat:type];
    
    NSDate *inputDate = [inputFormatter dateFromString:timerStr];
    
    return inputDate;
}


/**
 *  NSDate转字符串时间
 *  2016/07/18 modify By Aney
 *  @param aDate NSDate格式的日期
 *  @param type  对应格式化的类型
 *
 *  @return 返回转换好的日期
 */
+(NSString *)dateToString:(NSDate *)aDate withType:(int)type
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    if (type == 0)
    {
        [formatter setDateFormat:@"a HH:mm"];
        [formatter setAMSymbol:@"上午"];
        [formatter setPMSymbol:@"下午"];
        NSString *dateStr = [formatter stringFromDate:aDate];
        return dateStr;
    }
    else if(type == 1)
    {
        
        [formatter setDateFormat:@"HH:mm"];
        NSString *str = [formatter stringFromDate:aDate];
        return str;
    }
    else if(type == 2)
    {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSLog(@"%@ %@",aDate,[formatter stringFromDate:aDate]);

        return [formatter stringFromDate:aDate];
    }
    else if (type == 3)
    {
        [formatter setDateFormat:@"yyyyMMdd"];
        return [formatter stringFromDate:aDate];
    }
    else if (type == 4)
    {
        [formatter setDateFormat:@"yyyy-MM-dd"];
        return [formatter stringFromDate:aDate];
    }
    else if (type == 5)
    {
        [formatter setDateFormat:@"yyyyMMddHHmm"];
        return [formatter stringFromDate:aDate];
    }
    else if (type == 6)
    {
        [formatter setDateFormat:@"MM/dd"];
        return [formatter stringFromDate:aDate];
    }
    else if (type == 7)
    {
        [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
        return [formatter stringFromDate:aDate];
    }
    else if (type == 8)
    {
        [formatter setDateFormat:@"HH:mm MM/dd/yyyy"];
        return [formatter stringFromDate:aDate];
    }
    else
        return nil;
}

/**
 *  判断当前时间是否为24小时制
 *  2016/07/18 modify By Aney
 *  @return 返回Bool值
 */
+(BOOL)getTimeSys
{
    //TURE为12小时制，否则为24小时制。
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = containsA.location != NSNotFound;
    return hasAMPM;
}

/**
 *  返回当前时间对应的上下午
 *  2016/07/18 modify By Aney
 *  @return 返回上下午
 */
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


//获取单个日期或时间，年、月、日、时、分、秒
+ (NSInteger)getCurrentDateorTimeWithIndex:(NSInteger)index date:(NSDate *)date
{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute |  NSCalendarUnitSecond;
    NSDate *now =[NSDate date];

    if (date)
    {
        now = date;
    }
    comps = [calendar components:unitFlags fromDate:now];
    
    switch (index) {
        case 0:
            return [comps year];
            break;
        case 1:
            return [comps month];
            break;
        case 2:
            return [comps day];
            break;
        case 3:
            return [comps hour];
            
            break;
        case 4:
            return [comps minute];
            break;
        case 5:
            return [comps second];
            break;
        case 6:
            return [comps weekday];
            break;

        default:
            break;
    }
    return 0;
}


/**
 * 将秒转换成时分秒
 * 2016/12/12 modify By Payne
 @param totalSeconds 秒
 @return 返回时分秒
 */
+ (NSString *)timeFormatted:(NSString *)totalSeconds
{
    
    NSInteger seconds = [totalSeconds integerValue] % 60;
    NSInteger minutes = ([totalSeconds integerValue] / 60) % 60;
    NSInteger hours = [totalSeconds integerValue] / 3600;
    
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours, (long)minutes, (long)seconds];
}

/**
 *  获取当前手机系统的时区
 *
 *  @return 返回获取到的时区，-为西区，+为东区
 */
+ (SInt8)getTimeZone
{
    NSTimeZone *systemTimeZone = [NSTimeZone systemTimeZone];
    SInt8 utcTemp = systemTimeZone.secondsFromGMT/60/60;
    
    NSLog(@"+>>>>>>%ld---%d",systemTimeZone.secondsFromGMT,utcTemp);
    
    return utcTemp;
    
}

#pragma mark - 字符串转日期
/**
 *  字符串转日期
 *
 *  @param timerStr 日期
 *  @param timeType 字符串类型
 *
 *  @return 返回指定类型的字符串
 */
+(NSDate *)stringConventToDate:(NSString *)timerStr withtype:(NSString *)timeType
{
    
    NSDateFormatter *inputFormatter = [NSDateFormatter new];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:timeType];
    
    NSDate* inputDate = [inputFormatter dateFromString:timerStr];
    
    return inputDate;
}

///**
// *  得到制定时间的时间戳
// *
// *  @param timeType 时间 格式许为：yyyy-MM-dd HH-mm-ss
// *
// *  @return 返回时间戳
// */
+ (int)getTimeTem:(NSString *)timeType
{
    NSString *tempStartTime = timeType; //固定一个开始时间
    NSDate *tempDate = [self stringConventToDate:tempStartTime withtype:@"yyyy-MM-dd HH:mm:ss"];
    int dateLong = [tempDate timeIntervalSince1970];
    return dateLong;
}

/**
 *  得到制定时间的时间戳
 *
 *  @param timeType 特定时间
 *  @param type     特定时间的格式
 *
 *  @return 返回特定时间的格式
 */
+ (double)getTimeTem:(NSString *)timeType withType:(NSString *)type
{
    NSDate *tempDate = [self stringConventToDate:timeType withtype:type];
    int dateLong = [tempDate timeIntervalSince1970];
    return dateLong;
}


#pragma mark - 字符串转日期

+(NSDate *)StringToDate:(NSString *)timerStr withtype:(int)type{
    
    if (!timerStr) {
        return nil;
    }
    //    NSLog(@"timerStr=%@ type=%d",timerStr,type);
    
    NSDateFormatter *inputFormatter = [NSDateFormatter new];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    
    if (type == 0) {
        
        [inputFormatter setDateFormat:@"HH:mm"];
    }
    else if(type == 1){
        [inputFormatter setDateFormat:@"HHmmss"];
    }
    else if (type==2)
    {
        [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    else if (type == 3)
    {
        [inputFormatter setDateFormat:@"yyyyMMdd"];
    }
    else if (type == 4)
    {
        [inputFormatter setDateFormat:@"MM/dd"];
    }
    else if (type==5)
    {
        [inputFormatter setDateFormat:@"yyyyMMddHH:mm"];
    }
    else if (type ==6)
    {
        [inputFormatter setDateFormat:@"yyyyMMdd HH:mm"];
    }
    else if (type==7)
    {
        [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    NSDate* inputDate = [inputFormatter dateFromString:timerStr];
    
    return inputDate;
}


/**
 判断当前时间是否属于传入的开始时间以及结束时间范围内
 
 @param stratTime 开始时间格式：XXXX-XX-XX
 @param endTime 结束时间格式：XXXX-XX-XX
 @return 返回判断结果
 */
+ (BOOL)belongFrom:(NSString *)stratTime toTme:(NSString *)endTime
{
    NSDate *start = [DateHandle StringToDate:stratTime withtype:2];
    NSDate *end = [DateHandle StringToDate:endTime withtype:2];
    NSDate *currentDate = [NSDate date];
    if (([currentDate compare:start] == NSOrderedDescending || [currentDate compare:start] == NSOrderedSame) &&  ([currentDate compare:end] == NSOrderedAscending || [currentDate compare:end] == NSOrderedSame))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//日期格式转换
+ (NSString *)getTheDateFrom:(NSString *)date withBeforeType:(NSString *)beforeType withresultType:(NSString *)resultType{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:beforeType];
    NSDate *inputDate = [inputFormatter dateFromString:date];
    
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    
    [outputFormatter setDateFormat:resultType];
    [outputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSString *resultDate = [outputFormatter stringFromDate:inputDate];
    //    NSLog(@"anyDate~~~~~~~~~~%@~~~%@",date,resultDate);
    
    return resultDate;
}



//获取单个日期或时间，年、月、日、时、分、秒
+ (NSInteger)getCurrentDateorTimeWithIndex:(NSInteger)index{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute |  NSCalendarUnitSecond;
    NSDate *now =[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    
    switch (index) {
        case 0:
            return [comps year];
            break;
        case 1:
            return [comps month];
            break;
        case 2:
            return [comps day];
            break;
        case 3:
            return [comps hour];
            
            break;
        case 4:
            return [comps minute];
            break;
        case 5:
            return [comps second];
            break;
        default:
            break;
    }
    return 0;
}

+ (NSString*) stringOfCurrentTime
{
    
    NSDate* current = [NSDate date];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* dateCp = [calendar components:
                                (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                           fromDate:current];
    return [NSString stringWithFormat:@"%d-%d-%d %d:%d:%d",
            (int)[dateCp year], (int)[dateCp month], (int)[dateCp day],
            (int)[dateCp hour], (int)[dateCp minute], (int)[dateCp second]];//此处的年月日一定要是整型不能时常整型
    
}
+(NSString *)getdateFomatMonthOrDay:(NSString *)dateStr withType:(NSString *)typeStr
{
    NSMutableString *resultStr = [[NSMutableString alloc]init];
    if ([typeStr isEqualToString:@"yyyy-MM-dd"]) {
        
        NSArray *dateArr = [dateStr componentsSeparatedByString:@"-"];
        //NSLog(@"-----dateArr----%@",dateArr);
        NSString *monthStr = [NSString stringWithFormat:@"%d",[dateArr[1] intValue]];
        NSString *dayStr =[NSString stringWithFormat:@"%d",[dateArr[2] intValue]];
        
        [resultStr appendString:[NSString stringWithFormat:@"%@/%@",monthStr,dayStr]];
    }
    return resultStr;
}
/**
 *
 *获取某个日期的月份
 * 这个日期的格式是yyyy-MM-dd
 */

+(NSString *)getDateMonth:(NSString *)dateStr
{
    NSString *monthStr = [dateStr componentsSeparatedByString:@"-"][1];
    if ([monthStr integerValue]<10) {
        
        monthStr = [monthStr substringFromIndex:1];
    }
    return monthStr;
}

+ (NSString *)getDateHourMM:(NSString *)time
{
    long tm = [time longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:tm];
    
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"HH:mm"];
    [myDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSString *timeStr = [myDateFormatter stringFromDate:date];
    
    return timeStr;
}


//计算两个日期之间的天数
+(NSInteger) calcDaysFromBegin:(NSDate *)inBegin end:(NSDate *)inEnd
{
    NSLog(@"%@--开始时间and结束-%@",inBegin,inEnd);
    NSInteger unitFlags = NSDayCalendarUnit| NSMonthCalendarUnit | NSYearCalendarUnit;
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [cal components:unitFlags fromDate:inBegin];
    NSDate *newBegin  = [cal dateFromComponents:comps];
    
    
    NSCalendar *cal2 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps2 = [cal2 components:unitFlags fromDate:inEnd];
    NSDate *newEnd  = [cal2 dateFromComponents:comps2];
    
    
    NSTimeInterval interval = [newEnd timeIntervalSinceDate:newBegin];
    NSInteger beginDays=((NSInteger)interval)/(3600*24);
    
    return beginDays;
}


+(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month

{
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setMonth:month];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    return mDate;
    
}


+ (NSString *)dateStringConbine:(NSString *)firstStr withString:(NSString *)nextStr withType:(int)type
{
    NSArray *firstArray = [firstStr componentsSeparatedByString:@"/"];
    switch (type)
    {
        case 0:
        {
            
            NSArray *nextArray = [nextStr componentsSeparatedByString:@"/"];
            NSMutableString *string = [NSMutableString new];
            [string appendString:[NSString stringWithFormat:@"%d",[firstArray[1] intValue]]];
            [string appendString:@"/"];
            [string appendString:[NSString stringWithFormat:@"%d",[firstArray[2] intValue]]];
            
            [string appendString:@"-"];
            [string appendString:[NSString stringWithFormat:@"%d",[nextArray[2] intValue]]];
            return string;
            
        }
            break;
        case 1:
        {
            NSMutableString *string = [NSMutableString new];
            [string appendString:[NSString stringWithFormat:@"%d",[firstArray[1] intValue]]];
            [string appendString:@"/"];
            [string appendString:[NSString stringWithFormat:@"%d",[firstArray[2] intValue]]];
            return string;
            
        }
            
        default:
            break;
    }
    return nil;
}


//时间撮转换成格式时间
+(NSString *)getTimeTempToDate:(NSString *)timeTemp formate:(NSString *)formate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeTemp intValue]];
    NSString *timeString = [formatter stringFromDate:date];
    NSLog(@"+>>>>>%@+>>>>>>>%@",timeTemp,timeString);
    return timeString;
}


@end
