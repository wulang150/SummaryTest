//
//  BleManager.m
//  BleSDK
//
//  Created by  Tmac on 2017/8/31.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "BleManager.h"

#import "BleOperatorManager.h"

#import "BleCommonFun.h"



@interface BleManager()
<BleDataAdaptDelegate>
{
    BleOperatorManager *bleOpt;
    
    NSTimer *timer;     //处理发送超时
    
}

@end

@implementation BleManager

+ (BleManager *)sharedInstance
{
    static id shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
    
}

- (id)init
{
    if(self = [super init])
    {
        __weak BleManager *safeSelf = self;
        bleOpt = [BleOperatorManager sharedInstance];
        //设置服务和特征
        bleOpt.bleServiceAndCharater = @{
                                          BLE_CHARARCTERISTIC_SERVICE_BT_UUID:@[
                                                  BLE_ATT_UUID_AMDTP_RX0,
                                                  BLE_ATT_UUID_AMDTP_TX0,
                                                  BLE_ATT_UUID_AMDTP_RX1,
                                                  BLE_ATT_UUID_AMDTP_TX1,
                                                  BLE_ATT_UUID_AMDTP_RX2,
                                                  BLE_ATT_UUID_AMDTP_TX2,
                                                  BLE_ATT_UUID_AMDTP_RX3,
                                                  BLE_ATT_UUID_AMDTP_TX3,
                                                  BLE_ATT_UUID_AMDTP_RX4,
                                                  BLE_ATT_UUID_AMDTP_TX4,
                                                  BLE_ATT_UUID_AMDTP_RX5,
                                                  BLE_ATT_UUID_AMDTP_TX5,
                                                  BLE_ATT_UUID_AMDTP_RX6,
                                                  BLE_ATT_UUID_AMDTP_TX6,
                                                  ],
                                        
                                          };
        bleOpt.delegate = self;
        bleOpt.realTimeUpdateDeviceListBlock = ^(NSArray *listArray, NSDictionary *rssiDic, NSDictionary *macDic) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if([safeSelf.delegate respondsToSelector:@selector(didRecvSearchList:rssiDic:macDic:)])
                {
                    [safeSelf.delegate didRecvSearchList:listArray rssiDic:rssiDic macDic:macDic];
                }
            });
            
        };
        
    }
    
    return self;
}

- (void)setIsAutoConnected:(BOOL)isAutoConnected
{
    _isAutoConnected = isAutoConnected;
    bleOpt.isAutoConnected = isAutoConnected;
}

- (void)setBandAdvertisName:(NSString *)bandAdvertisName
{
    _bandAdvertisName = bandAdvertisName;
    bleOpt.bandAdvertisName = bandAdvertisName;
}

- (void)setBleServiceAndCharater:(NSDictionary *)bleServiceAndCharater
{
    bleOpt.bleServiceAndCharater = bleServiceAndCharater;
    _bleServiceAndCharater = bleOpt.bleServiceAndCharater;
}

/*
 *  开始搜索设备
 *
 *  @param isOTAUploading 是否为OTA升级时的连接
 */
-(void)startScanDevice
{
    
    [bleOpt startScanDevice:@[[CBUUID UUIDWithString:BLE_CHARARCTERISTIC_SERVICE_BASE_UUID]]];
}

/*
 *  停止搜索外围设备
 */
-(void)stopScanDevice
{
    [bleOpt stopScanDevice];
}
/*
 *  连接选择的外围设备
 *  @param peripheral 指定的外围设备
 */
-(void)connectSelectPeripheral:(CBPeripheral *)peripheral
{
    [bleOpt connectSelectPeripheral:peripheral];
    
    
}

/*
 *  手动(人为的)断开当前连接的设备
 *
 */
- (void)disconnectCurrentPeripheral
{
    [bleOpt disconnectCurrentPeripheral];
}

/*
 * 重新连接
 */
-(void)restoreConnectBandByHand
{
    [bleOpt restoreConnectBandByHand];
}

- (BOOL)sendDataToBandWithType:(int)type data:(NSData *)data
{
    return [self sendDataToBandWithType:type data:data timeout:3];
}

- (BOOL)sendDataToBandWithType:(int)type data:(NSData *)data timeout:(int)timeout
{
    if(data.length<=0)
        return NO;
    
    NSDictionary *dic = [self gainCharacteristic:type];
    //分包
    NSArray *packDataArray = [BleCommonFun packageCurrentSendData:data];
    for(NSData *packData in packDataArray)
    {
        [bleOpt sendDataToBand:packData WithServiceUUID:BLE_CHARARCTERISTIC_SERVICE_BT_UUID WithCharacteristicUUID:dic[@"cha"] withWriteType:[dic[@"style"] integerValue]  WithResult:nil];
    }
    
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(timeOutOpt) userInfo:nil repeats:NO];
    
    return YES;
}

- (NSDictionary *)gainCharacteristic:(int)type
{
    switch (type) {
        case 0:
            return @{@"cha":BLE_ATT_UUID_AMDTP_RX0,
                     @"style":@(CBCharacteristicWriteWithoutResponse)};
            break;
        case 1:
            return @{@"cha":BLE_ATT_UUID_AMDTP_RX1,
                     @"style":@(CBCharacteristicWriteWithoutResponse)};
            break;
        case 2:
            return @{@"cha":BLE_ATT_UUID_AMDTP_RX2,
                     @"style":@(CBCharacteristicWriteWithoutResponse)};
            break;
        case 3:
            return @{@"cha":BLE_ATT_UUID_AMDTP_RX3,
                     @"style":@(CBCharacteristicWriteWithoutResponse)};
            break;
        case 4:
            return @{@"cha":BLE_ATT_UUID_AMDTP_RX4,
                     @"style":@(CBCharacteristicWriteWithoutResponse)};
            break;
        case 5:
            return @{@"cha":BLE_ATT_UUID_AMDTP_RX5,
                     @"style":@(CBCharacteristicWriteWithoutResponse)};
            break;
        case 6:
            return @{@"cha":BLE_ATT_UUID_AMDTP_RX6,
                     @"style":@(CBCharacteristicWriteWithoutResponse)};
            break;
            
        default:
            break;
    }
    
    return @{@"cha":BLE_ATT_UUID_AMDTP_RX0,
             @"style":@(CBCharacteristicWriteWithoutResponse)};
}

//发送超时的处理
- (void)timeOutOpt
{
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
    
    if([self.delegate respondsToSelector:@selector(didRecvResultData:type:dataDic:)])
    {
        [self.delegate didRecvResultData:NO type:0 dataDic:nil];
    }
}



//write的回调
-(void)didWriteDataFromBand:(NSData *)data WithServiceUUID:(NSString *)serviceUUID
{
}

/*
 接收数据的代理方法
 
 @param data 已经接收到的数据
 @param serviceUUID 接受到的数据对应的UUID
 */
-(void)didReceiveDataFromBand:(NSData *)data WithServiceUUID:(NSString *)serviceUUID
{
    NSLog(@"+>>didReceiveDataFromBand>>>>>%@",data);
    
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
    if (data == nil || data.length<=0)
    {
        return;
    }
    
    
    
}



@end
