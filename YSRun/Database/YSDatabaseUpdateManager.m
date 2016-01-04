//
//  YSDatabaseUpdateManager.m
//  YSRun
//
//  Created by moshuqi on 15/12/28.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSDatabaseUpdateManager.h"
#import <UIKit/UIKit.h>
#import "YSAppSettingsDefine.h"
#import "YSUtilsMacro.h"
#import "YSDatabaseTableKey.h"
#import "FMDB.h"

@interface YSDatabaseUpdateManager ()

@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, assign) BOOL upgradeResult;   // 用来标记依次升级执行的结果，若其中有升级失败，则还未执行的升级取消。

@end

@implementation YSDatabaseUpdateManager

+ (void)setDefaultVersion
{
    // 第一次创建数据库时，设为初始的版本值1
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInteger:1] forKey:YSDatabaseVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setDatabaseVersion:(NSInteger)version
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInteger:version] forKey:YSDatabaseVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)getDatabaseVersion
{
    NSNumber *value = [[NSUserDefaults standardUserDefaults] valueForKey:YSDatabaseVersionKey];
    if (!value)
    {
        YSLog(@"数据库版本号为空");
        return -1;
    }
    
    NSInteger version = [value integerValue];
    return version;
}

- (NSInteger)appCorrespondingDatabaseVersion
{
    // 当前代码版本对应的数据库版本，版本号为整数，从1开始，依次+1，将来数据库变更直接在此处进行数据库版本号的更改，并添加对应的数据库更新方法
    return 1;
}

- (BOOL)hasSetVersion
{
    // 是否在NSUserDefaults中设置过数据库版本号
    NSValue *value = [[NSUserDefaults standardUserDefaults] valueForKey:YSDatabaseVersionKey];
    if (value)
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)needUpgrade
{
    // 是否需要进行数据库的升级
    NSInteger currentVersion = [self getDatabaseVersion];
    if (currentVersion < 1)
    {
        YSLog(@"当前的数据版本号有误");
        return NO;
    }
    
    NSInteger newVersion = [self appCorrespondingDatabaseVersion];
    return newVersion != currentVersion;
}

- (void)checkVersionWithDatabase:(FMDatabase *)database
{
    // 检查数据库版本，根据情况进行相应更新
    
    if (![database goodConnection])
    {
        YSLog(@"database没有连接成功");
        return;
    }
    
    self.database = database;
    
    if (![self hasSetVersion])
    {
        // 若从未将版本号设置，则先设置为1，一般这种情况出现在第一个版本的时候
        [self setDatabaseVersion:1];
    }
    
    if ([self needUpgrade])
    {
        [self DBUpgrade];
    }
}

- (void)DBUpgrade
{
    // 数据库升级
    NSInteger currentVersion = [self getDatabaseVersion];
    NSInteger newVersion = [self appCorrespondingDatabaseVersion];
    
    if (newVersion <= currentVersion)
    {
        YSLog(@"并不需要升级!");
        return;
    }
    
    NSInteger steps = newVersion - currentVersion;
    NSArray *selectorStringArray = [self upgradeSelectorStringArray];
    
    // 最初的版本号从1开始，所以需要-1
    if (([selectorStringArray count] - (currentVersion - 1)) < steps)
    {
        YSLog(@"版本号与对应索引有误");
        return;
    }
    
    // 依次执行每个版本之间的升级方法
    self.upgradeResult = YES;
    for (NSInteger i = 0; i < steps; i++)
    {
        NSInteger index = currentVersion - 1 + i;
        NSString *selectorString = selectorStringArray[index];
        
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        SEL sel = NSSelectorFromString(selectorString);
        [self performSelector:sel];
    #pragma clang diagnostic pop
        
        // 某次升级失败，则接下来的升级取消
        if (!self.upgradeResult)
        {
            break;
        }
    }
}

- (NSArray *)upgradeSelectorStringArray
{
    // 数据库各个版本依次进行升级时，所需要调用的函数方法名称的数组
    // 当有新的升级时，将对应的方法名字直接加入到array末端
    NSArray *array = @[@"upgrade1To2"];
    
    return array;
}

- (void)upgrade1To2
{
    // 将数据库版本由1升级到2
    NSString *sql = [NSString stringWithFormat:@"ALTER TABLE \"%@\" ADD \"%@\" FLOAT", DatabaseUserTable, UserTableWeightKey];
    
    BOOL res = [self.database executeUpdate:sql];
    [self checkUpgradeResult:res];
    
    self.upgradeResult = res;
    if (self.upgradeResult)
    {
        // 升级操作成功，设置对应的版本号
        [self setDatabaseVersion:2];
    }
}

- (void)upgrade2To3
{
    // 将数据库版本由2升级到3

}

- (void)upgrade3To4
{
    // 将数据库版本由3升级到4
}

- (void)checkUpgradeResult:(BOOL)result
{
    NSString *resultStr = result ? @"成功" : @"失败";
    NSString *message = [NSString stringWithFormat:@"数据库升级%@", resultStr];
    
    YSLog(@"%@", message);
}

@end
