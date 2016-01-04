//
//  YSDatabaseManager.m
//  YSRun
//
//  Created by moshuqi on 15/10/23.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSDatabaseManager.h"
#import "YSDatabaseHandle.h"
#import "YSUtilsMacro.h"

#import "YSRunInfoModel.h"
#import "YSRunDatabaseModel.h"
#import "YSUserInfoModel.h"
#import "YSUserDatabaseModel.h"
#import "YSDatabaseQueue.h"

@interface YSDatabaseManager ()

// 将所有的数据操作放到队列里执行以进行多线程操作。2015.12.31

//@property (nonatomic, strong) YSDatabaseHandle *databaseHandle;
@property (nonatomic, strong) YSDatabaseQueue *dbQueue;

@end

@implementation YSDatabaseManager

// 数组依次对应升级需要的总次数，暂时的升级数据需求，满级为6级
static NSInteger upgrade[] = {0, 3, 6, 9, 15, 20}; // 初始1级，升到2级总次数要3次，升到3级要6次...
const NSInteger upgradeArrayCount = 6;
const NSInteger topGrade = 6;

const NSString *kNotLoginUid = nil;

- (id)init
{
    self = [super init];
    if (self)
    {
//        self.databaseHandle = [YSDatabaseHandle shareDatabaseHandle];
        self.dbQueue = [YSDatabaseQueue shareDatabaseQueue];
    }
    
    return self;
}

- (YSUserInfoModel *)getUserInfo
{
    YSUserInfoModel *userInfo = [YSUserInfoModel new];
    
    YSUserDatabaseModel *databaseModel = [self.dbQueue getUser];
    if (databaseModel)
    {
        userInfo.uid = databaseModel.uid;
        userInfo.nickname = databaseModel.nickname;
        userInfo.phone = databaseModel.phone;
        
        NSString *headImgStr = databaseModel.headimg;
        UIImage *image = [UIImage imageNamed:@"user_default_photo.png"];
        
        // 向服务器请求头像时放子线程里，否则在网络情况差的时候会阻塞主线程
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
//            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:headImgStr]];
//            if (imgData)
//            {
//                image = [UIImage imageWithData:imgData];
//            }
//            dispatch_async(dispatch_get_main_queue(), ^(){
//                userInfo.headImage = image;
//            });
//        });
        
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:headImgStr]];
        if (imgData)
        {
            image = [UIImage imageWithData:imgData];
        }
        userInfo.headImage = image;
    }
    else
    {
        // 未登录的情况下用户昵称显示“未登录”，头像显示默认
        userInfo.nickname = @"未登录";
        userInfo.headImage = [UIImage imageNamed:@"user_default_photo.png"];
    }
    
    userInfo.totalDistance = [self.dbQueue getTotalDistance] / 1000; // 界面显示单位为：公里
    userInfo.totalRunTimes = [self.dbQueue getTotalRunTimes];
    userInfo.totalUseTime = [self.dbQueue getTotalUsetime] / 60; // 界面显示的单位为分钟，数据库存的是秒
    
    [self setupUserGrage:userInfo];
    
    return userInfo;
}

- (NSString *)getCurrentUid
{
    NSString *uid = nil;
    
    YSUserDatabaseModel *databaseModel = [self.dbQueue getUser];
    if (databaseModel)
    {
        uid = databaseModel.uid;
    }
    
    return uid;
}

- (void)setupUserGrage:(YSUserInfoModel *)user
{
    // 计算等级相关数据
    NSInteger totalRunTimes = user.totalRunTimes;
    
    NSInteger grade = [self evaluateGradeByRunTimes:totalRunTimes];
    NSInteger upgradeRequireTimes = [self evaluateUpgradeRequireTimesByRunTimes:totalRunTimes];
    CGFloat progress = [self evaluateUpgradeProgressByRunTimes:totalRunTimes];
    NSString *achieveTitle = [self achieveTitleWithGrade:grade];
    
    user.grade = grade;
    user.upgradeRequireTimes = upgradeRequireTimes;
    user.progress = progress;
    user.achieveTitle = achieveTitle;
}

- (NSInteger)evaluateGradeByRunTimes:(NSInteger)runTimes
{
    // 通过跑步的总次数来计算当前等级
    
    NSInteger grade = 1;
    if (runTimes >= upgrade[upgradeArrayCount - 1])
    {
        grade = topGrade;
    }
    else
    {
        for (NSInteger i = 0; i < upgradeArrayCount; i ++)
        {
            if (runTimes < upgrade[i])
            {
                grade = i;
                break;
            }
        }
    }
    
    return grade;
}

- (NSInteger)evaluateUpgradeRequireTimesByRunTimes:(NSInteger)runTimes
{
    // 计算距离下次升级还需要跑步的次数
    
    NSInteger grade = [self evaluateGradeByRunTimes:runTimes];
    if ([self isTopGrade:grade])
    {
        // 按现在的规则是满级了
        YSLog(@"满级了。。。");
        return 0;
    }
    
    NSInteger upgradeRequireTimes = 0;
    for (NSInteger i = 0; i < upgradeArrayCount; i++)
    {
        if (runTimes < upgrade[i])
        {
            upgradeRequireTimes = upgrade[i] - runTimes;
            break;
        }
    }
    
    return upgradeRequireTimes;
}

- (CGFloat)evaluateUpgradeProgressByRunTimes:(NSInteger)runTimes
{
    // 计算升下一级的进度
    
    NSInteger grade = [self evaluateGradeByRunTimes:runTimes];
    if ([self isTopGrade:grade])
    {
        // 达到满级，进度条满
        return 1.0;
    }
    
    NSInteger currentGradeRequireTimes = upgrade[grade - 1];    // 当前等级所需要的次数
    NSInteger nextGradeRequireTimes = upgrade[grade];    // 下一等级所需要的次数
    
    NSInteger step = nextGradeRequireTimes - currentGradeRequireTimes;
    CGFloat progress = (CGFloat)(runTimes - currentGradeRequireTimes) / step;
    
    return progress;
}

- (NSString *)achieveTitleWithGrade:(NSInteger)grade
{
    // 等级头像计算方式
    NSString *achieveTitle = nil;
    if (grade < 4)
    {
        achieveTitle = @"初级跑步者";
    }
    else
    {
        achieveTitle = @"中级跑步者";
    }
    
    return achieveTitle;
}

- (BOOL)isTopGrade:(NSInteger)grade
{
    // 是否满级
    BOOL isTopGrade = (grade >= topGrade) ? YES : NO;
    return isTopGrade;
}

- (BOOL)isLogin
{
    BOOL isLogin = NO;
    
    NSInteger count = [self.dbQueue getLocalUserCount];
    if (count > 0)
    {
        isLogin = YES;
        
        if (count > 1)
        {
            // 退出登录之后应删除掉之前的用户数据，用户数据不应该大于1
            YSLog(@"保存在本地数据库的用户数量大于1");
        }
    }
    
    return isLogin;
}

- (void)addUser:(YSUserDatabaseModel *)userDatabaseModel
{
    if ([self.dbQueue uidExsit:userDatabaseModel.uid])
    {
        [self.dbQueue deleteUser:userDatabaseModel.uid];
    }
    
    [self.dbQueue insertUser:userDatabaseModel];
}

- (NSInteger)addRunData:(YSRunDatabaseModel *)model
{
    // 将跑步数据存储到数据库
    return [self.dbQueue insertRunData:model];
}

- (void)setUser:(NSString *)uid withLastTime:(NSInteger)lastTime
{
    [self.dbQueue updateUser:uid withLastTime:lastTime];
}

- (void)setUser:(NSString *)uid withHeadImagePath:(NSString *)headImagePath
{
    [self.dbQueue updateUser:uid withHeadImagePath:headImagePath];
}

- (void)setUser:(NSString *)uid withNickname:(NSString *)nickname
{
    [self.dbQueue updateUser:uid withNickname:nickname];
}

- (void)deleteNotLoginRunData
{
    [self.dbQueue deleteRunDataWithUid:(NSString *)kNotLoginUid];
}

- (void)deleteUserAndRelatedRunDataWithUid:(NSString *)uid
{
    // 删除用户和所对应的跑步数据。
    [self.dbQueue deleteUser:uid];
    [self.dbQueue deleteRunDataWithUid:uid];
}

- (NSArray *)getNotLoginRunData
{
    return [self.dbQueue getRunDataWithUid:(NSString *)kNotLoginUid];
}

- (NSArray *)getLocalNotUpdateRunData
{
    // 获取本地未上传的跑步数据
    return [self.dbQueue getRunDataWithUpdateState:2];
}

- (void)setNotLoginRunDataUid:(NSString *)uid
{
    // 将本地未登录时的跑步数据uid赋值
    if (uid)
    {
        [self.dbQueue updateRunDataUid:(NSString *)kNotLoginUid withNewUid:uid];
    }
    else
    {
        YSLog(@"uid为空。。");
    }
}

- (void)setRunDataHasUpdateWithRowid:(NSInteger)rowid
{
    // 将跑步数据标记为已上传。
    [self.dbQueue setRunDataUpdateState:YES byRowid:rowid];
}

- (NSInteger)lastInsertRunDataRowid
{
    return [self.dbQueue lastInsertRowidInRunDataTable];
}

- (NSInteger)getLastTimeWithUid:(NSString *)uid
{
    YSUserDatabaseModel *model = [self.dbQueue getUser];
    NSInteger lastTime = -1;
    if (model.lasttime)
    {
        lastTime = [model.lasttime integerValue];
    }
    return lastTime;
}

- (NSArray *)getAllTheMonthRunDataWithDate:(NSDate *)date
{
    return nil;
}

- (NSArray *)getRunDataFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    return nil;
}

- (NSInteger)getRunStarRatingWithDate:(NSDate *)date
{
    // 返回日期对应的最好的跑步记录的评分，若对应的日期里没有跑步记录，则返回-1
    NSInteger starRating = -1;
    
    NSArray *runDataArray = [self.dbQueue getRunInfoInDate:date];
    if ([runDataArray count] >= 1)
    {
        for (YSRunDatabaseModel *model in runDataArray)
        {
            if (model.star > starRating)
            {
                starRating = model.star;
            }
        }
    }
    
    return starRating;
}

- (NSArray *)getRunDataArrayWithDate:(NSDate *)date
{
    NSArray *runDataArray = [self.dbQueue getRunInfoInDate:date];
    return runDataArray;
}

- (void)updateLastTimeToCurrentWithUid:(NSString *)uid
{
    // 将用户的lasttime值更新为当前的时间。
    
    NSInteger lastTime = [[NSDate date] timeIntervalSince1970];
    [self.dbQueue updateUser:uid withLastTime:lastTime];
}

@end
