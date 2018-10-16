//
//  BleManager.h
//  BleSDK
//
//  Created by  Tmac on 2017/8/31.
//  Copyright © 2017年 Tmac. All rights reserved.
//  对BleOperatorManager的进一步封装，不同项目有不同的操作

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BleCommandMacro.h"
#import "BleConnectMacro.h"
#import "BleUUIDMecro.h"

@protocol BleManagerDelegate <NSObject>

@optional
/*
 发送后的结果返回 
 ret：成功或失败 
 type：类型，如果是多级类型，就占用多个字节 如0x4556 就是0x45下的0x56
 dataDic：带回来的数据
*/
- (void)didRecvResultData:(BOOL)ret type:(int)type dataDic:(NSDictionary *)dataDic;
/*
 蓝牙搜索的实时回调
 listArray: 搜索到的外设数组peripheral
 rssiDic:   peripheral对应的RSSI           key为peripheral.identifier.UUIDString
 macDic:    peripheral对应的mac地址         key为peripheral.identifier.UUIDString
 */
- (void)didRecvSearchList:(NSArray *)listArray rssiDic:(NSDictionary *)rssiDic macDic:(NSDictionary *)macDic;
/*
 OTA升级时候的进度回调
 completed：已发送的文件字节
 allLength：总的文件字节
 ret：NO升级失败，YES正确  当completed==allLength升级完成
 */
- (void)didRecvOTAResult:(int)completed allLength:(int)allLength ret:(BOOL)ret;
@end

@interface BleManager : NSObject

@property (nonatomic,weak) id<BleManagerDelegate> delegate;

/*
 是否需要自动重连
 */
@property (nonatomic)BOOL isAutoConnected;

/*
 *  正常模式下传入以service为key-character数组为Value的字典      有默认值，可以不设置
     @{
     BLE_CHARARCTERISTIC_SERVICE_BT_UUID:@[
     BLE_CHARARCTERISTIC_SERVICE_BT_WRITE_UUID,
     BLE_CHARARCTERISTIC_SERVICE_BT_READ_UUID
     ]
 };
 */
@property (nonatomic, strong)NSDictionary *bleServiceAndCharater;

/*
 * 需要搜搜的对应的设备的名字,若需要搜索所有设备，可不进行赋值
 */
@property (nonatomic, copy)NSString *bandAdvertisName;


+ (BleManager *)sharedInstance;

////////////////////////基本发送数据接口/////////////////////////

- (BOOL)sendDataToBandWithType:(int)type data:(NSData *)data;

- (BOOL)sendDataToBandWithType:(int)type data:(NSData *)data timeout:(int)timeout;

///////////////////////处理蓝牙连接管理操作///////////////////////

/*
 *  开始搜索设备

 */
-(void)startScanDevice;

/*
 *  停止搜索外围设备
 */
-(void)stopScanDevice;
/*
 *  连接选择的外围设备
 *  @param peripheral 指定的外围设备
 */
-(void)connectSelectPeripheral:(CBPeripheral *)peripheral;

/*
 *  手动(人为的)断开当前连接的设备

 */
-(void)disconnectCurrentPeripheral;
/*
 * 重新连接，一般不需要主动调用
 */
-(void)restoreConnectBandByHand;


@end
