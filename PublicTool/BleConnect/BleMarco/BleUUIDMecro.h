//
//  BleUUIDMecro.h
//  BleCommonDemo
//



/************************* 服务UUID ***************************
 *
 *   << 服务UUID 的 Mecro >>
 *
 *   by nelsen 2016.8.15
 ******************************************************************
 */


#ifndef BleUUIDMecro_h
#define BleUUIDMecro_h

#import "BleConnectMacro.h"
#import "BleCommandMacro.h"

//
/**
 *  一 : 服务基础UUID
 */
#define BLE_CHARARCTERISTIC_SERVICE_BASE_UUID  @"00002760-08C2-11E1-9073-0E8AC72E1011"
/**
 *  二 : 服务功能UUID
 */

/***********************************************************************
 *
 *  1:服务数据层控制信息UUID->  蓝牙数据层控制信息（简称 BT ）
 *
 ***********************************************************************
 */
#define BLE_CHARARCTERISTIC_SERVICE_BT_UUID           @"00002760-08C2-11E1-9073-0E8AC72E1011"

#define BLE_ATT_UUID_AMDTP_RX0          @"00002760-08C2-11E1-9073-0E8AC72E0011" //(write)
#define BLE_ATT_UUID_AMDTP_TX0          @"00002760-08C2-11E1-9073-0E8AC72E0012" //(notify)
#define BLE_ATT_UUID_AMDTP_RX1          @"00002760-08C2-11E1-9073-0E8AC72E0015"
#define BLE_ATT_UUID_AMDTP_TX1          @"00002760-08C2-11E1-9073-0E8AC72E0016"
#define BLE_ATT_UUID_AMDTP_RX2          @"00002760-08C2-11E1-9073-0E8AC72E0017"
#define BLE_ATT_UUID_AMDTP_TX2          @"00002760-08C2-11E1-9073-0E8AC72E0018"
#define BLE_ATT_UUID_AMDTP_RX3          @"00002760-08C2-11E1-9073-0E8AC72E0019"
#define BLE_ATT_UUID_AMDTP_TX3          @"00002760-08C2-11E1-9073-0E8AC72E001A"
#define BLE_ATT_UUID_AMDTP_RX4          @"00002760-08C2-11E1-9073-0E8AC72E001B"
#define BLE_ATT_UUID_AMDTP_TX4          @"00002760-08C2-11E1-9073-0E8AC72E001C"
#define BLE_ATT_UUID_AMDTP_RX5          @"00002760-08C2-11E1-9073-0E8AC72E001D"
#define BLE_ATT_UUID_AMDTP_TX5          @"00002760-08C2-11E1-9073-0E8AC72E001E"
#define BLE_ATT_UUID_AMDTP_RX6          @"00002760-08C2-11E1-9073-0E8AC72E001F"
#define BLE_ATT_UUID_AMDTP_TX6          @"00002760-08C2-11E1-9073-0E8AC72E0020"
#define BLE_ATT_UUID_AMDTP_ACK_PART     @"00002760-08C2-11E1-9073-0E8AC72E0013"


///////////OTA服务////////////////
#define ATT_UUID_AMOTA_SERVICE_PART     0x1001    (Service)

/*! Partial amota rx characteristic UUIDs */
#define ATT_UUID_AMOTA_RX_PART          0x0001   (write)

/*! Partial amota tx characteristic UUIDs */
#define ATT_UUID_AMOTA_TX_PART          0x0002 (notify)


#endif /* BleUUIDMecro_h */
