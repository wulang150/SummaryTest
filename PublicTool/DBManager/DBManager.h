//
//  DBManager.h
//  DBTest
//
//  Created by star.zxc on 15/8/24.
//  Copyright (c) 2015年 star.zxc. All rights reserved.
//该类旨在提供数据操作的更直观的接口，避免使用数据库语句

#import <Foundation/Foundation.h>
 
@interface DBManager : NSObject

#define DBMANAGER [DBManager shared]
+ (DBManager *)shared;

/**
 *  插入或更新单条数据
 *
 *  @param tableName   表名
 *  @param dic   需要更新的数据字典
 *  @param keys 条件key值数组
 *  @param values 条件值数组
 */
- (void)insertOrUpdate:(NSString *)tableName dic:(NSDictionary *)dic withKeys:(NSArray *)keys withValues:(NSArray *)values;
/**
 *  插入单条数据
 *
 *  @param tableName   表名
 *  @param aDictionary 字典
 */
- (void)insertSingleDataToDB:(NSString *)tableName withDictionary:(NSDictionary *)aDictionary;

/**
 *  批量插入数据
 *
 *  @param tableName 表名
 *  @param dataArray 数组
 */
- (void)insertArrayToDB:(NSString *)tableName withDataArray:(NSArray *)dataArray;

/**
 *  更新某一条数据：若不存在则不能更新,同时需要一对键值
 *
 *  @param tableName   表名
 *  @param aDictionary 字典
 *  @param key         键
 *  @param value       值
 */
- (void)updateDataOnDB:(NSString *)tableName withDictionary:(NSDictionary *)aDictionary withKey:(NSString *)key withValue:(NSString *)value;
//多主键的更新
- (void)updateDataOnDBWithKeys:(NSString *)tableName withDictionary:(NSDictionary *)aDictionary withKey:(NSArray *)keys withValue:(NSArray *)values;
/**
 *  取出表中所有数据
 *
 *  @param tableName 表名
 *
 *  @return 数组
 */
- (NSArray *)allDataFromDB:(NSString *)tableName;

/**
 *  取出符合某个键值的数据：如果有进一步的要求请直接使用DBOperator类
 *
 *  @param tableName 表名
 *  @param key       键
 *  @param value     值
 *
 *  @return 数组
 */
- (NSArray *)dataFromDB:(NSString *)tableName withKey:(NSString *)key withValue:(NSString *)value;
//多主键查找
- (NSArray *)dataFromDBWithKeys:(NSString *)tableName withKey:(NSArray *)keys withValue:(NSArray *)values;
/**
 *  删除某个表
 *
 *  @param tableName 表名
 */
- (void)deleteTable:(NSString *)tableName;


/**
 *  删除符合某个键值的数据
 *
 *  @param tableName 表名
 *  @param key       键
 *  @param value     值
 */
- (void)deleteDataFromTable:(NSString *)tableName withKey:(NSString *)key withValue:(NSString *)value;
//多主键删除
- (void)deleteDataWithKeys:(NSString *)tableName withKey:(NSArray *)keys withValue:(NSArray *)values;
/**
 *  查询某数据是否存在
 *
 *  @param tableName 表明
 *  @param key       键
 *  @param value     值
 *
 *  @return BOOL值（是否存在）
 */
- (BOOL)checkDataExistOnDB:(NSString *)tableName withKey:(NSString *)key withValue:(NSString *)value;


/**
 *  创建新的表：表字段类型全部为TEXT
 *
 *  @param tableName 表名
 *  @param keyArray  键数组
 */
- (void)createNewTable:(NSString *)tableName withKeyArray:(NSArray *)keyArray;
@end
