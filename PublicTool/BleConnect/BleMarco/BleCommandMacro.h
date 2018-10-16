//
//  BleCommandMacro.h
//  FDCes
//
//  Created by  左衡 on 16/12/7.
//  Copyright © 2016年 com.Fenda.Fly. All rights reserved.
//

#ifndef BleCommandMacro_h
#define BleCommandMacro_h


/********************************************************
 *
 *   << 蓝牙指令Mecro >>
 *
 *   by nelsen 2016.8.15
 ******************************************************************
 */

//浅睡0，深睡1，清醒8，步行2，跑步3，骑行4

typedef enum
{
    //message :	form 0x01 to 0x1f        // 0x00 reserve
    
    BAND_RESPOND_DATA               = 0x44, //手环端反馈的数据
    IOS_CALL_RING                   = 0x02, //来电命令
    IOS_TEXT_MESSAGE                = 0x04, //短信命令
    IOS_CALL_SET                    = 0x13,//IOS设定来电提醒时间段范围
    IOS_TEXT_MESSAGE_SET            = 0x14,//IOS设定短信提时间段范围
    
    //local events:  form 0x31 to 0x5f        // 0x30 reserve
    APP_INFORMATION_SET             = 0x31, //设置APP信息 时间戳以及用户信息
    KEY_APP                         = 0x32,//不同AF500的APP_KEY，详细见命令说明,
    BAND_SET                        = 0x33,     //绑定手环的回复头
        BAND_SET_READY                 = 0x01,     //手环进入打开敲击绑定等待
        BAND_SET_FAIL                  = 0x02,     //手环敲击失败，准备断开连接
        BAND_SET_KNOCK_SUCC            = 0x03,     //手环敲击成功
        BAND_SET_SUCC                  = 0x04,     //手环绑定成功
    SYSTEM_RECOVER                  = 0x34,//恢复出厂设置
    SYSTEM_SET_DEFAULT              = 0x35,//恢复为工厂模式
    SET_DEVICE_NAME                 = 0x36,//设置设备名称 15*Uint8
    SET_ALERM                       = 0x37,//设置闹钟 小时+分钟+循环
    SEND_TURNOFF_BAND               = 0x38,//关闭手环命令
    APP_GET_VBATTERY_LEVEL          = 0x3a, //APP获取手环的电量
    RES_VBATTERY_LEVER              = 0x3b, //链接蓝牙时以及以后每5分钟手环会主动上发数据到手环
    APP_GET_CURROR_DATA             = 0x3c, //APP主动获取当前手环不到一分钟的数据.实时数据
    APP_FIND_BAND                   = 0x3f, //手机找手环
    
    APP_SYN_TIME                    = 0x40,//发送同步时间
    BLE_APP_DISCONNECT_LINK         = 0x41, //通知手环断开蓝牙
    BAND_VIBRATION_MODEL            = 0x42, //手环震动模式
    BLE_APP_GET_MOTOR_SETTING       = 0x43, //获取手环震动模式
    BAND_END_SLEEP                  = 0x4a, //睡眠结束后的指令
    
    //Get the local imformation form 0x60 to 0x7f
    GET_WRISTBAND_INFORMATION       = 0x61, //获取手环的版本信息
    GET_WRISTBAND_SETTING           = 0x62, //获取手环存储的APP信息
    GET_DEVICE_NAME_SETTING			= 0x63, //获取设备的名称
    GET_ALERM_SETTING				= 0x64,
    //sensor information  from 0xa0 to 0xaf
    UPDATE_DATA_REQUEST   			= 0xa1,  //获取历史数据
    UPDATA_UV_DATA                  = 0xa2,  //UV数据开始测试
    UPDATA_UV_SEND_DATA_END			= 0xa7,  //UV数据结束测试
    
    UPDATE_DATA   		        	       =    0xb1, //手环反馈的历史运动数据 类型+时间戳+3*运动数据
    UPDATE_DATA_WHEN_WRISTBAND_CONNECTED   =    0xb2, //手环主动上报的数据
    
    UPDATE_END                      	   =    0xb3, //历史数据同步结束
    UPDATA_UV_RESPOND_DATA                 =    0xb4, //蓝牙发过来的实时UV数据
    
    DELETE_BAND_HIETORYDATA                =    0xb5,//删除手环的历史数据
    UPDATE_DATA_RESPONS_NEW                =    0xb8,//手环反馈的历史运动数据 类型+时间戳+运动数据+时间戳+运动数据
    
    //Test command from 0xb0 to 0xcf
    ENTER_TEST_MODE		=           0xc0, //进入测试模式
    QUIT_TEST_MODE		=			0xc1, //退出测试模式
    SENSOR_ORI_DATA_GET_ONCE	=   0xc2, //得到三轴数据
    RESPOND_SENSOR_DATA   = 0xc3  ,//接收到的三轴数据
    MOTO_ENABLE			    	=   0xc5, //马达起振
    MOTO_DISBALE                =   0xc6, //马达停止振动
    LED_ENABLE					=	0xc7, //LED亮
    LED_DISABLE					=	0xc8, //LED 灭
    GET_UV_SINGNAL             =	0xc9, //获取紫外线的单次值
    GET_UV_CC					=	0xce, //获取CC值
    
    GET_BAND_LOCALTIME			     =	0xd0, //获取手环本地时间
    
    
    ENTER_NORDIC_DFU             = 0xb7, //nordic进入DFU模式
    
    OTA_ADD_SPEED			     =	0xd6, //升级加速指令
    
    //测试相机使用
    //0x44　＋　数据协议类型
    CAMERA_OPEN              = 0X05, //打开照相机
    CAMERA_CLOSE             = 0X06, //关闭照相机
    CAMERA_SHUT              = 0X07, //快门拍照[双击]
    CAMERA_TAKE_PICTURE_OVER  = 0X08, //拍照完成
    FIND_PHONE                 = 0X09,
    
#pragma 测试蓝牙注释
    GET_BLE_CONNECT_LOGINFO = 0xF9, //获取手环断开连接的Log信息
    RESPOND_BLE_CONNECT_LOG_END = 0xFB, //发送断链Log信息结束
    CLEARN_BLE_CONNECT_LOGINFO = 0xFA, //清除断链Log信息
    LARGE_DATA_TEST  = 0xd7, //测试大数据
    
    GET_MAC_ADRESS = 0xcb,//获取MAC地址
    DELETE_TIME = 0xe1,//删除数据的时间
    
#pragma 获取算法LOG
    GET_ARITHMETIC_LOG = 0xf0,
    RESPONE_LOG_END = 0xf1,
    CLEAR_ARITHMETIC_LOG = 0xb6,
    WATCH_DOG_LOG = 0xF4,
}WEARABLE_PACKAGEHEADER;


#endif /* BleCommandMacro_h */
