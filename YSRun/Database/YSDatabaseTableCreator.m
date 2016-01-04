//
//  YSDatabaseTableCreator.m
//  YSRun
//
//  Created by moshuqi on 15/12/29.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSDatabaseTableCreator.h"
#import "FMDB.h"
#import "YSDatabaseTableKey.h"
#import "YSUtilsMacro.h"

@interface YSDatabaseTableCreator ()

@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

@implementation YSDatabaseTableCreator

- (id)initWithQueue:(FMDatabaseQueue *)queue
{
    self = [super init];
    if (self)
    {
        self.queue = queue;
    }
    
    return self;
}

- (void)checkTables
{
    [self checkTableWithName:DatabaseUserTable];
    [self checkTableWithName:DatabaseRunDataTable];
    [self checkTableWithName:DatabaseRunDataCellTable];
    
    // 记录心率数据和位置数据的表，需要跑步数据表作为外键，注意创建顺序
    [self checkTableWithName:DatabaseRunHeartRateDataTable];
    [self checkTableWithName:DatabaseRunLocationDataTable];
    
//    // 通过事务的方式来创建数据库
//    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        // 标记创建数据库是否失败，失败则进行回滚
//        BOOL createFalse = NO;
//        
//        [self checkTableWithName:DatabaseUserTable inDatabase:db createFalse:&createFalse];
//        [self checkTableWithName:DatabaseRunDataTable inDatabase:db createFalse:&createFalse];
//        [self checkTableWithName:DatabaseRunDataCellTable inDatabase:db createFalse:&createFalse];
//        
//        // 记录心率数据和位置数据的表，需要跑步数据表作为外键，注意创建顺序
//        [self checkTableWithName:DatabaseRunHeartRateDataTable inDatabase:db createFalse:&createFalse];
//        [self checkTableWithName:DatabaseRunLocationDataTable inDatabase:db createFalse:&createFalse];
//        
//        if (createFalse)
//        {
//            *rollback = YES;
//            return;
//        }
//    }];
}

#pragma mark - 检查数据库表是否存在

- (void)checkTableWithName:(NSString *)tableName
{
    // 检验是否存在table，若不存在则创建
    
    [self.queue inDatabase:^(FMDatabase *db) {
        BOOL isExist = [self checkTableName:tableName inDatabase:db];
        if (!isExist)
        {
            NSString *createSql = [self createSqlWithTableName:tableName];
            if (createSql)
            {
                BOOL res = [db executeUpdate:createSql];
                [self examCreateTableResult:res tableName:tableName];
            }
        }
    }];
}

- (void)checkTableWithName:(NSString *)tableName inDatabase:(FMDatabase *)db createFalse:(BOOL *)createFalse
{
    // 通过事务来创建表时调用这个方法
    BOOL isExist = [self checkTableName:tableName inDatabase:db];
    if (!isExist)
    {
        NSString *createSql = [self createSqlWithTableName:tableName];
        if (createSql)
        {
            BOOL res = [db executeUpdate:createSql];
            [self examCreateTableResult:res tableName:tableName];
            
            // 创建数据库失败
            if (!res)
            {
                *createFalse = YES;
            }
        }
    }
}

- (BOOL)checkTableName:(NSString *)tableName inDatabase:(FMDatabase *)db
{
    // 检查数据库中是否存在名为tableName的表，存在则返回YES
    NSString *querySql = [self querySqlWithTableName:tableName];
    FMResultSet *queryRes = [db executeQuery:querySql];
    
    NSInteger count = 0;
    if ([queryRes next])
    {
        count = [queryRes intForColumnIndex:0];
    }
    
    [queryRes close];
    
    return (count > 0);
}

- (NSString *)querySqlWithTableName:(NSString *)tableName
{
    // 检查table是否存在的sql语句
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM sqlite_master where type=\"table\" and name=\"%@\"", tableName];
    return sql;
}

- (void)examCreateTableResult:(BOOL)res tableName:(NSString *)name
{
    // 检验数据库的创建是否成功
    NSString *msg = [NSString stringWithFormat:@"创建%@%@.", name, (res ? @"成功" : @"失败")];
    YSLog(@"%@", msg);
}

#pragma mark - 创建表单sql语句

- (NSString *)createSqlWithTableName:(NSString *)tableName
{
    NSString *createSql = nil;
    if ([tableName compare:DatabaseUserTable] == NSOrderedSame)
    {
        createSql = [self createUserTableSql];
    }
    else if ([tableName compare:DatabaseRunDataTable] == NSOrderedSame)
    {
        createSql = [self createRunDataTableSql];
    }
    else if ([tableName compare:DatabaseRunDataCellTable] == NSOrderedSame)
    {
        createSql = [self createRunDataCellTableSql];
    }
    else if ([tableName compare:DatabaseRunHeartRateDataTable] == NSOrderedSame)
    {
        createSql = [self createRunHeartRateDataTableSql];
    }
    else if ([tableName compare:DatabaseRunLocationDataTable] == NSOrderedSame)
    {
        createSql = [self createRunLocationDataTableSql];
    }
    
    if (!createSql)
    {
        YSLog(@"sql语句为空!");
    }
    
    return createSql;
}

- (NSString *)createUserTableSql
{
    NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE %@ ( \"uid\"  TEXT PRIMARY KEY,\"birthday\"  TEXT,\"sex\"  INTEGER,\"phone\"  TEXT,\"height\"  INTEGER,\"nickname\"  TEXT,\"lasttime\"  TEXT,\"headimg\"  TEXT,\"age\"  INTEGER )", DatabaseUserTable];
    return createSql;
}

- (NSString *)createRunDataTableSql
{
    NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE %@ ( \"id\"  INTEGER PRIMARY KEY AUTOINCREMENT,\"uid\"  TEXT,\"pace\"  REAL,\"distance\"  REAL NOT NULL,\"speed\"  REAL,\"edate\"  INTEGER NOT NULL,\"star\"  INTEGER,\"l_speed\"  REAL,\"usetime\"  INTEGER NOT NULL,\"bdate\"  INTEGER NOT NULL,\"date\"  TEXT,\"cost\"  INTEGER,\"isUpdate\"  INTEGER,\"h_speed\"  REAL  , \"detail\" BLOB)", DatabaseRunDataTable];
    return createSql;
}

- (NSString *)createRunDataCellTableSql
{
   NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE %@ ( \"id\"  INTEGER PRIMARY KEY AUTOINCREMENT,\"sportid\"  INTEGER NOT NULL,\"usetime\"  INTEGER,\"pace\"  REAL,\"speed\"  REAL,\"location_json\"  TEXT )", DatabaseRunDataCellTable];
    return createSql;
}

- (NSString *)createRunHeartRateDataTableSql
{
    NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE %@ (\"id\" INTEGER PRIMARY KEY AUTOINCREMENT, \"runid\" INTEGER NOT NULL REFERENCES \"%@\" (\"id\") ON DELETE CASCADE ON UPDATE CASCADE, \"heartRateData\" TEXT)", DatabaseRunHeartRateDataTable, DatabaseRunDataTable];
    return createSql;
}

- (NSString *)createRunLocationDataTableSql
{
    NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE \"%@\" (\"id\" INTEGER PRIMARY KEY AUTOINCREMENT, \"runid\" INTEGER NOT NULL REFERENCES \"%@\" (\"id\") ON DELETE CASCADE ON UPDATE CASCADE, \"locationData\" TEXT)", DatabaseRunLocationDataTable, DatabaseRunDataTable];
    return createSql;
}

@end
