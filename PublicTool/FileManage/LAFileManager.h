//
//  LAFileManager.h
//  SummaryTest
//
//  Created by  Tmac on 2017/7/24.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LAFileManager : NSObject
//////以下接口都是操作默认路径的文件，在系统Documents下（使用起来更加方便） defaultPath：hee/ddfs.txt可多级

/**
*  获取默认路径
*
*  @param defaultPath 可为nil或者文件夹路径（默认会加上默认路径）
*
*  @return 路径
*/
+ (NSString *)getDefaultPath:(NSString *)defaultPath;
//获取保存的目录
+ (NSString *)getSavePath:(NSString *)subPath;
///////////增加
+ (BOOL)writeTextToDefaultPath:(NSString *)defaultPath text:(NSString *)text;
+ (BOOL)appendTextToDefaultPath:(NSString *)defaultPath text:(NSString *)text;
+ (BOOL)writeImageToDefaultPath:(NSString *)defaultPath image:(UIImage *)image;
+ (BOOL)writeDataToDefaultPath:(NSString *)defaultPath data:(NSData *)data;

//////////查询
+ (NSString *)getTextFromDefaultPath:(NSString *)defaultPath;
+ (UIImage *)getImageFromDefaultPath:(NSString *)defaultPath;
+ (NSData *)getDataFromDefaultPath:(NSString *)defaultPath;
/**
 *  提供一个根目录，在根目录下查找文件并返回文件内容
 *
 *  @param rootPath 根路径
 *  @param fileName 要查找的文件
 *
 *  @return 文件内容，没找到返回nil
 */
+ (NSData *)getDataFromDefaultRootPath:(NSString *)rootPath fileName:(NSString *)fileName;

//返回某个目录下的所有文件和文件夹
//rootPath需遍历的根目录  isIn是否深度遍历 hasDirectory是否包含文件夹
//containOrFilter 包含(YES)或过滤(NO) mstr:名称，包含(YES)或过滤(NO)的内容
+ (NSDictionary *)getAllFileFromDeFaultRootPath:(NSString *)rootPath isIn:(BOOL)isIn hasDirectory:(BOOL)hasDirectory containOrFilter:(BOOL)containOrFilter mstr:(NSString *)mstr;
/**
 *  获取文件大小
 *
 *  @param filePath 绝对路径
 *
 *  @return 文件大小，单位kb
 */
+ (float)getFileSizeWithDefaultPath:(NSString *)filePath;
//判断文件是否存在
+ (BOOL)fileIsExistWithDefaultPath:(NSString *)filePath;

/////////////删除
/**
 *  删除文件或文件夹
 *
 *  @param filePath 绝对路径
 *
 *  @return BOOL
 */
+ (BOOL)deleteFileWithDefaultPath:(NSString *)filePath;
/**
 *  删除文件夹目录下说有的东西（但不删除此文件夹）
 *
 *  @param filePath 绝对路径
 *
 *  @return BOOL
 */
+ (BOOL)deleteAllWithDefaultPath:(NSString *)filePath;

///////////////修改
/**
 *  修改或移动文件或文件夹
 *
 *  @param srcFilePath 源路径
 *  @param decDefaultPath 目标路径
 *
 *  @return BOOL
 */
+ (BOOL)alterFileWithDefaultPath:(NSString *)srcFilePath decDefaultPath:(NSString *)decDefaultPath;

//拷贝
+ (BOOL)copyFileWithDefaultPath:(NSString *)srcFilePath decDefaultPath:(NSString *)decDefaultPath;




/////直接操作路径的，需要传入绝对路径
///////////增加
+ (BOOL)writeTextToPath:(NSString *)filePath text:(NSString *)text;
+ (BOOL)appendTextToPath:(NSString *)filePath text:(NSString *)text;
+ (BOOL)writeImageToPath:(NSString *)filePath image:(UIImage *)image;
+ (BOOL)writeDataToPath:(NSString *)filePath data:(NSData *)data;

//////////查询
+ (NSString *)getTextFromPath:(NSString *)filePath;
+ (UIImage *)getImageFromPath:(NSString *)filePath;
+ (NSData *)getDataFromPath:(NSString *)filePath;
/**
 *  提供一个根目录，在根目录下查找文件并返回文件内容
 *
 *  @param rootPath 根路径
 *  @param fileName 要查找的文件
 *
 *  @return 文件内容，没找到返回nil
 */
+ (NSData *)getDataFromRootPath:(NSString *)rootPath fileName:(NSString *)fileName;

//返回某个目录下的所有文件和文件夹
//rootPath需遍历的根目录  isIn是否深度遍历 hasDirectory是否包含文件夹
//containOrFilter 包含(YES)或过滤(NO) mstr:名称，包含(YES)或过滤(NO)的内容
+ (NSDictionary *)getAllFileFromRootPath:(NSString *)rootPath isIn:(BOOL)isIn hasDirectory:(BOOL)hasDirectory containOrFilter:(BOOL)containOrFilter mstr:(NSString *)mstr;
/**
 *  获取文件大小
 *
 *  @param filePath 绝对路径
 *
 *  @return 文件大小，单位kb
 */
+ (float)getFileSizeWithPath:(NSString *)filePath;
//判断文件是否存在
+ (BOOL)fileIsExist:(NSString *)filePath;

/////////////删除
/**
 *  删除文件或文件夹
 *
 *  @param filePath 绝对路径
 *
 *  @return BOOL
 */
+ (BOOL)deleteFileWithPath:(NSString *)filePath;
/**
 *  删除文件夹目录下说有的东西（但不删除此文件夹）
 *
 *  @param filePath 绝对路径
 *
 *  @return BOOL
 */
+ (BOOL)deleteAllWithPath:(NSString *)filePath;

///////////////修改
/**
 *  修改或移动文件或文件夹
 *
 *  @param srcFilePath 源路径
 *  @param decFilePath 目标路径
 *
 *  @return BOOL
 */
+ (BOOL)alterFileWithPath:(NSString *)srcFilePath decFilePath:(NSString *)decFilePath;

//拷贝
+ (BOOL)copyFileWithPath:(NSString *)srcFilePath decFilePath:(NSString *)decFilePath;
@end
