//
//  DBManager.m
//  DBTest
//
//  Created by star.zxc on 15/8/24.
//  Copyright (c) 2015年 star.zxc. All rights reserved.
//

#import "DBManager.h"
#import "DBOperator.h"

@implementation DBManager

+ (DBManager *)shared
{
    static DBManager* _operator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _operator = [[DBManager alloc] init];
    });
    return _operator;
}
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)insertOrUpdate:(NSString *)tableName dic:(NSDictionary *)dic withKeys:(NSArray *)keys withValues:(NSArray *)values
{
    NSArray *arr = [self dataFromDBWithKeys:tableName withKey:keys withValue:values];
    if(arr.count>0)
    {
        [self updateDataOnDBWithKeys:tableName withDictionary:dic withKey:keys withValue:values];
    }
    else
    {
        [self insertSingleDataToDB:tableName withDictionary:dic];
    }
}
/**
 *  插入单条数据
 *
 *  @param tableName   表名
 *  @param aDictionary 字典
 */
- (void)insertSingleDataToDB:(NSString *)tableName withDictionary:(NSDictionary *)aDictionary
{
    
    [DBOPERATOR insertDefaultDataToSQL:[self insertSql:tableName dic:aDictionary]];
}

- (NSString *)insertSql:(NSString *)tableName dic:(NSDictionary *)dic
{
    NSArray *keyArray = [dic allKeys];
    NSArray *valueArray = [dic allValues];
    NSMutableString *sqlStr = [[NSMutableString alloc] initWithFormat:@"INSERT INTO %@(",tableName];
    for (int i = 0; i < keyArray.count; i ++)
    {
        if (i < keyArray.count-1)
        {
            [sqlStr appendFormat:@"%@,",keyArray[i]];
        }
        else
        {
            [sqlStr appendFormat:@"%@) ",keyArray[i]];
        }
    }
    [sqlStr appendString:@"VALUES("];
    for (int i = 0; i < valueArray.count; i ++)
    {
        NSString *str = valueArray[i];
        if([str isKindOfClass:[NSString class]])
            str = [str stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        if (i < valueArray.count-1)
        {
            [sqlStr appendFormat:@"'%@',",str];
        }
        else
        {
            [sqlStr appendFormat:@"'%@')",str];
        }
    }
    
    
    return sqlStr;
}
/**
 *  批量插入数据
 *
 *  @param tableName 表名
 *  @param dataArray 数组
 */
- (void)insertArrayToDB:(NSString *)tableName withDataArray:(NSArray *)dataArray
{
    [DBOPERATOR TinsertDataToTable:tableName withArray:dataArray];
//    [DBOPERATOR insertDataArrayToDB:tableName withDataArray:dataArray];
}

/**
 *  更新某一条数据：若不存在则不能更新,同时需要一对键值
 *
 *  @param tableName   表名
 *  @param aDictionary 字典
 *  @param key         键
 *  @param value       值
 */
- (void)updateDataOnDB:(NSString *)tableName withDictionary:(NSDictionary *)aDictionary withKey:(NSString *)key withValue:(NSString *)value
{
    value = [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    NSString *sqlexist = [NSString stringWithFormat:@"select count(*) from %@ where %@ = '%@'",tableName,key,value];
    NSMutableArray *allKey = [NSMutableArray arrayWithArray:[aDictionary allKeys]];
    if ([allKey containsObject:key])
    {
        [allKey removeObject:key];
        NSMutableString *updateSql = [[NSMutableString alloc]initWithFormat:@"UPDATE %@ SET ",tableName];
        for (NSString *aKey in allKey)
        {
            NSString *tmp = aDictionary[aKey];
            if([tmp isKindOfClass:[NSNull class]] || tmp==nil)
                continue;
            if([tmp isKindOfClass:[NSString class]])
                tmp = [tmp stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            [updateSql appendFormat:@"%@ = '%@',",aKey,tmp];
        }
        [updateSql deleteCharactersInRange:NSMakeRange(updateSql.length-1, 1)];//移除最后一个逗号
        [updateSql appendFormat:@" where %@ = '%@'",key,value];
        NSError *error = [DBOPERATOR updateTheDataToDbWithExsitSql:sqlexist withSql:updateSql];
        if (error) {
            NSLog(@"更新出现错误");
        }
    }
    else
    {
        NSLog(@"字典中不包含所提供的键，请检查");
    }
}

- (void)updateDataOnDBWithKeys:(NSString *)tableName withDictionary:(NSDictionary *)aDictionary withKey:(NSArray *)keys withValue:(NSArray *)values
{
    if(keys.count<=0||keys.count!=values.count)
    {
        NSLog(@"更新出现参数错误");
        return;
    }
    NSMutableArray *allKey = [NSMutableArray arrayWithArray:[aDictionary allKeys]];
    [allKey removeObjectsInArray:keys];
    NSMutableString *updateSql = [[NSMutableString alloc]initWithFormat:@"UPDATE %@ SET ",tableName];
    for (NSString *aKey in allKey)
    {
        NSString *tmp = aDictionary[aKey];
        if([tmp isKindOfClass:[NSNull class]] || tmp==nil)
            continue;
        if([tmp isKindOfClass:[NSString class]])
            tmp = [tmp stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        [updateSql appendFormat:@"%@ = '%@',",aKey,tmp];
    }
    [updateSql deleteCharactersInRange:NSMakeRange(updateSql.length-1, 1)];//移除最后一个逗号
    
    for(int i=0;i<keys.count;i++)
    {
        NSString *key = [keys objectAtIndex:i];
        NSString *value = [values objectAtIndex:i];
        if([value isKindOfClass:[NSString class]])
            value = [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        if(i==0)
        {
            [updateSql appendFormat:@" where %@ = '%@'",key,value];
        }
        else
            [updateSql appendFormat:@" and %@ = '%@'",key,value];
    }
    NSError *error = [DBOPERATOR updateTheData:updateSql];
    if (error) {
        NSLog(@"更新出现错误");
    }
}

/**
 *  取出表中所有数据
 *
 *  @param tableName 表名
 *
 *  @return 数组
 */
- (NSArray *)allDataFromDB:(NSString *)tableName
{
    return [DBOPERATOR queryAllDataForSQL:tableName];
}

/**
 *  取出符合某个键值的数据：如果有进一步的要求请直接使用DBOperator类
 *
 *  @param tableName 表名
 *  @param key       键
 *  @param value     值
 *
 *  @return 数组
 */
- (NSArray *)dataFromDB:(NSString *)tableName withKey:(NSString *)key withValue:(NSString *)value
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'",tableName,key,value];
    return [DBOPERATOR getDataForSQL:sql];
}

- (NSArray *)dataFromDBWithKeys:(NSString *)tableName withKey:(NSArray *)keys withValue:(NSArray *)values
{
    if(keys.count<=0||keys.count!=values.count)
    {
        NSLog(@"出现参数错误");
        return nil;
    }
    
    NSMutableString *sql = [[NSMutableString alloc]initWithFormat:@"select * from %@",tableName];
    for(int i=0;i<keys.count;i++)
    {
        NSString *key = [keys objectAtIndex:i];
        NSString *value = [values objectAtIndex:i];
        if([value isKindOfClass:[NSString class]])
            value = [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        if(i==0)
        {
            [sql appendFormat:@" where %@ = '%@'",key,value];
        }
        else
            [sql appendFormat:@" and %@ = '%@'",key,value];
    }
    
    return [DBOPERATOR getDataForSQL:sql];
}

/**
 *  删除某个表
 *
 *  @param tableName 表名
 */
- (void)deleteTable:(NSString *)tableName
{
    NSError *error = [DBOPERATOR deleteDateToSqlite:tableName];
    if (error) {
        NSLog(@"删除表失败");
    }
}

/**
 *  删除符合某个键值的数据
 *
 *  @param tableName 表名
 *  @param key       键
 *  @param value     值
 */
- (void)deleteDataFromTable:(NSString *)tableName withKey:(NSString *)key withValue:(NSString *)value
{
    NSString *sqlexist = [NSString stringWithFormat:@"select count(*) from %@ where %@ = '%@'",tableName,key,value];
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ where %@ = '%@'",tableName,key,value];
    NSError *error = [DBOPERATOR deleteDataToSqlitewithSqlexsit:sqlexist deleteSql:deleteSql];
    if (error) {
        NSLog(@"删除数据失败");
    }
}

- (void)deleteDataWithKeys:(NSString *)tableName withKey:(NSArray *)keys withValue:(NSArray *)values
{
    if(keys.count<=0||keys.count!=values.count)
    {
        NSLog(@"出现参数错误");
        return;
    }
    
    NSMutableString *sql = [[NSMutableString alloc]initWithFormat:@"DELETE FROM %@",tableName];
    for(int i=0;i<keys.count;i++)
    {
        NSString *key = [keys objectAtIndex:i];
        NSString *value = [values objectAtIndex:i];
        if([value isKindOfClass:[NSString class]])
            value = [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        if(i==0)
        {
            [sql appendFormat:@" where %@ = '%@'",key,value];
        }
        else
            [sql appendFormat:@" and %@ = '%@'",key,value];
    }
    
    NSError *error = [DBOPERATOR deleteDataToSqliteWithDeleteSql:sql];
    if (error) {
        NSLog(@"删除数据失败");
    }
}

/**
 *  查询某数据是否存在
 *
 *  @param tableName 表明
 *  @param key       键
 *  @param value     值
 *
 *  @return BOOL值（是否存在）
 */
- (BOOL)checkDataExistOnDB:(NSString *)tableName withKey:(NSString *)key withValue:(NSString *)value
{
    NSString *sql = [NSString stringWithFormat:@"select count(*) from %@ where %@ = '%@'",tableName,key,value];
    return [DBOPERATOR checkTheDataExistOnDB:sql];
}

/**
 *  创建新的表：表字段类型全部为TEXT
 *
 *  @param tableName 表名
 *  @param keyArray  键数组
 */
- (void)createNewTable:(NSString *)tableName withKeyArray:(NSArray *)keyArray
{
    NSMutableString *sqlStr = [NSMutableString string];
    for (NSString *key in keyArray)
    {
        [sqlStr appendFormat:@"%@ TEXT,",key];
    }
    [sqlStr deleteCharactersInRange:NSMakeRange(sqlStr.length-1, 1)];
    [DBOPERATOR createDataBaseTable:tableName propertyAndType:sqlStr];
}
@end
