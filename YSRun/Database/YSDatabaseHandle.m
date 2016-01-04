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
#import "YSDatabaseTableKey.h"

#import "YSUserDatabaseModel.h"
#import "YSRunDatabaseModel.h"
#import "YSModelReformer.h"
#import "YSDatabaseUpdateManager.h"

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
        [YSDatabaseUpdateManager setDefaultVersion];
    }
    
    YSDatabaseUpdateManager *dbUpdateManager = [YSDatabaseUpdateManager new];
    [dbUpdateManager checkVersionWithDatabase:self.database];
    
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

#pragma mark - 数据库表单创建方法

- (void)createDatabaseTables
{
    [self createUserTable];
    [self createRunDataTable];
    [self createRunDataCellTable];
    [self createRunHeartRateDataTable];
    [self createRunLocationDataTable];
}

- (void)createUserTable
{
    NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE %@ ( \"uid\"  TEXT PRIMARY KEY,\"birthday\"  TEXT,\"sex\"  INTEGER,\"phone\"  TEXT,\"height\"  INTEGER,\"nickname\"  TEXT,\"lasttime\"  TEXT,\"headimg\"  TEXT,\"age\"  INTEGER )", DatabaseUserTable];
    BOOL res = [self.database executeUpdate:createSql];
    [self examCreateTableResult:res tableName:DatabaseUserTable];
}

- (void)createRunDataTable
{
    NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE %@ ( \"id\"  INTEGER PRIMARY KEY AUTOINCREMENT,\"uid\"  TEXT,\"pace\"  REAL,\"distance\"  REAL NOT NULL,\"speed\"  REAL,\"edate\"  INTEGER NOT NULL,\"star\"  INTEGER,\"l_speed\"  REAL,\"usetime\"  INTEGER NOT NULL,\"bdate\"  INTEGER NOT NULL,\"date\"  TEXT,\"cost\"  INTEGER,\"isUpdate\"  INTEGER,\"h_speed\"  REAL  , \"detail\" BLOB)", DatabaseRunDataTable];
    BOOL res = [self.database executeUpdate:createSql];
    [self examCreateTableResult:res tableName:DatabaseRunDataTable];
}

- (void)createRunDataCellTable
{
    NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE %@ ( \"id\"  INTEGER PRIMARY KEY AUTOINCREMENT,\"sportid\"  INTEGER NOT NULL,\"usetime\"  INTEGER,\"pace\"  REAL,\"speed\"  REAL,\"location_json\"  TEXT )", DatabaseRunDataCellTable];
    BOOL res = [self.database executeUpdate:createSql];
    [self examCreateTableResult:res tableName:DatabaseRunDataCellTable];
}

- (void)createRunHeartRateDataTable
{
    NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE %@ (\"id\" INTEGER PRIMARY KEY AUTOINCREMENT, \"runid\" INTEGER NOT NULL REFERENCES \"%@\" (\"id\") ON DELETE CASCADE ON UPDATE CASCADE, \"heartRateData\" TEXT)", DatabaseRunHeartRateDataTable, DatabaseRunDataTable];
    BOOL res = [self.database executeUpdate:createSql];
    [self examCreateTableResult:res tableName:DatabaseRunHeartRateDataTable];
}

- (void)createRunLocationDataTable
{
    NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE \"%@\" (\"id\" INTEGER PRIMARY KEY AUTOINCREMENT, \"runid\" INTEGER NOT NULL REFERENCES \"%@\" (\"id\") ON DELETE CASCADE ON UPDATE CASCADE, \"locationData\" TEXT)", DatabaseRunLocationDataTable, DatabaseRunDataTable];
    BOOL res = [self.database executeUpdate:createSql];
    [self examCreateTableResult:res tableName:DatabaseRunLocationDataTable];
}

- (void)examCreateTableResult:(BOOL)res tableName:(NSString *)name
{
    // 检验数据库的创建是否成功
    NSString *msg = [NSString stringWithFormat:@"创建%@%@.", name, (res ? @"成功" : @"失败")];
    YSLog(@"%@", msg);
}

#pragma mark - 数据库查询

- (YSUserDatabaseModel *)getUser
{
    YSUserDatabaseModel *model = nil;
    
    NSString *querySql = [NSString stringWithFormat:@"select * from %@", DatabaseUserTable];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    if ([queryRes next])
    {
        model = [YSUserDatabaseModel new];
        
        model.uid = [queryRes stringForColumn:UserTableUidKey];
        model.birthday = [queryRes stringForColumn:UserTableBirthdayKey];
        model.sex = [queryRes intForColumn:UserTableSexKey];
        model.phone = [queryRes stringForColumn:UserTablePhoneKey];
        model.height = [queryRes intForColumn:UserTableHeightKey];
        model.nickname = [queryRes stringForColumn:UserTableNicknameKey];
        model.lasttime = [queryRes stringForColumn:UserTableLastTimeKey];
        model.headimg = [queryRes stringForColumn:UserTableHeadImgKey];
        model.age = [queryRes intForColumn:UserTableAgeKey];
    }
    
    return model;
}

- (NSInteger)getLocalUserCount
{
    // 保存在本地数据库用户的数量。未登录时应为0，登录后为1
    NSString *querySql = [NSString stringWithFormat:@"select count (*) from %@", DatabaseUserTable];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    NSInteger count = 0;
    if ([queryRes next])
    {
        count = [queryRes intForColumnIndex:0];
    }
    
    return count;
}

- (CGFloat)getTotalDistance
{
    // 跑步的总距离，单位：米
    CGFloat totalDistance = 0.0;
    
    NSString *querySql = [NSString stringWithFormat:@"select sum(%@) from %@", RunDataTableDistanceKey, DatabaseRunDataTable];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    if ([queryRes next])
    {
        totalDistance = [queryRes intForColumnIndex:0];
    }
    
    return totalDistance;
}

- (NSInteger)getTotalUsetime
{
    // 跑步总时间，单位：秒
    NSInteger totalUsetime = 0.0;
    
    NSString *querySql = [NSString stringWithFormat:@"select sum(%@) from %@", RunDataTableUsetimeKey, DatabaseRunDataTable];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    if ([queryRes next])
    {
        totalUsetime = [queryRes intForColumnIndex:0];
    }
    
    return totalUsetime;
}

- (NSInteger)getTotalRunTimes
{
    // 跑步总次数
    NSInteger times = 0;
    
    NSString *querySql = [NSString stringWithFormat:@"select count(*) from %@", DatabaseRunDataTable];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    if ([queryRes next])
    {
        times = [queryRes intForColumnIndex:0];
    }
    
    return times;
}

- (BOOL)uidExsist:(NSString *)uid
{
    // uid是否已存在数据库中
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where uid = \"%@\"", DatabaseUserTable, uid];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    if ([queryRes next])
    {
        return YES;
    }
    
    return NO;
}

- (NSArray *)getRunDataWithUid:(NSString *)uid
{
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where uid = \"%@\"", DatabaseRunDataTable, uid];
    if (uid == nil)
    {
        querySql = [NSString stringWithFormat:@"select * from %@ where uid is NULL", DatabaseRunDataTable];
    }
    
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    NSMutableArray *runDataArray = [NSMutableArray array];
    while ([queryRes next])
    {
        YSRunDatabaseModel *runData = [YSRunDatabaseModel new];
        
        runData.rowid = [queryRes intForColumn:@"id"];
        runData.uid = [queryRes stringForColumn:RunDataTableUidKey];
        runData.pace = [queryRes doubleForColumn:RunDataTablePaceKey];
        runData.distance = [queryRes doubleForColumn:RunDataTableDistanceKey];
        runData.speed = [queryRes doubleForColumn:RunDataTableSpeedKey];
        runData.edate = [queryRes intForColumn:RunDataTableEdateKey];
        runData.star = [queryRes intForColumn:RunDataTableStarKey];
        runData.lSpeed = [queryRes doubleForColumn:RunDataTableLowestSpeedKey];
        runData.usetime = [queryRes intForColumn:RunDataTableUsetimeKey];
        runData.bdate = [queryRes intForColumn:RunDataTableBdateKey];
        runData.date = [queryRes stringForColumn:RunDataTableDateKey];
        runData.cost = [queryRes intForColumn:RunDataTableCostKey];
        runData.isUpdate = [queryRes intForColumn:RunDataTableIsUpdateKey];
        runData.hSpeed = [queryRes doubleForColumn:RunDataTableHighestSpeedKey];
        
        runData.heartRateDataString = [self getHeartRateDataWithRunid:runData.rowid];
        runData.locationDataString = [self getLocationDataWithRunid:runData.rowid];
        
        [runDataArray addObject:runData];
    }
    
    return runDataArray;
}

- (NSArray *)getRunDataWithUpdateState:(NSInteger)isUpdate
{
    // 根据更新状态获取跑步数据。
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where isUpdate = %@", DatabaseRunDataTable, @(isUpdate)];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    NSMutableArray *runDataArray = [NSMutableArray array];
    while ([queryRes next])
    {
        YSRunDatabaseModel *runData = [YSRunDatabaseModel new];
        
        runData.rowid = [queryRes intForColumn:@"id"];
        runData.uid = [queryRes stringForColumn:RunDataTableUidKey];
        runData.pace = [queryRes doubleForColumn:RunDataTablePaceKey];
        runData.distance = [queryRes doubleForColumn:RunDataTableDistanceKey];
        runData.speed = [queryRes doubleForColumn:RunDataTableSpeedKey];
        runData.edate = [queryRes intForColumn:RunDataTableEdateKey];
        runData.star = [queryRes intForColumn:RunDataTableStarKey];
        runData.lSpeed = [queryRes doubleForColumn:RunDataTableLowestSpeedKey];
        runData.usetime = [queryRes intForColumn:RunDataTableUsetimeKey];
        runData.bdate = [queryRes intForColumn:RunDataTableBdateKey];
        runData.date = [queryRes stringForColumn:RunDataTableDateKey];
        runData.cost = [queryRes intForColumn:RunDataTableCostKey];
        runData.isUpdate = [queryRes intForColumn:RunDataTableIsUpdateKey];
        runData.hSpeed = [queryRes doubleForColumn:RunDataTableHighestSpeedKey];
        
        runData.heartRateDataString = [self getHeartRateDataWithRunid:runData.rowid];
        runData.locationDataString = [self getLocationDataWithRunid:runData.rowid];
        
        [runDataArray addObject:runData];
    }
    
    return runDataArray;
}

- (NSInteger)lastInsertRowidInRunDataTable
{
    // 刚插入的数据所对应的id，数据库自动递增作为标记的主键
    NSInteger rowid = 0;
    NSString *querySql = [NSString stringWithFormat:@"select last_insert_rowid() from %@", DatabaseRunDataTable];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    if ([queryRes next])
    {
        rowid = [queryRes intForColumnIndex:0];
    }
    
    return rowid;
}

- (NSArray *)getRunInfoInDate:(NSDate *)date
{
    NSString *dateStr = [YSModelReformer stringFromDate:date];
    NSMutableArray *runDataArray = [NSMutableArray array];
    
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where date = \"%@\"", DatabaseRunDataTable, dateStr];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    while ([queryRes next])
    {
        YSRunDatabaseModel *runData = [YSRunDatabaseModel new];
        
        runData.rowid = [queryRes intForColumn:@"id"];
        runData.uid = [queryRes stringForColumn:RunDataTableUidKey];
        runData.pace = [queryRes doubleForColumn:RunDataTablePaceKey];
        runData.distance = [queryRes doubleForColumn:RunDataTableDistanceKey];
        runData.speed = [queryRes doubleForColumn:RunDataTableSpeedKey];
        runData.edate = [queryRes intForColumn:RunDataTableEdateKey];
        runData.star = [queryRes intForColumn:RunDataTableStarKey];
        runData.lSpeed = [queryRes doubleForColumn:RunDataTableLowestSpeedKey];
        runData.usetime = [queryRes intForColumn:RunDataTableUsetimeKey];
        runData.bdate = [queryRes intForColumn:RunDataTableBdateKey];
        runData.date = [queryRes stringForColumn:RunDataTableDateKey];
        runData.cost = [queryRes intForColumn:RunDataTableCostKey];
        runData.isUpdate = [queryRes intForColumn:RunDataTableIsUpdateKey];
        runData.hSpeed = [queryRes doubleForColumn:RunDataTableHighestSpeedKey];
        
        // 加上个处理。可能存在edate为0的可能 -_-|||
        if (runData.edate < 1)
        {
            runData.edate = runData.bdate + runData.usetime;
        }
        
        runData.heartRateDataString = [self getHeartRateDataWithRunid:runData.rowid];
        runData.locationDataString = [self getLocationDataWithRunid:runData.rowid];
        
        [runDataArray addObject:runData];
    }
    
    return runDataArray;
}

- (NSString *)getHeartRateDataWithRunid:(NSInteger)runid
{
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where runid = %@", DatabaseRunHeartRateDataTable, @(runid)];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    NSString *heartRateDataStr = nil;
    if ([queryRes next])
    {
        heartRateDataStr = [queryRes stringForColumn:RunHeartRateDataTableHeartRateKey];
    }
    
    return heartRateDataStr;
}

- (NSString *)getLocationDataWithRunid:(NSInteger)runid
{
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where runid = %@", DatabaseRunLocationDataTable, @(runid)];
    FMResultSet * queryRes = [self.database executeQuery:querySql];
    
    NSString *locationDataStr = nil;
    if ([queryRes next])
    {
        locationDataStr = [queryRes stringForColumn:RunLocationDataTableLocationKey];
    }
    
    return locationDataStr;
}

#pragma mark - 数据库修改

- (void)updateUser:(NSString *)uid withUserInfo:(YSUserDatabaseModel *)userInfo
{
    // 修改uid对应的用户信息
}

- (void)updateRunDataUid:(NSString *)uid withNewUid:(NSString *)newUid
{
    // 修改跑步数据的uid，改为新值newUid
    
    NSString *updateSql = [NSString stringWithFormat:@"update %@ set uid = \"%@\" where uid = \"%@\"", DatabaseRunDataTable, newUid, uid];
    if (uid == nil)
    {
        updateSql = [NSString stringWithFormat:@"update %@ set uid = \"%@\" where uid is NULL", DatabaseRunDataTable, newUid];
    }
    
    BOOL result = [self.database executeUpdate:updateSql];
    [self examUpdateResult:result tableName:DatabaseRunDataTable];
}

- (void)updateUser:(NSString *)uid withLastTime:(NSInteger)lastTime
{
    NSString *updateSql = [NSString stringWithFormat:@"update %@ set lasttime = %@ where uid = \"%@\"", DatabaseUserTable, @(lastTime), uid];
    
    BOOL result = [self.database executeUpdate:updateSql];
    [self examUpdateResult:result tableName:DatabaseUserTable];
}

- (void)updateUser:(NSString *)uid withHeadImagePath:(NSString *)headImagePath
{
    NSString *updateSql = [NSString stringWithFormat:@"update %@ set headimg = \"%@\" where uid = \"%@\"", DatabaseUserTable, headImagePath, uid];
    
    BOOL result = [self.database executeUpdate:updateSql];
    [self examUpdateResult:result tableName:DatabaseUserTable];
}

- (void)updateUser:(NSString *)uid withNickname:(NSString *)nickname
{
    NSString *updateSql = [NSString stringWithFormat:@"update %@ set nickname = \"%@\" where uid = \"%@\"", DatabaseUserTable, nickname, uid];
    
    BOOL result = [self.database executeUpdate:updateSql];
    [self examUpdateResult:result tableName:DatabaseUserTable];
}

- (void)setRunDataUpdateState:(BOOL)isUpdate byRowid:(NSInteger)rowid
{
    // 设置跑步数据是否上传到服务器标识
    NSInteger update = isUpdate ? 1 : 2;
    
    NSString *updateSql = [NSString stringWithFormat:@"update %@ set isUpdate = %@ where id = %@", DatabaseRunDataTable, @(update), @(rowid)];
    
    BOOL result = [self.database executeUpdate:updateSql];
    [self examUpdateResult:result tableName:DatabaseUserTable];
}

- (void)examUpdateResult:(BOOL)result tableName:(NSString *)name
{
    NSString *msg = [NSString stringWithFormat:@"%@更新数据%@.", name, (result ? @"成功" : @"失败")];
    YSLog(@"%@", msg);
}

#pragma mark - 数据库插入

- (NSInteger)insertRunData:(YSRunDatabaseModel *)runData
{
    // 跑步数据存储到本地数据库
    NSMutableArray *arguments = [NSMutableArray array];
    
    [arguments addObject:runData.uid];
    [arguments addObject:runData.date];
    
    [arguments addObject:[NSNumber numberWithInteger:runData.bdate]];
    [arguments addObject:[NSNumber numberWithInteger:runData.edate]];
    [arguments addObject:[NSNumber numberWithInteger:runData.usetime]];
    
    [arguments addObject:[NSNumber numberWithFloat:runData.lSpeed]];
    [arguments addObject:[NSNumber numberWithFloat:runData.hSpeed]];
    [arguments addObject:[NSNumber numberWithFloat:runData.speed]];
    [arguments addObject:[NSNumber numberWithFloat:runData.pace]];
    
    [arguments addObject:[NSNumber numberWithFloat:runData.distance]];
    [arguments addObject:[NSNumber numberWithInteger:runData.star]];
    [arguments addObject:[NSNumber numberWithInteger:runData.isUpdate]];
    [arguments addObject:[NSNumber numberWithInteger:runData.cost]];
    
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (uid, date, bdate, edate, usetime, l_speed, h_speed, speed, pace, distance, star, isUpdate, cost) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", DatabaseRunDataTable];
    BOOL result = [self.database executeUpdate:insertSql withArgumentsInArray:arguments];
    
    NSInteger insertRunid = -1;
    if (result)
    {
        // 这个函数两次调用返回的结果不一致，所以用第一次正确的值作为返回结果保存
        insertRunid = [self lastInsertRowidInRunDataTable];   // 刚插入的跑步数据对应的id
        [self insertHeartRateDataWithRunid:insertRunid dataString:runData.heartRateDataString];
        [self insertLocationDataWithRunid:insertRunid dataString:runData.locationDataString];
    }
    
    [self examInsertResult:result tableName:DatabaseRunDataTable];
    return insertRunid;
}

- (void)insertUser:(YSUserDatabaseModel *)userInfo
{
    // 用户数据存到本地
    NSMutableArray *arguments = [NSMutableArray array];
    
    [arguments addObject:userInfo.uid];
    [arguments addObject:userInfo.birthday];
    [arguments addObject:userInfo.phone];
    [arguments addObject:userInfo.nickname];
    [arguments addObject:userInfo.lasttime];
    [arguments addObject:userInfo.headimg];
    
    [arguments addObject:[NSNumber numberWithInteger:userInfo.age]];
    [arguments addObject:[NSNumber numberWithInteger:userInfo.sex]];
    [arguments addObject:[NSNumber numberWithInteger:userInfo.height]];
    
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (uid, birthday, phone, nickname, lasttime, headimg, age, sex, height) values (?, ?, ?, ?, ?, ?, ?, ?, ?)", DatabaseUserTable];
    BOOL result = [self.database executeUpdate:insertSql withArgumentsInArray:arguments];
    
    [self examInsertResult:result tableName:DatabaseUserTable];
}

- (void)insertHeartRateDataWithRunid:(NSInteger)runid dataString:(NSString *)dataString
{
    // 心率数据存储到本地
    if (![dataString isKindOfClass:[NSNull class]] && dataString && ([dataString length] > 0))
    {
        NSMutableArray *arguments = [NSMutableArray array];
        [arguments addObject:[NSNumber numberWithInteger:runid]];
        [arguments addObject:dataString];
        
        NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (runid, heartRateData) values (?, ?)", DatabaseRunHeartRateDataTable];
        BOOL result = [self.database executeUpdate:insertSql withArgumentsInArray:arguments];
        
        [self examInsertResult:result tableName:DatabaseRunHeartRateDataTable];
    }
}

- (void)insertLocationDataWithRunid:(NSInteger)runid dataString:(NSString *)dataString
{
    // 位置数据存储到本地
    if (![dataString isKindOfClass:[NSNull class]] && dataString && ([dataString length] > 0))
    {
        NSMutableArray *arguments = [NSMutableArray array];
        [arguments addObject:[NSNumber numberWithInteger:runid]];
        [arguments addObject:dataString];
        
        NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (runid, locationData) values (?, ?)", DatabaseRunLocationDataTable];
        BOOL result = [self.database executeUpdate:insertSql withArgumentsInArray:arguments];
        
        [self examInsertResult:result tableName:DatabaseRunLocationDataTable];
    }
}

- (void)examInsertResult:(BOOL)result tableName:(NSString *)name
{
    NSString *msg = [NSString stringWithFormat:@"%@插入数据%@.", name, (result ? @"成功" : @"失败")];
    YSLog(@"%@", msg);
}

#pragma mark - 数据库删除

- (void)deleteUser:(NSString *)uid
{
    // 删除用户
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where uid = \"%@\"",DatabaseUserTable, uid];
    if (uid == nil)
    {
        deleteSql = [NSString stringWithFormat:@"delete from %@ where uid is NULL",DatabaseUserTable];
    }
    
    BOOL result = [self.database executeUpdate:deleteSql];
    [self examDeleteResult:result tableName:DatabaseUserTable];
}

- (void)deleteRunDataWithUid:(NSString *)uid
{
    // 删除跑步数据
    
    // 删除跑步数据前先通过跑步id删除对应的心率数据和位置数据
    [self deleteHeartRateDataAndLocationDataWithUid:uid];
    
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where uid = \"%@\"",DatabaseRunDataTable, uid];
    if (uid == nil)
    {
        deleteSql = [NSString stringWithFormat:@"delete from %@ where uid is NULL",DatabaseRunDataTable];
    }
    
    BOOL result = [self.database executeUpdate:deleteSql];
    [self examDeleteResult:result tableName:DatabaseRunDataTable];
}

- (void)deleteHeartRateDataAndLocationDataWithUid:(NSString *)uid
{
    // 删除对应uid跑步数据的心率数据和位置数据
    NSArray *runDataArray = [self getRunDataWithUid:uid];
    for (NSInteger i = 0; i < [runDataArray count]; i++)
    {
        YSRunDatabaseModel *runData = runDataArray[i];
        NSInteger runid = runData.rowid;
        
        [self deleteHeartRateDataWithRunid:runid];
        [self deleteLocationDataWithRunid:runid];
    }
}

- (void)deleteHeartRateDataWithRunid:(NSInteger)runid
{
    // 删除心率数据
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where runid = %@",DatabaseRunHeartRateDataTable, @(runid)];
    
    BOOL result = [self.database executeUpdate:deleteSql];
    [self examDeleteResult:result tableName:DatabaseRunHeartRateDataTable];
}

- (void)deleteLocationDataWithRunid:(NSInteger)runid
{
    // 删除位置数据
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where runid = %@",DatabaseRunLocationDataTable, @(runid)];
    
    BOOL result = [self.database executeUpdate:deleteSql];
    [self examDeleteResult:result tableName:DatabaseRunLocationDataTable];
}

- (void)examDeleteResult:(BOOL)result tableName:(NSString *)name
{
    NSString *msg = [NSString stringWithFormat:@"%@删除数据%@.", name, (result ? @"成功" : @"失败")];
    YSLog(@"%@", msg);
}

@end
