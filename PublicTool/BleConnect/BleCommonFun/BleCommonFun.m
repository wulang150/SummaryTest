//
//  BleCommonFun.m
//  BleSDK
//
//  Created by  Tmac on 2017/8/31.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "BleCommonFun.h"
#import "BleConnectMacro.h"
#import <CoreBluetooth/CoreBluetooth.h>

@implementation BleCommonFun

+(NSData *)charToData:(int)operatetype
{
//    NSNumber *data = [NSNumber numberWithInt:operatetype];
//    char value = [data charValue];
//    
    NSMutableData *charData = [NSMutableData dataWithBytes:&operatetype length:sizeof(char)];
    
    return charData;
    
    
}

/**
 数据打包，超过20个字节的打包成多个包分别发送，不足20个字节的补零
 
 @param data 需要发送的数据
 
 @return 返回以帧为单位（20个字节为一个对象）的数组
 */
+ (NSArray *)packageCurrentSendData:(NSData *)data
{
    if (!data) return nil;
    NSMutableArray *packDataArray = [NSMutableArray array];
    
    if (data.length <= 20) {
        
//        NSMutableData *packageData = [NSMutableData dataWithData:data];
//        //不足20位补零
//        NSInteger len = 20 - data.length;
//        for (int i = 0; i < len; i++) {
//            Byte bit = 0x00;
//            [packageData appendBytes:&bit length:1];
//        }
//    
//        [packDataArray addObject:packageData];
        
        [packDataArray addObject:data];
        
    }else if (data.length > 20){
        
        //包头
        Byte type;
        [data getBytes:&type range:NSMakeRange(0, 1)];
        NSMutableData *headData = [NSMutableData dataWithBytes:&type length:1];
        
        //首包
        NSData *firstPackData = [data subdataWithRange:NSMakeRange(0, 20)];
        [packDataArray addObject:firstPackData];
        
        
        //中间包
        NSData *subPackData = [data subdataWithRange:NSMakeRange(20, data.length - 20)];
        NSInteger packageNum = subPackData.length/18;
        for (int i = 0; i < packageNum; i++) {
            //加上包头
            NSMutableData *mutData = [NSMutableData dataWithData:headData];
            //加上包号
            [mutData appendData:[BleCommonFun charToData:i+2]];
            NSData *subData = [subPackData subdataWithRange:NSMakeRange(i*18, 18)];
            [mutData appendData:subData];
            [packDataArray addObject:mutData];
        }
        
        //尾包
        NSMutableData *lastPackageData = [NSMutableData dataWithData:headData];
        [lastPackageData appendData:[BleCommonFun charToData:(int)packageNum+2]];
        NSData *lastData = [subPackData subdataWithRange:NSMakeRange(packageNum * 18, subPackData.length - packageNum * 18)];
        [lastPackageData appendData:lastData];
        
//        //不足20位补零
//        NSInteger len = 19 - lastPackageData.length;
//        for (int i = 0; i < len; i++) {
//            Byte bit = 0x00;
//            [lastPackageData appendBytes:&bit length:1];
//        }
//        //最后一位补结束副符
//        Byte end = 0x00;
//        [lastPackageData appendBytes:&end length:1];
//        
//        [packDataArray addObject:lastPackageData];
        
    }
    
    
    return packDataArray;
}

// data数据切割成等长的小段数据打包成数组
+ (NSArray *)cutToArrayWithData:(NSData *)data andLength:(NSInteger)num
{
    
    NSMutableArray *resultArr = [NSMutableArray new];
    NSInteger n = floor(data.length * 1.0 / num);   //取小于当前浮点数的那个整数
    for (int i = 0; i < n; i++) {
        
        NSData *subData = [data subdataWithRange:NSMakeRange(i * num , num)];
        [resultArr addObject:subData];
    }
    
    if (data.length != n*num) {   //如果有遗漏补齐最后一条数据
        NSData *lastData = [data subdataWithRange:NSMakeRange(n * num, data.length - n * num)];
        [resultArr addObject:lastData];
    }
    
    return resultArr;
}

//字符转data : FFDF = <ffdf>
+ (NSData *) getDataFromString:(NSString *)command
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

//获取mac地址
+ (NSString *)gainMacString
{
    NSString *macStr = [[NSUserDefaults standardUserDefaults] valueForKey:BLEBANDMACADDRESS];
    if(macStr.length<=0)
    {
        macStr = [[NSUserDefaults standardUserDefaults] valueForKey:BLEBANDMACADDRESSTEMP];
        if(macStr<=0)
            macStr = @"";
        
        [[NSUserDefaults standardUserDefaults] setObject:macStr forKey:BLEBANDMACADDRESS];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return macStr;
}

+ (UInt16)NSDataToUInt16:(UInt16)number
{
    number = (number & 0xFF)<<8 | (number >>8);
    return number;
}

/**
 *  由于IOS数据存储为小端存储，故在于其他硬件设备交互时需要进行数据移位
 *  2016/07/18 modify By Aney
 *  @param number 需要因为的四个字节数据
 *
 *  @return 移位后的数据
 */
+ (UInt32) NSDataToUInt32:(UInt32)number
{
    number = ((number&0xFF)<<24) | (((number>>8)&0xFF)<<16) | (((number>>16)&0xFF)<<8) | ((number >>24)&0xFF);
    return number;
}

+ (char)weekOfDayDistribution:(NSArray *)array
{
    
    array = [[array reverseObjectEnumerator] allObjects];
    char weekDay = 0;
    for (int i = 0; i<array.count; i++)
    {
        if ([array[i] intValue] == 1)
        {
            int n = (int)array.count - 1 - i;
            weekDay = weekDay | (([array[i] intValue] &0xFF) <<n);
        }
    }
    
    return weekDay;
}

//把uuid字符串改为统一的格式
+ (NSString *)UUIDString:(NSString *)str
{
    CBUUID *suid = [CBUUID UUIDWithString:str];
    
    return suid.UUIDString;
}
@end
