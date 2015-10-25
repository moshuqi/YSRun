//
//  YSDatabaseHandle.m
//  YSRun
//
//  Created by moshuqi on 15/10/23.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSDatabaseHandle.h"
#import "FMDB.h"
#import "YSUtilsMacro.h"

#define DatabaseName @"Yspaobu_Database.sqlite"

#define DatabaseUserTable @"Yspaobu_UserTable"
#define DatabaseRunDataTable @"Yspaobu_RunDataTable"
#define DatabaseRunDataCellTable @"Yspaobu_RunDataCellTable"

@interface YSDatabaseHandle ()

@property (nonatomic, retain) FMDatabase * database;

@end

@implementation YSDatabaseHandle

static YSDatabaseHandle *_instance;

+ (id)allocWithZone:(struct _NSZone *)zone
{
    //调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)shareDatabaseHandle
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YSDatabaseHandle alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self connect];
    }
    
    return self;
}

- (void)connect
{
    // 必须在open前判断，open会在不存在时新建一个sqlite文件
    BOOL needCreateTables = [self needCreateDatabase];
    
    NSString *path = [self getDatabasePath];
    self.database = [[FMDatabase alloc] initWithPath:path];
    BOOL success = [self.database open];
    
    if (needCreateTables)
    {
        [self createDatabaseTables];
    }
    
    NSString *openMsg = [NSString stringWithFormat:@"数据库打开%@.", (success ? @"成功" : @"失败")];
    YSLog(@"%@", openMsg);
}

- (BOOL)needCreateDatabase
{
    // 判断是否需要重头创建一个数据库。
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:[self getDatabasePath]];
    
    return !exist;
}

- (NSString *)getDatabasePath
{
    // 获得数据库文件路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@",DatabaseName]];
    
    return dbPath;
}

- (void)createDatabaseTables
{
    [self createUserTable];
    [self createRunDataTable];
    [self createRunDataCellTable];
}

- (void)createUserTable
{
    NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE %@ ( \"uid\"  TEXT PRIMARY KEY,\"birthday\"  TEXT,\"sex\"  INTEGER,\"phone\"  TEXT,\"height\"  INTEGER,\"nickname\"  TEXT,\"lasttime\"  TEXT,\"headimg\"  TEXT,\"age\"  INTEGER )", DatabaseUserTable];
    BOOL res = [self.database executeUpdate:createSql];
    [self examTableCreateWithResult:res tableName:DatabaseUserTable];
}

- (void)createRunDataTable
{
    NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE %@ ( \"id\"  INTEGER PRIMARY KEY AUTOINCREMENT,\"uid\"  TEXT,\"pace\"  REAL,\"distance\"  REAL NOT NULL,\"speed\"  REAL,\"edate\"  INTEGER NOT NULL,\"star\"  INTEGER,\"l_speed\"  REAL,\"usetime\"  INTEGER NOT NULL,\"bdate\"  INTEGER NOT NULL,\"date\"  TEXT,\"cost\"  INTEGER,\"isUpdate\"  INTEGER,\"h_speed\"  REAL )", DatabaseRunDataTable];
    BOOL res = [self.database executeUpdate:createSql];
    [self examTableCreateWithResult:res tableName:DatabaseUserTable];
}

- (void)createRunDataCellTable
{
    NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE %@ ( \"id\"  INTEGER PRIMARY KEY AUTOINCREMENT,\"sportid\"  INTEGER NOT NULL,\"usetime\"  INTEGER,\"pace\"  REAL,\"speed\"  REAL,\"location_json\"  TEXT )", DatabaseRunDataCellTable];
    BOOL res = [self.database executeUpdate:createSql];
    [self examTableCreateWithResult:res tableName:DatabaseRunDataCellTable];
}

- (void)examTableCreateWithResult:(BOOL)res tableName:(NSString *)name
{
    // 检验数据库的创建是否成功
    NSString *msg = [NSString stringWithFormat:@"创建%@%@.", name, (res ? @"成功" : @"失败")];
    YSLog(@"%@", msg);
}

@end
