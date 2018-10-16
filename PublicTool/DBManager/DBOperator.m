//
//  DBOperator.m
//  LenovoVB10
//
//  Created by jacy on 14/12/5.
//  Copyright (c) 2014年 fenda. All rights reserved.
//



#import "DBOperator.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabase.h"

#define Sqlite_AppVersion   @"Sqlite_AppVersion"      //app内的sqlite版本，存于app中

@interface DBOperator()

//以下为基础数据库操作，不允许外部调用
- (NSError*)errorWithMessage:(NSString*)message;
- (NSArray *)basequeryForSQL:(NSString *)sql db:(FMDatabase*)db;
- (NSError*)updateForSQL:(NSString *)sql db:(FMDatabase*)db;

//查询条数据是否存在
- (BOOL)checkRecordExist:(NSString*)sql db:(FMDatabase *)db;
//检查数据是否存在
-(BOOL)checkDataExist:(NSString *)selectSql;
- (BOOL)checkTheDataExistOnDB:(NSString *)sql;
@end

@implementation DBOperator

+ (DBOperator *)shared
{
    static DBOperator* _operator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _operator = [[DBOperator alloc] init];
    });
    return _operator;
}

- (id)init
{
    self = [super init];
    if (self) {
        _queue = dispatch_queue_create("DBQUEUE", 0);
        [self checkUserDatabase];
        
    }
    return self;
}

- (void)testAdd
{
//    NSString *sql = @"insert into t_testTable values('rrb','tabb',12,'tabtt','ssss')";
//    
//    __block NSError *error = 0x00;
//    [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
//        error = [self updateForSQL:sql db:db];
//        NSLog(@"~~~~error~~~~%@",error);
//    }];
    
//    sql = @"insert into t_testTable values('rrb','tabl1',11,'tab31')";
//    
//    [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
//        error = [self updateForSQL:sql db:db];
//        NSLog(@"~~~~error~~~~%@",error);
//    }];
    
    NSArray *arr = [self queryAllDataForSQL:@"t_testTable"];
    
    for(NSDictionary *dic in arr)
    {
        NSLog(@"~~%@",dic);
    }
}

//检查数据库字段的增加
- (void)checkForAdd
{
    //字段类型 integer text blob
    //100版本
    NSDictionary *dic100 = @{@"t_testTable":@[@"tab1 text",@"tab2 integer"]};
    NSDictionary *dic101 = @{@"t_testTable":@[@"tab3 text"]};
    NSDictionary *dic102 = @{@"t_testTable":@[@"tab4 text"]};
    
    NSDictionary *allDic = @{@"100":dic100,
                             @"101":dic101,
                             @"102":dic102};
    
    NSString *appVersionStr = [[NSUserDefaults standardUserDefaults] objectForKey:Sqlite_AppVersion];
    int appVersion = [appVersionStr intValue];
    
    int maxVer = 0;
    for(NSString *key in [allDic allKeys])
    {
        int ver = [key intValue];
        if(ver>maxVer)
            maxVer = ver;
        if(appVersion>=ver)     //比app版本低的操作不做处理
            continue;
        NSDictionary *dic = allDic[key];
        for(NSString *table in [dic allKeys])       //需要修改的所有表
        {
            //sqlite不支持多字段添加，只能分步做了
            NSArray *valueArr = (NSArray *)dic[table];      //添加的字段
            for(NSString *str in valueArr)
            {
                NSString *addSql = [NSString stringWithFormat:@"alter table %@ add %@",table,str];
                //执行
                __block NSError *error = 0x00;
                [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
                    error = [self updateForSQL:addSql db:db];
                    if(error)
                    {
                        NSLog(@"~~~~error~~~~%@",error);
                    }
                }];
            }
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",maxVer] forKey:Sqlite_AppVersion];
    
}

// 检测沙盒中是否有数据库文件，没有则从资源库拷贝到沙盒
- (void)checkUserDatabase
{
    NSString *dataBaseName = @"10000";      //用户的userid，每个用户一个数据库
    if (dataBaseName != nil)
    {
        [self checkDatabase:@"mypro.sqlite" targetName:[NSString stringWithFormat:@"%@.sqlite",dataBaseName]];
    }
}

- (void)checkDatabase:(NSString *)orginName targetName:(NSString *)targetName
{
    // 设置一个成功标志
    BOOL success;
    BOOL isCopy = NO;
    // 当前的数据库名称
    NSString *dbFile = orginName;
    
    // 创建一个文件管理者
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writeDBPath = [documentsDirectory stringByAppendingPathComponent:targetName];
    success = [fileManager fileExistsAtPath:writeDBPath];
    
    if (!success) {//沙盒中没有数据库
        // 检测资源库里面是否有数据库文件
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbFile];
        NSLog(@"文件路径为:%@",defaultDBPath);
        success = [fileManager fileExistsAtPath:defaultDBPath];
        
        if (success) {
            // 将数据库文件从资源库拷贝到沙盒中
            success  = [fileManager copyItemAtPath:defaultDBPath toPath:writeDBPath error:&error];
            if (!success)
            {
                NSLog(@"Failed to create writable database file with message '%@'.", [error localizedDescription]);
            }
            else  // 如果复制成功 加入 版本信息表
            {
                isCopy = YES;
                NSLog(@"复制==========>>>>>");
            }
        }else{
            NSLog(@"资源库中没有数据库文件：%@~~~%@",writeDBPath, defaultDBPath);
        }
    }
    
    if (success) {
        _fmdb = [[FMDatabase alloc] initWithPath:writeDBPath];
        self.dataOperationqueue = [FMDatabaseQueue databaseQueueWithPath:self.fmdb.databasePath];
        
        if (![_fmdb open]) {
            NSLog(@"open db failed.");
        }
        NSLog(@"写入文件%@", writeDBPath);
    }
    // by -- Janson
    if (isCopy) {
        NSString *sql1 = @"CREATE TABLE db_version (version TEXT NOT NULL)";
        [_fmdb executeUpdate:sql1];

        NSDictionary *app = [[NSBundle mainBundle] infoDictionary];
        NSString *appCurVersion = [app objectForKey:@"CFBundleShortVersionString"];
        NSString *sql2 = [NSString stringWithFormat:@"INSERT INTO db_version(version) VALUES('%@')",appCurVersion];
        [_fmdb executeUpdate:sql2];
    }
}
//＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃基本数据库操作＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃
- (NSError*)errorWithMessage:(NSString*)message
{
    NSDictionary* errorMessage = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
    
    return [NSError errorWithDomain:@"Runner" code:1000 userInfo:errorMessage];
}
//基础数据库操作(不要直接使用，请在数据库队列中使用)
- (NSArray *)basequeryForSQL:(NSString *)sql db:(FMDatabase*)db
{
    __block NSMutableArray *array = [NSMutableArray array];
    FMResultSet *result = [db executeQuery:sql];
    while ([result next])
    {
        [array addObject:[result resultDictionary]];
    }
    
    //deal with null
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (dic in array)
    {
        NSArray *keys = [dic allKeys];
        
        for (NSString *key in keys)
        {
            if ([[dic objectForKey:key] isEqual:[NSNull null]])
            {
                [dic setValue:nil forKey:key];
            }
        }
    }
    return array;
}

- (NSError*)updateForSQL:(NSString *)sql db:(FMDatabase*)db
{
    BOOL success = NO;
    sql = [sql stringByReplacingOccurrencesOfString:@"'(null)'" withString:@"NULL"];
    success = [db executeUpdate:sql];
    if (!success) {
        NSLog(@"%@", db.lastError);
    }
    if ([db.lastError.localizedDescription isEqualToString:@"not an error"]) {
        return nil;
    }
    return db.lastError;
}

//查询条数据是否存在
- (BOOL)checkRecordExist:(NSString*)sql db:(FMDatabase *)db
{
    
    int count = 0;
    BOOL exist = NO;
    count = [db intForQuery:sql];
    if (count<=0) {
        exist = NO;
    }else{
        exist = YES;
    }
    return exist;
}

//检查数据是否存在
-(BOOL)checkDataExist:(NSString *)selectSql
{
    __block BOOL result = 0;
    [_dataOperationqueue inDatabase:^(FMDatabase *db) {
        result = [db intForQuery:selectSql];
    }];
    return result;
}

- (BOOL)checkTheDataExistOnDB:(NSString *)sql
{
    __block BOOL result = NO;
    [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
        result = [self checkRecordExist:sql db:db];
    }];
    return result;
}

//＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃可直接调用的数据库接口：增删改查＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃
/*********************************************数据库增操作***************/
/**
 *  插入某一条数据
 *
 *  @param sql       sql 语句如：[NSString stringWithFormat:@"INSERT INTO tablename(a,b,c)VALUES('%@','%@','%@')",1,2,3]
 *
 *  @return error
 */
- (NSError *)insertDefaultDataToSQL:(NSString *)sql
{
    if (self.dataOperationqueue == nil)
    {
        self.dataOperationqueue = [FMDatabaseQueue databaseQueueWithPath:self.fmdb.databasePath];
    }
    __block NSError *error = 0x00;
    [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
        error = [self updateForSQL:sql db:db];
        NSLog(@"~~~~exsit~~~~%@",error);
    }];
    
    return error;
}

/**
 *  插入某一条数据
 *
 *  @param sql       sql 语句如：[NSString stringWithFormat:@"INSERT INTO tablename(a,b,c)VALUES('%@','%@','%@')",1,2,3]
 *  @param sqlexsit  判断符合条件的数据是否存在sql语句 如：[NSString stringWithFormat:@"select count(*) from tableName where %@ = '%@'",tableName,key,value];
 *
 *  @return error
 */
- (NSError *)insertDataToSQL:(NSString *)sql
                withExsitSql:(NSString *)sqlexsit
{
    if (self.dataOperationqueue == nil)
    {
        self.dataOperationqueue = [FMDatabaseQueue databaseQueueWithPath:self.fmdb.databasePath];
    }
    __block NSError *error = 0x00;
    BOOL exsit = [self checkTheDataExistOnDB:sqlexsit];
    if (!exsit) {
        [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
            error = [self updateForSQL:sql db:db];
            NSLog(@"~~~~exsit~~~~%@",error);
        }];
    }else{//已经存在
        error = [self errorWithMessage:@"该条数据已经存在，不能进行插入操作!"];
        NSLog(@"~~~~~~~~%@",error);
    }
    
    return error;
}
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
               withExsitSql:(NSString *)sqlexsit
{
    if (self.dataOperationqueue == nil)
    {
        self.dataOperationqueue = [FMDatabaseQueue databaseQueueWithPath:self.fmdb.databasePath];
    }
    
    __block NSError *error = 0x00;
    BOOL exsit = [self checkTheDataExistOnDB:sqlexsit];
    if (!exsit) {
         NSLog(@"不存在");
        [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
            error = [self updateForSQL:sql db:db];
        }];
    }else{//已经存在，则更新
        NSLog(@"已经存在,更新");
        [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
            error = [self updateForSQL:updateSql db:db];
        }];
    }
    
    return error;
}

/**********************************************数据库增操作***************/


/**********************************************数据库删除操作***************/
/**
 *  删除整个表
 *
 *  @param tableHeader 表名
 *
 *  @return NSError
 */
-(NSError *)deleteDateToSqlite:(NSString *)tableHeader
{
    __block NSError *error = 0x00;
    NSString *sql = [NSString stringWithFormat:@"select count(*) from %@ ",tableHeader];
    BOOL exsit = [self checkTheDataExistOnDB:sql];
    if (!exsit) {
        error = [self errorWithMessage:@"该表为空!"];
    }else{
        [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",tableHeader];
            error = [self updateForSQL:sql db:db];
        }];
    }
    return error;
    
}

/**
 *  删除表中符合某一条件的所有数据或某一条数据
 *
 *  @param sqlexsit  判断符合条件的数据是否存在sql语句 如：[NSString stringWithFormat:@"select count(*) from tableName where %@ = '%@'",tableName,key,value];
 *  @param deleteSql   数据库操作语句 如[NSString stringWithFormat:@"DELETE FROM '%@' where date < '%@'",tableName,20141010];
 *
 *  @return NSError
 */

-(NSError *)deleteDataToSqlitewithSqlexsit:(NSString *)sqlexsit
                                  deleteSql:(NSString *)deleteSql
{
    __block NSError *error = 0x00;
    BOOL exsit = [self checkTheDataExistOnDB:sqlexsit];
    if (!exsit) {
        error = [self errorWithMessage:@"符合该条件的数据不存在，不能进行删除操作!"];
    }else{
        [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
            error = [self updateForSQL:deleteSql db:db];
        }];
    }
    return error;
}

- (NSError *)deleteDataToSqliteWithDeleteSql:(NSString *)deleteSql
{
    __block NSError *error = 0x00;
    [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
        error = [self updateForSQL:deleteSql db:db];
    }];
    
    return error;
}
/**********************************************数据库删除操作***************/


/**********************************************数据库更新修改操作***************/
/**
 *  更新某一条数据
 *
 *  @param sqlexsit  判断该条数据是否存在sql语句：[NSString stringWithFormat:@"select count(*) from tableName where %@ = '%@'",key,value];
 *  @param sql    sql语句如：[NSString stringWithFormat:@"UPDATE tablename SET a ='%@',b ='%@' where key ='%@',a,b,value]
 *
 *  @return error
 */
- (NSError *)updateTheDataToDbWithExsitSql:sqlexsit
                       withSql:(NSString *)sql
{
    
    __block NSError *error = 0x00;
    BOOL exsit = [self checkTheDataExistOnDB:sqlexsit];
    if (!exsit) {
        error = [self errorWithMessage:@"该条数据不存在，不能进行更新操作!"];
        NSLog(@"该条数据不存在，不能进行更新操作!");
    }else{
        [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
            error = [self updateForSQL:sql db:db];
        }];
    }
    return error;
}

- (NSError *)updateTheData:(NSString *)sql
{
     __block NSError *error = 0x00;
    [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
        error = [self updateForSQL:sql db:db];
    }];
    
    return error;
}

/**********************************************数据库更新修改操作***************/


/**********************************************数据库查询操作***************/
- (int)getCountFromTable:(NSString *)tableName
{
    __block int count = 0;
    NSString *sql = [NSString stringWithFormat:@"select count(*) from %@",tableName];
    [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
        count = [db intForQuery:sql];
    }];
    
    return count;
}
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
                    withValue:(NSString *)value
{
    __block BOOL result = NO;
    NSString *sql = [NSString stringWithFormat:@"select count(*) from %@ where %@ = '%@'",tableName,key,value];
    [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
        result = [self checkRecordExist:sql db:db];
    }];
    return result;
}


/**
 *  取出某表中所有的数据
 *
 *  @param tableName 表名
 *
 *  @return 返回数组类型数据
 */
- (NSArray *)queryAllDataForSQL:(NSString *)tableName
{
    __block  NSArray *array = [NSMutableArray array];
    [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM '%@'",tableName];
        array = [self basequeryForSQL:sql db:db];
    }];
    return array;
    
}

/**
 *  获取某特定条件的数据
 *
 *  @param sql sql语句如：[NSString stringWithFormat:@"select * from tablename where userid = '%@'",[Singleton getUserID]]
 *
 *  @return 返回数组类型数据
 */
- (NSArray *)getDataForSQL:(NSString *)sql
{
    //NSLog(@"sql=%@",sql);
    __block  NSArray *array = [NSMutableArray array];
    [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
        array = [self basequeryForSQL:sql db:db];
    }];
    return array;
}

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
                     end:(NSString *)end
{
    NSString *resultSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ BETWEEN '%@' AND '%@'",tableName,key,from,end];
    //    NSLog(@"~~~~sql:~%@",resultSql);
    __block  NSArray *array = [NSMutableArray array];
    [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
        array = [self basequeryForSQL:resultSql db:db];
    }];
    return array;
    
    
}

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
                       ascField:(NSString *)ascField
{
    NSString *resultSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ BETWEEN '%@' AND '%@' ORDER BY %@",tableName,key,from,end,ascField];
    __block  NSArray *array = [NSMutableArray array];
    [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
        array = [self basequeryForSQL:resultSql db:db];
    }];
    return array;
    
    
}

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
                           CheckOutValue:(NSString *)value
{
    if ([fieldNameArray count] <= 0)
    {
        return nil;
    }
    NSDictionary *resultDic = [NSDictionary new];
    if ([_fmdb open])
    {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %@",tableName,key,value];
        FMResultSet *set = [_fmdb executeQuery:sql];
        NSInteger i = 0;
        while ([set next])
        {
            [resultDic setValue:[set stringForColumn:[fieldNameArray objectAtIndex:i]] forKey:[fieldNameArray objectAtIndex:i]];
            i++;
        }
    }
    
    return resultDic;
}

//批量向表中插入数据:首先构造插入语句，最后批量提交,by Star
- (void)insertArrayToDB:(NSString *)tableName withValue:(NSArray *)valueArray
{
    if ([_fmdb open])
    {
        //存储数据库语句的数组
        NSMutableArray *sqlArray = [NSMutableArray array];
        for (NSDictionary *dic in valueArray)
        {
            NSArray *keyArray = [dic allKeys];
            NSArray *valueArray = [dic allValues];
            NSMutableString *insertSql = [[NSMutableString alloc] initWithFormat:@"INSERT INTO %@(",tableName];
            for (int i = 0; i < keyArray.count; i ++)
            {
                if (i < keyArray.count-1)
                {
                    [insertSql appendFormat:@"%@,",keyArray[i]];
                }
                else
                {
                    [insertSql appendFormat:@"%@) ",keyArray[i]];
                }
            }
            [insertSql appendString:@"VALUES("];
            for (int i = 0; i < valueArray.count; i ++)
            {
                if (i < valueArray.count-1)
                {
                    [insertSql appendFormat:@"'%@',",valueArray[i]];
                }
                else
                {
                    [insertSql appendFormat:@"'%@')",valueArray[i]];
                }
            }
            //NSLog(@"插入语句：%@",insertSql);
            [sqlArray addObject:insertSql];
        }
        //使用事务处理
        [_fmdb beginTransaction];
        for (NSString *sql in sqlArray)
        {
            if (![_fmdb executeUpdate:sql])
            {
                NSLog(@"~~~~~事务插入失败");
            }
//            else
//            {
//                NSLog(@"插入成功");
//            }
        }
        [_fmdb commit];
        [_fmdb close];
    }

}
//
- (void)insertDataToTable:(NSString *)tableName withArray:(NSArray <NSDictionary *>*)models
{
    [_dataOperationqueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isRollBack = NO;
        @try {
            for (NSDictionary *model in models) {
                
                NSArray *keyArray = [model allKeys];
                NSArray *valueArray = [model allValues];
                NSMutableString *insertSql = [[NSMutableString alloc] initWithFormat:@"INSERT INTO %@(",tableName];
                for (int i = 0; i < keyArray.count; i ++)
                {
                    if (i < keyArray.count-1)
                    {
                        [insertSql appendFormat:@"%@,",keyArray[i]];
                    }
                    else
                    {
                        [insertSql appendFormat:@"%@) ",keyArray[i]];
                    }
                }
                [insertSql appendString:@"VALUES("];
                for (int i = 0; i < valueArray.count; i ++)
                {
                    if (i < valueArray.count-1)
                    {
                        [insertSql appendFormat:@"'%@',",valueArray[i]];
                    }
                    else
                    {
                        [insertSql appendFormat:@"'%@')",valueArray[i]];
                    }
                }
                
                BOOL a = [db executeUpdate:insertSql];
                
                if (!a) {
                    NSLog(@"插入失败1");
                }
            }
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [db rollback];
        }
        @finally {
            NSLog(@"数据操作结束");
        }
    }];
}
//执行事务语句:数组元素为sql语句,保证插入数组不为空
- (void)insertDataArrayToDB:(NSString *)tableName withDataArray:(NSArray *)dataArray
{
    if ([_fmdb open])
    {
        [_fmdb beginTransaction];
        BOOL isRollBack = NO;
        @try {
            for (int i = 0; i < dataArray.count; i ++)
            {
                NSDictionary *dic = dataArray[i];
                NSArray *keyArray = [dic allKeys];
                NSArray *valueArray = [dic allValues];
                NSMutableString *insertSql = [[NSMutableString alloc] initWithFormat:@"INSERT INTO %@(",tableName];
                for (int i = 0; i < keyArray.count; i ++)
                {
                    if (i < keyArray.count-1)
                    {
                        [insertSql appendFormat:@"%@,",keyArray[i]];
                    }
                    else
                    {
                        [insertSql appendFormat:@"%@) ",keyArray[i]];
                    }
                }
                [insertSql appendString:@"VALUES("];
                for (int i = 0; i < valueArray.count; i ++)
                {
                    if (i < valueArray.count-1)
                    {
                        [insertSql appendFormat:@"'%@',",valueArray[i]];
                    }
                    else
                    {
                        [insertSql appendFormat:@"'%@')",valueArray[i]];
                    }
                }

                BOOL a = [_fmdb executeUpdate:insertSql];
                if (!a) {
                    NSLog(@"插入失败1");
                }
            }
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [_fmdb rollback];
        }
        @finally {
            if (!isRollBack) {
                [_fmdb commit];
            }
        }
        [_fmdb close];
    }
}



- (void)insertSingleDataToDB:(NSString *)tableName withDictionary:(NSDictionary *)dic
{
    NSArray *array = [NSArray arrayWithObject:dic];
    [self insertDataArrayToDB:tableName withDataArray:array];
}
- (void)createDataBaseTable:(NSString*)tableName propertyAndType:(NSString*)property
{
    if ([self.fmdb open])
    {
        /**
         *  判断表是否存在,如果不存在，就创建表
         */
        NSString *existsSql = [NSString stringWithFormat:@"select count(name) as countNum from sqlite_master where type = 'table' and name = '%@'", tableName ];
        FMResultSet *rs = [self.fmdb executeQuery:existsSql];
        if ([rs next]) {
            
            NSInteger count = [rs intForColumn:@"countNum"];
            NSLog(@"The table count: %li", (long)count);
            if (count == 1) {
                NSLog(@"log_keepers table is existed.");
                return;
            }
            
            NSString *table = [NSString stringWithFormat:@"CREATE TABLE  %@ (%@)",tableName,property];
            BOOL ok = [self.fmdb executeUpdate:table];
            if (ok) {
                NSLog(@"ok");
            }
        }
        [rs close];
    }
    [self.fmdb close];
}




///////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                        ////
//插入数据
- (void)TinsertDataToTable:(NSString *)tableName withArray:(NSArray <NSDictionary *>*)models
{
    if (models.count < 1 && tableName != nil) {
        return;
    }
    dispatch_async(_queue, ^{
        [self insertDataToTable:tableName withArray:models];
    });
    
}

//删除数据
- (void)TdeleteDataFromTable:(NSString *)tableName forKey:(NSString *)key withArray:(NSArray *)values
{
    if (values.count < 1) {
        return;
    }
    dispatch_async(_queue, ^{
        
        [self deleteDataFromTable:tableName forKey:key withArray:values];
    });
    
}

//删除所有数据
- (void)TdeleteAllDataFromTable:(NSString *)tableName
{
    [_dataOperationqueue inDatabase:^(FMDatabase *db) {
        NSString *sqlStr = [NSString stringWithFormat:@"delete from %@",tableName];
        
        BOOL result = [db executeUpdate:sqlStr];
        
        if (!result) {
            NSLog(@"清除表数据失败");
        }else
        {
            NSLog(@"清除表数据成功");
        }
    }];
}

//更新数据
- (void)TupdateDataFromTable:(NSString *)tableName forKey:(NSString *)key withArray:(NSArray <NSDictionary *>*)models
{
    if (models.count < 1) {
        return;
    }
    dispatch_async(_queue, ^{
        [self updateDataFromTable:tableName forKey:key withArray:models];
    });
    
}

// 异步获取查询数据
- (void )TselectDataFromTable:(NSString *)tableName withWhereSql:(NSString *)sql withBlock:(void(^)(NSArray *arr))block
{
    dispatch_async(_queue, ^{
        NSArray *resultArray = [self selectDataFromTable:tableName withWhereSql:sql];
        if (block) {
            block(resultArray);
        }
    });
}

//插入或者更新数据 (存在则更新)
- (void)TinsertOrUpdata:(NSString *)tableName withKey:(NSString *)key andArray:(NSArray <NSDictionary *>*)data
{
    dispatch_async(_queue, ^{
        NSMutableArray *insertData = [NSMutableArray new];
        NSMutableArray *updataData = [NSMutableArray new];
        for (NSDictionary *dic in data) {
            NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'",tableName,key,dic[key]];
            if ([self checkDataExist:sql]) {
                [updataData addObject:dic];
            }else
            {
                [insertData addObject:dic];
            }
        }
        [self updateDataFromTable:tableName forKey:key withArray:updataData];
        [self insertDataToTableWithTransaction:tableName withArray:insertData];
    });
}




//查询数据 条件语句自己加 "where 'userId' = '11'" 同步获取结果
- (NSArray *)TselectDataFromTable:(NSString *)tableName withWhereSql:(NSString *)sql
{
    return [self selectDataFromTable:tableName withWhereSql:sql];
}

/**************** 内部处理方法 ***************/
//插入数据
- (void)insertDataToTableWithTransaction:(NSString *)tableName withArray:(NSArray <NSDictionary *>*)models
{
    [_dataOperationqueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //        [_FMDBQueue inDatabase:^(FMDatabase *db) {
        BOOL isRollBack = NO;
        @try {
            for (NSDictionary *dic in models) {
                
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
                    if (i < valueArray.count-1)
                    {
                        [sqlStr appendFormat:@"'%@',",valueArray[i]];
                    }
                    else
                    {
                        [sqlStr appendFormat:@"'%@')",valueArray[i]];
                    }
                }
                
                BOOL result = [db executeUpdate:sqlStr];
                
                if (!result) {
                    NSLog(@"插入失败");
                }
            }
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [db rollback];
        }
        @finally {
            NSLog(@"数据插入操作结束");
        }
    }];
}
//删除数据
- (void)deleteDataFromTable:(NSString *)tableName forKey:(NSString *)key withArray:(NSArray *)values
{
    [_dataOperationqueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //        [_FMDBQueue inDatabase:^(FMDatabase *db) {
        BOOL isRollBack = NO;
        @try {
            for (id value in values)
            {
                NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'",tableName,key,value];
                
                BOOL result = [db executeUpdate:sqlStr];
                
                if (!result) {
                    NSLog(@"删除失败");
                }
            }
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [db rollback];
        }
        @finally {
            NSLog(@"数据删除操作结束");
        }
    }];
}
//更新数据
- (void)updateDataFromTable:(NSString *)tableName forKey:(NSString *)key withArray:(NSArray <NSDictionary *>*)models
{
    [_dataOperationqueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //        [_FMDBQueue inDatabase:^(FMDatabase *db) {
        BOOL isRollBack = NO;
        @try {
            for (NSDictionary *dic in models)
            {
                NSArray *keyArray = [dic allKeys];
                //update Person set NAME = ?, ICON = ? where IDNO = ?
                NSMutableString *sqlStr = [[NSMutableString alloc] initWithFormat:@"update %@ set",tableName];
                for (int i = 0; i < keyArray.count; i ++)
                {
                    if (i < keyArray.count-1)
                    {
                        NSString *k = keyArray[i];
                        [sqlStr appendFormat:@" %@ = '%@',",keyArray[i],dic[k]];
                    }
                    else
                    {
                        NSString *k = keyArray[i];
                        [sqlStr appendFormat:@" %@ = '%@' ",keyArray[i],dic[k]];
                    }
                }
                
                [sqlStr appendFormat:@"where %@ = '%@'",key,dic[key]];
                
                BOOL result = [db executeUpdate:sqlStr];
                
                
                if (!result) {
                    NSLog(@"更新失败");
                }
                
                
            }
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [db rollback];
        }
        @finally {
            NSLog(@"数据更新操作结束");
        }
    }];
}
//查询数据
- (NSArray *)selectDataFromTable:(NSString *)tableName withWhereSql:(NSString *)sql
{
    if (sql == nil || sql.length == 0) {
        sql = @"";
    }
    __block NSMutableArray *resultArray = [NSMutableArray array];
    [_dataOperationqueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //        [_FMDBQueue inDatabase:^(FMDatabase *db) {
        BOOL isRollBack = NO;
        @try {
            NSMutableString *sqlStr = [[NSMutableString alloc] initWithFormat:@"select * from %@ %@",tableName,sql];
            FMResultSet *result = [db executeQuery:sqlStr];
            
            while ([result next])
            {
                [resultArray addObject:[result resultDictionary]];
            }
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (dic in resultArray)
            {
                NSArray *keys = [dic allKeys];
                
                for (NSString *key in keys)
                {
                    id value = [dic objectForKey:key];
                    if ([value isEqualToString:@"<null>"]) {
                        [dic setValue:nil forKey:key];
                    }
                    if ([value isEqual:[NSNull null]])
                    {
                        [dic setValue:nil forKey:key];
                    }
                }
            }
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [db rollback];
        }
        @finally {
            NSLog(@"数据查询操作结束");
        }
    }];
    return resultArray;
}
//                                                                        ////
///////////////////////////////////////////////////////////////////////////////////////////////////////////
@end
