//
//  YSDatabaseQueue.m
//  YSRun
//
//  Created by moshuqi on 15/12/29.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSDatabaseQueue.h"
#import "YSDatabaseTableKey.h"
#import "FMDB.h"
#import "YSDatabaseTableCreator.h"
#import "YSUserDatabaseModel.h"
#import "YSRunDatabaseModel.h"
#import "YSUtilsMacro.h"
#import "YSModelReformer.h"

@interface YSDatabaseQueue ()

@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

@implementation YSDatabaseQueue

static YSDatabaseQueue *_instance;

+ (id)allocWithZone:(struct _NSZone *)zone
{
    //调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)shareDatabaseQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YSDatabaseQueue alloc] init];
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
    NSString *path = [self getDatabasePath];
    self.queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    YSDatabaseTableCreator *dbCreator = [[YSDatabaseTableCreator alloc] initWithQueue:self.queue];
    
    [dbCreator checkTables];
}

- (NSString *)getDatabasePath
{
    // 获得数据库文件路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@",DatabaseName]];
    
    return dbPath;
}

#pragma mark - 数据库查询

- (YSUserDatabaseModel *)getUser
{
    __block YSUserDatabaseModel *model = nil;
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL * rollback) {
        NSString *querySql = [NSString stringWithFormat:@"select * from %@", DatabaseUserTable];
        FMResultSet * queryRes = [db executeQuery:querySql];
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
        
        [queryRes close];
    }];
    
    return model;
}

- (NSInteger)getLocalUserCount
{
    // 保存在本地数据库用户的数量。未登录时应为0，登录后为1
    __block NSInteger count = 0;
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL * rollback) {
        NSString *querySql = [NSString stringWithFormat:@"select count (*) from %@", DatabaseUserTable];
        
        FMResultSet * queryRes = [db executeQuery:querySql];
        if ([queryRes next])
        {
            count = [queryRes intForColumnIndex:0];
        }
        
        [queryRes close];
    }];
    
    return count;
}

- (CGFloat)getTotalDistance
{
    // 跑步的总距离，单位：米
    __block CGFloat totalDistance = 0.0;
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL * rollback) {
        NSString *querySql = [NSString stringWithFormat:@"select sum(%@) from %@", RunDataTableDistanceKey, DatabaseRunDataTable];
        
        FMResultSet * queryRes = [db executeQuery:querySql];
        if ([queryRes next])
        {
            totalDistance = [queryRes intForColumnIndex:0];
        }
        
        [queryRes close];
    }];
    
    return totalDistance;
}

- (NSInteger)getTotalUsetime
{
    // 跑步总时间，单位：秒
    __block NSInteger totalUsetime = 0.0;
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL * rollback) {
        NSString *querySql = [NSString stringWithFormat:@"select sum(%@) from %@", RunDataTableUsetimeKey, DatabaseRunDataTable];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        if ([queryRes next])
        {
            totalUsetime = [queryRes intForColumnIndex:0];
        }
        
        [queryRes close];
    }];
    
    return totalUsetime;
}

- (NSInteger)getTotalRunTimes
{
    // 跑步总次数
    __block NSInteger times = 0;
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL * rollback) {
        NSString *querySql = [NSString stringWithFormat:@"select count(*) from %@", DatabaseRunDataTable];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        if ([queryRes next])
        {
            times = [queryRes intForColumnIndex:0];
        }
        
        [queryRes close];
    }];
    
    return times;
}

- (BOOL)uidExsit:(NSString *)uid
{
    // uid是否已存在数据库中
    __block BOOL isExsit = NO;
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL * rollback) {
        NSString *querySql = [NSString stringWithFormat:@"select * from %@ where uid = \"%@\"", DatabaseUserTable, uid];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        if ([queryRes next])
        {
            isExsit = YES;
        }
        
        [queryRes close];
    }];
    
    return isExsit;
}

- (NSArray *)getRunInfoInDate:(NSDate *)date
{
    __block NSMutableArray *runDataArray = [NSMutableArray array];
    [self.queue inTransaction:^(FMDatabase *db, BOOL * rollback) {
        NSString *dateStr = [YSModelReformer stringFromDate:date];
        
        NSString *querySql = [NSString stringWithFormat:@"select * from %@ where date = \"%@\"", DatabaseRunDataTable, dateStr];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
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
            
            runData.heartRateDataString = [self getHeartRateDataWithRunid:runData.rowid inDatabase:db];
            runData.locationDataString = [self getLocationDataWithRunid:runData.rowid inDatabase:db];
            
            [runDataArray addObject:runData];
        }
        
        [queryRes close];
    }];
    
    return runDataArray;
}

- (NSArray *)getRunDataWithUpdateState:(NSInteger)isUpdate
{
    // 根据更新状态获取跑步数据。
    __block NSMutableArray *runDataArray = [NSMutableArray array];
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL * rollback) {
        NSString *querySql = [NSString stringWithFormat:@"select * from %@ where isUpdate = %@", DatabaseRunDataTable, @(isUpdate)];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
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
            
            runData.heartRateDataString = [self getHeartRateDataWithRunid:runData.rowid inDatabase:db];
            runData.locationDataString = [self getLocationDataWithRunid:runData.rowid inDatabase:db];
            
            [runDataArray addObject:runData];
        }
        
        [queryRes close];
    }];
    
    return runDataArray;
}


- (NSInteger)lastInsertRowidInRunDataTable
{
    // 刚插入的数据所对应的id，数据库自动递增作为标记的主键
    __block NSInteger rowid = 0;
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL * rollback) {
        NSString *querySql = [NSString stringWithFormat:@"select last_insert_rowid() from %@", DatabaseRunDataTable];
        FMResultSet * queryRes = [db executeQuery:querySql];
        
        if ([queryRes next])
        {
            rowid = [queryRes intForColumnIndex:0];
        }
        
        [queryRes close];
    }];
    
    return rowid;
}

- (NSArray *)getRunDataWithUid:(NSString *)uid
{
    // 根据uid获取跑步数据
    __block NSMutableArray *runDataArray = [NSMutableArray array];
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL * rollback) {
        runDataArray = [self getRunDataWithUid:uid inDatabase:db];
    }];
    
    return runDataArray;
}

- (NSMutableArray *)getRunDataWithUid:(NSString *)uid inDatabase:(FMDatabase *)db
{
    NSMutableArray *runDataArray = [NSMutableArray array];
    
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where uid = \"%@\"", DatabaseRunDataTable, uid];
    if (uid == nil)
    {
        querySql = [NSString stringWithFormat:@"select * from %@ where uid is NULL", DatabaseRunDataTable];
    }
    
    FMResultSet * queryRes = [db executeQuery:querySql];
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
        
        runData.heartRateDataString = [self getHeartRateDataWithRunid:runData.rowid inDatabase:db];
        runData.locationDataString = [self getLocationDataWithRunid:runData.rowid inDatabase:db];
        
        [runDataArray addObject:runData];
    }
    
    [queryRes close];
    
    return runDataArray;
}

- (NSString *)getHeartRateDataWithRunid:(NSInteger)runid inDatabase:(FMDatabase *)db
{
    // 获取对应的心率数据，心率数据在数据库中存储为一定格式的string
    NSString *heartRateDataStr = nil;
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where runid = %@", DatabaseRunHeartRateDataTable, @(runid)];
    
    FMResultSet * queryRes = [db executeQuery:querySql];
    if ([queryRes next])
    {
        heartRateDataStr = [queryRes stringForColumn:RunHeartRateDataTableHeartRateKey];
    }
    
    [queryRes close];
    
    return heartRateDataStr;
}

- (NSString *)getLocationDataWithRunid:(NSInteger)runid  inDatabase:(FMDatabase *)db
{
    // 获取对应的位置数据，位置数据在数据库中存储为一定格式的string
    NSString *locationDataStr = nil;
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where runid = %@", DatabaseRunLocationDataTable, @(runid)];
    
    FMResultSet * queryRes = [db executeQuery:querySql];
    
    if ([queryRes next])
    {
        locationDataStr = [queryRes stringForColumn:RunLocationDataTableLocationKey];
    }
    
    [queryRes close];
    
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
    [self.queue inTransaction:^(FMDatabase *db, BOOL * rollback) {
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set uid = \"%@\" where uid = \"%@\"", DatabaseRunDataTable, newUid, uid];
        if (uid == nil)
        {
            updateSql = [NSString stringWithFormat:@"update %@ set uid = \"%@\" where uid is NULL", DatabaseRunDataTable, newUid];
        }
        
        BOOL result = [db executeUpdate:updateSql];
        [self examUpdateResult:result tableName:DatabaseRunDataTable];
    }];
}

- (void)updateUser:(NSString *)uid withLastTime:(NSInteger)lastTime
{
    [self.queue inTransaction:^(FMDatabase *db, BOOL * rollback) {
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set lasttime = %@ where uid = \"%@\"", DatabaseUserTable, @(lastTime), uid];
        
        BOOL result = [db executeUpdate:updateSql];
        [self examUpdateResult:result tableName:DatabaseUserTable];
    }];
}

- (void)updateUser:(NSString *)uid withHeadImagePath:(NSString *)headImagePath
{
    [self.queue inTransaction:^(FMDatabase *db, BOOL * rollback) {
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set headimg = \"%@\" where uid = \"%@\"", DatabaseUserTable, headImagePath, uid];
        
        BOOL result = [db executeUpdate:updateSql];
        [self examUpdateResult:result tableName:DatabaseUserTable];
    }];
}

- (void)updateUser:(NSString *)uid withNickname:(NSString *)nickname
{
    [self.queue inTransaction:^(FMDatabase *db, BOOL * rollback) {
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set nickname = \"%@\" where uid = \"%@\"", DatabaseUserTable, nickname, uid];
        
        BOOL result = [db executeUpdate:updateSql];
        [self examUpdateResult:result tableName:DatabaseUserTable];
    }];
}

- (void)setRunDataUpdateState:(BOOL)isUpdate byRowid:(NSInteger)rowid
{
    // 设置跑步数据是否上传到服务器标识
    [self.queue inTransaction:^(FMDatabase *db, BOOL * rollback) {
        NSInteger update = isUpdate ? 1 : 2;
        
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set isUpdate = %@ where id = %@", DatabaseRunDataTable, @(update), @(rowid)];
        
        BOOL result = [db executeUpdate:updateSql];
        [self examUpdateResult:result tableName:DatabaseUserTable];
    }];
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
    __block NSInteger insertRunid = -1;
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL * rollback) {
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
        BOOL result = [db executeUpdate:insertSql withArgumentsInArray:arguments];
        
        if (result)
        {
            // 不能在inDatabase:里再次调用inDatabase:，会导致崩溃。
            
            // 刚插入的跑步数据对应的id
            // 这个查询两次调用返回的结果不一致，所以用第一次正确的值作为返回结果保存
            NSString *querySql = [NSString stringWithFormat:@"select last_insert_rowid() from %@", DatabaseRunDataTable];
            
            FMResultSet * queryRes = [db executeQuery:querySql];
            if ([queryRes next])
            {
                // 获取插入跑步数据之后对应的跑步runid
                insertRunid = [queryRes intForColumnIndex:0];
                
                // 保存心率数据
                NSString *heartDataStr = runData.heartRateDataString;
                if (![heartDataStr isKindOfClass:[NSNull class]] && heartDataStr && ([heartDataStr length] > 0))
                {
                    NSMutableArray *arguments = [NSMutableArray array];
                    [arguments addObject:[NSNumber numberWithInteger:insertRunid]];
                    [arguments addObject:heartDataStr];
                    
                    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (runid, heartRateData) values (?, ?)", DatabaseRunHeartRateDataTable];
                    BOOL result = [db executeUpdate:insertSql withArgumentsInArray:arguments];
                    
                    [self examInsertResult:result tableName:DatabaseRunHeartRateDataTable];
                }
                
                // 保存位置数据
                NSString *locationDataStr = runData.locationDataString;
                if (![locationDataStr isKindOfClass:[NSNull class]] && locationDataStr && ([locationDataStr length] > 0))
                {
                    NSMutableArray *arguments = [NSMutableArray array];
                    [arguments addObject:[NSNumber numberWithInteger:insertRunid]];
                    [arguments addObject:locationDataStr];
                    
                    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (runid, locationData) values (?, ?)", DatabaseRunLocationDataTable];
                    BOOL result = [db executeUpdate:insertSql withArgumentsInArray:arguments];
                    
                    [self examInsertResult:result tableName:DatabaseRunLocationDataTable];
                }
                
            }
            [queryRes close];
            
        }
        
        [self examInsertResult:result tableName:DatabaseRunDataTable];
    }];
    
    return insertRunid;
}

- (void)insertUser:(YSUserDatabaseModel *)userInfo
{
    // 用户数据存到本地
    [self.queue inTransaction:^(FMDatabase *db, BOOL * rollback) {
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
        BOOL result = [db executeUpdate:insertSql withArgumentsInArray:arguments];
        
        [self examInsertResult:result tableName:DatabaseUserTable];
    }];
}

- (void)insertHeartRateDataWithRunid:(NSInteger)runid dataString:(NSString *)dataString
{
    // 心率数据存储到本地
    [self.queue inTransaction:^(FMDatabase *db, BOOL * rollback) {
        if (![dataString isKindOfClass:[NSNull class]] && dataString && ([dataString length] > 0))
        {
            NSMutableArray *arguments = [NSMutableArray array];
            [arguments addObject:[NSNumber numberWithInteger:runid]];
            [arguments addObject:dataString];
            
            NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (runid, heartRateData) values (?, ?)", DatabaseRunHeartRateDataTable];
            BOOL result = [db executeUpdate:insertSql withArgumentsInArray:arguments];
            
            [self examInsertResult:result tableName:DatabaseRunHeartRateDataTable];
        }
    }];
}

- (void)insertLocationDataWithRunid:(NSInteger)runid dataString:(NSString *)dataString
{
    // 位置数据存储到本地
    [self.queue inTransaction:^(FMDatabase *db, BOOL * rollback) {
        if (![dataString isKindOfClass:[NSNull class]] && dataString && ([dataString length] > 0))
        {
            NSMutableArray *arguments = [NSMutableArray array];
            [arguments addObject:[NSNumber numberWithInteger:runid]];
            [arguments addObject:dataString];
            
            NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (runid, locationData) values (?, ?)", DatabaseRunLocationDataTable];
            BOOL result = [db executeUpdate:insertSql withArgumentsInArray:arguments];
            
            [self examInsertResult:result tableName:DatabaseRunLocationDataTable];
        }
    }];
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
    [self.queue inTransaction:^(FMDatabase *db, BOOL * rollback) {
        NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where uid = \"%@\"",DatabaseUserTable, uid];
        if (uid == nil)
        {
            deleteSql = [NSString stringWithFormat:@"delete from %@ where uid is NULL",DatabaseUserTable];
        }
        
        BOOL result = [db executeUpdate:deleteSql];
        [self examDeleteResult:result tableName:DatabaseUserTable];
    }];
}

- (void)deleteRunDataWithUid:(NSString *)uid
{
    // 删除跑步数据
    [self.queue inTransaction:^(FMDatabase *db, BOOL * rollback) {
        // 删除跑步数据前先通过跑步id删除对应的心率数据和位置数据
        [self deleteHeartRateDataAndLocationDataWithUid:uid inDatabase:db];
        
        NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where uid = \"%@\"",DatabaseRunDataTable, uid];
        if (uid == nil)
        {
            deleteSql = [NSString stringWithFormat:@"delete from %@ where uid is NULL",DatabaseRunDataTable];
        }
        
        BOOL result = [db executeUpdate:deleteSql];
        [self examDeleteResult:result tableName:DatabaseRunDataTable];
    }];
}

- (void)deleteHeartRateDataAndLocationDataWithUid:(NSString *)uid inDatabase:(FMDatabase *)db
{
    // 删除对应uid跑步数据的心率数据和位置数据
    NSArray *runDataArray = [self getRunDataWithUid:uid inDatabase:db];
    for (NSInteger i = 0; i < [runDataArray count]; i++)
    {
        YSRunDatabaseModel *runData = runDataArray[i];
        NSInteger runid = runData.rowid;
        
        [self deleteHeartRateDataWithRunid:runid inDatabase:db];
        [self deleteLocationDataWithRunid:runid inDatabase:db];
    }
}

- (void)deleteHeartRateDataWithRunid:(NSInteger)runid inDatabase:(FMDatabase *)db
{
    // 删除心率数据
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where runid = %@",DatabaseRunHeartRateDataTable, @(runid)];
    
    BOOL result = [db executeUpdate:deleteSql];
    [self examDeleteResult:result tableName:DatabaseRunHeartRateDataTable];
}

- (void)deleteLocationDataWithRunid:(NSInteger)runid  inDatabase:(FMDatabase *)db
{
    // 删除位置数据
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where runid = %@",DatabaseRunLocationDataTable, @(runid)];
    
    BOOL result = [db executeUpdate:deleteSql];
    [self examDeleteResult:result tableName:DatabaseRunLocationDataTable];
}

- (void)examDeleteResult:(BOOL)result tableName:(NSString *)name
{
    NSString *msg = [NSString stringWithFormat:@"%@删除数据%@.", name, (result ? @"成功" : @"失败")];
    YSLog(@"%@", msg);
}


@end
