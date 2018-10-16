//
//  BleCommonFun.h
//  BleSDK
//
//  Created by  Tmac on 2017/8/31.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BleCommonFun : NSObject

/**
 *  int类型的数据转换成NSData
 *  2016/07/18 modify By Aney
 *  @param operatetype 需要转换的int类型
 *
 *  @return 返回转换好的NSData类型
 */
+(NSData *)charToData:(int)operatetype;

/**
 数据打包，超过20个字节的打包成多个包分别发送，不足20个字节的补零
 
 @param data 需要发送的数据
 
 @return 返回以帧为单位（20个字节为一个对象）的数组
 */
+ (NSArray *)packageCurrentSendData:(NSData *)data;

// data数据切割成等长的小段数据打包成数组
+ (NSArray *)cutToArrayWithData:(NSData *)data andLength:(NSInteger)num;

//字符转data : FFDF = <ffdf>
+ (NSData *)getDataFromString:(NSString *)command;

+ (NSString *)gainMacString;

+ (UInt16)NSDataToUInt16:(UInt16)number;

/**
 *  由于IOS数据存储为小端存储，故在于其他硬件设备交互时需要进行数据移位
 *  2016/07/18 modify By Aney
 *  @param number 需要因为的四个字节数据
 *
 *  @return 移位后的数据
 */
+ (UInt32) NSDataToUInt32:(UInt32)number;
//周分布
+ (char)weekOfDayDistribution:(NSArray *)array;

//把uuid字符串改为统一的格式
+ (NSString *)UUIDString:(NSString *)str;
@end
