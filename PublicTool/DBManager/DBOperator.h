//
//  DBOperator.h
//  LenovoVB10
//
//  Created by jacy on 14/12/5.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

#define DBOPERATOR [DBOperator shared]

/**
 * 对数据库操作封装，是一个单例
 * 初始化:使用本类定义的 DBOPERATOR 调用所有的操作类
 *使用之前请先配置好数据库 搜索checkUserDatabase设置
 */

@interface DBOperator : NSObject

@property(nonatomic,strong)FMDatabaseQueue* dataOperationqueue;
@property (nonatomic, strong)FMDatabase *fmdb;
@property(nonatomic, strong)dispatch_queue_t queue;

+ (DBOperator *)shared;

- (void)checkUserDatabase;

//检查数据库字段的增加
- (void)checkForAdd;

- (void)testAdd;
/*********************************************数据库增操作***************/
/**
 *  插入某一条数据
 *
 *  @param sql       sql 语句如：[NSString stringWithFormat:@"INSERT INTO tablename(a,b,c)VALUES('%@','%@','%@')",1,2,3]
 *
 *  @return error
 */
- (NSError *)insertDefaultDataToSQL:(NSString *)sql;

/**
 *  插入某一条数据
 * 
 ringWithFormat:@"INSERT INTO tablename(a,b,c)VALUES('%@','%@','%@')",1,2,3]
 *  @param sqlexsit  判断符合条件的数据是否存在sql语句 如：[NSString stringWithFormat:@"select count(*) from tableName where %@ = '%@'",tableName,key,value];
 *
 *  @return error
 */
- (NSError *)insertDataToSQL:(NSString *)sql
                withExsitSql:(NSString *)sqlexsit;

/**
 *  插入某一条数据，若存在则更新
 *
 *  @param sql       sql 语句如：[NSString stringWithFormat:@"INSERT INTO tablename(a,b,c)VALUES('%@','%@','%@')",1,2,3]
 *  @param updateSql updateSql 语句如：[NSString stringWithFormat:@"UPDATE tablename SET a ='%@',b ='%@' where key ='%@',a,b,c]
 *  @param sqlexsit  判断符合条件的数据是否存在sql语句 如：[NSString stringWithFormat:@"select count(*) from tableName where %@ = '%@'",tableName,key,value];
 *
 *  @return error
 */
- (NSError *)insertDataToSQL:(NSString *)sql
                   updatesql:(NSString *)updateSql
                withExsitSql:(NSString *)sqlexsit;


/**********************************************数据库增操作***************/

/**********************************************数据库删除操作***************/
/**
 *  删除整个表
 *
 *  @param tableHeader 表名
 *
 *  @return NSError
 */
-(NSError *)deleteDateToSqlite:(NSString *)tableHeade;

/**
 *  删除表中符合某一条件的所有数据或某一条数据
 *
 *  @param sqlexsit  判断符合条件的数据是否存在sql语句 如：[NSString stringWithFormat:@"select count(*) from tableName where %@ = '%@'",tableName,key,value];
 *  @param deleteSql   数据库操作语句 如[NSString stringWithFormat:@"DELETE FROM '%@' where date < '%@'",tableName,20141010];
 *
 *  @return NSError
 */
-(NSError *)deleteDataToSqlitewithSqlexsit:(NSString *)sqlexsit
                                 deleteSql:(NSString *)deleteSql;

- (NSError *)deleteDataToSqliteWithDeleteSql:(NSString *)deleteSql;

/**********************************************数据库删除操作***************/
/**
 *  更新某一条数据
 *
 *  @param sqlexsit  判断该条数据是否存在sql语句：[NSString stringWithFormat:@"select count(*) from tableName where %@ = '%@'",key,value];
 *  @param sql    sql语句如：[NSString stringWithFormat:@"UPDATE tablename SET a ='%@',b ='%@' where key ='%@',a,b,value]
 *
 *  @return error
 */
- (NSError *)updateTheDataToDbWithExsitSql:(NSString *)sqlexsit
                                   withSql:(NSString *)sql;

- (NSError *)updateTheData:(NSString *)sql;

/**********************************************数据库更新修改操作***************/
/**********************************************数据库查询操作***************/
- (int)getCountFromTable:(NSString *)tableName;
/**
 *  查询符合某条数据是否存在
 *
 *  @param tableName 表名
 *  @param key       关键字
 *  @param value     关键字对应的值
 *
 *  @return bool值
 */
- (BOOL)checkTheDataExistOnDB:(NSString *)tableName
                      withKey:(NSString *)key
                    withValue:(NSString *)value;

/**
 *  取出某表中所有的数据
 *
 *  @param tableName 表名
 *
 *  @return 返回数组类型数据
 */
- (NSArray *)queryAllDataForSQL:(NSString *)tableName;

/**
 *  获取某特定条件的数据
 *
 *  @param sql sql语句如：[NSString stringWithFormat:@"select * from tablename where userid = '%@'",[Singleton getUserID]]
 *
 *  @return 返回数组类型数据
 */
- (NSArray *)getDataForSQL:(NSString *)sql;

/**
 *  取出数据库中特定范围的值
 *
 *  @param tableName 表名
 *  @param key 关键字
 *  @param from      在某一个范围内的开始值
 *  @param end       在某一个范围内的结束值
 *
 *  @return 返回数组
 */
- (NSArray *)queryForSQL:(NSString *)tableName
                 keyName:(NSString *)key
                    from:(NSString *)from
                     end:(NSString *)end;

/**
 *  按升/降序取出数据库中特定范围的值
 *
 *  @param tableName 表名
 *  @param key 关键字
 *  @param from      在某一个范围内的开始值
 *  @param end       在某一个范围内的结束值
 *  @param ascField  排序类型，默认的排序顺序为升序ASC，降序为DES
 *
 *  @return 返回数组
 */
- (NSArray *)queryOrderByForSQL:(NSString *)tableName
                        keyName:(NSString *)key
                           from:(NSString *)from
                            end:(NSString *)end
                       ascField:(NSString *)ascField;


/**
 *  从指定的数据库中取某个特定字段的数据
 *
 *  @param tableName      表头
 *  @param fieldNameArray 表中的所有字段数组
 *  @param key            关键字
 *  @param value          关键字对应的value
 *
 *  @return 取出的一条数据，以键值对的形式放入字典中。
 */

-(NSDictionary *)getDataFromDataBaseName:(NSString *)tableName
                          fieldNameArray:(NSArray *)fieldNameArray
                             checkoutKey:(NSString *)key
                           CheckOutValue:(NSString *)value;

/**
 *  判断某条件的数据是否存在
 *
 *  @param sql 数据库查询语句
 *
 *  @return 返回结果
 */
- (BOOL)checkTheDataExistOnDB:(NSString *)sql;
/**
 *  添加by Janson：使用事务批量插入数据，可能是最快的
 *
 *  @param tableName 表名
 *  @param dataArray 需要添加的数组，元素为NSDictionary
 */
- (void)insertDataToTable:(NSString *)tableName withArray:(NSArray <NSDictionary *>*)models;

/**
 *  添加by Star：使用事务批量插入数据，可能是最快的
 *
 *  @param tableName 表名
 *  @param dataArray 需要添加的数组，元素为NSDictionary
 */

- (void)insertDataArrayToDB:(NSString *)tableName withDataArray:(NSArray *)dataArray;

//插入单条数据
- (void)insertSingleDataToDB:(NSString *)tableName withDictionary:(NSDictionary *)dic;

//创建一个表:传递各种键
- (void)createDataBaseTable:(NSString*)tableName propertyAndType:(NSString*)property;



//////////////////////////////  by - Janson  //////////////////////////////
/*
 异步线程操作(串行处理数据库语句)
 */
//z数据
- (void)TinsertDataToTable:(NSString *)tableName withArray:(NSArray <NSDictionary *>*)models;

//删除数据  批量删除。。values存放要删除的那条数据对应key的值
- (void)TdeleteDataFromTable:(NSString *)tableName forKey:(NSString *)key withArray:(NSArray *)values;

//删除所有数据
- (void)TdeleteAllDataFromTable:(NSString *)tableName;

//更新数据  更新的数组里面所放的字典必须包含 key
- (void)TupdateDataFromTable:(NSString *)tableName forKey:(NSString *)key withArray:(NSArray <NSDictionary *>*)models;

//查询数据 条件语句自己加 "where 'userId' = '11'" 异步获取结果
- (void )TselectDataFromTable:(NSString *)tableName withWhereSql:(NSString *)sql withBlock:(void(^)(NSArray *arr))block;

//查询数据 条件语句自己加 "where 'userId' = '11'" 同步获取结果
- (NSArray *)TselectDataFromTable:(NSString *)tableName withWhereSql:(NSString *)sql;

//插入或者更新数据 (存在则更新)
- (void)TinsertOrUpdata:(NSString *)tableName withKey:(NSString *)key andArray:(NSArray <NSDictionary *>*)data;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@end
