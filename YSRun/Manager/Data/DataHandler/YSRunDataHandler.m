//
//  YSRunDataHandler.m
//  YSRun
//
//  Created by moshuqi on 15/11/18.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSRunDataHandler.h"
#import "YSUserInfoResponseModel.h"
#import "YSDatabaseManager.h"
#import "YSNetworkManager.h"
#import "YSDataManager.h"
#import "YSRunDatabaseModel.h"
#import "YSUtilsMacro.h"
#import "YSModelReformer.h"
#import "YSUserDatabaseModel.h"
#import "YSUserInfoModel.h"

@interface YSRunDataHandler () <YSNetworkManagerDelegate>

@end

@implementation YSRunDataHandler

- (void)synchronizeRunData
{
    // 同步本地与服务端的跑步数据
    
    if ([[YSDataManager shareDataManager] isLogin])
    {
        // 请求服务端未同步到本地的数据
        YSDatabaseManager *databaseManager = [YSDatabaseManager new];
        YSUserInfoModel *userInfo = [[YSDataManager shareDataManager] getUserInfo];
        NSInteger lastTime = [databaseManager getLastTimeWithUid:userInfo.uid];
        
        YSNetworkManager *networkManager = [YSNetworkManager new];
        networkManager.delegate = self;
        
        [networkManager getRunDataWithUid:userInfo.uid lastTime:lastTime];
        
        // 将本地未保存到服务器数据上传
        NSArray *runDataArray = [databaseManager getLocalNotUpdateRunData];
        for (NSInteger i = 0; i < [runDataArray count]; i++)
        {
            YSRunDatabaseModel *model = runDataArray[i];
            [networkManager uploadRunData:model];
        }
    }
}

- (void)uploadNotLoginRunData
{
    // 将本地未登录时的跑步数据上传
    
    // 获取本地未上传数据
    YSDatabaseManager *databaseManager = [YSDatabaseManager new];
    NSArray *runDataArray = [databaseManager getNotLoginRunData];
    
    YSNetworkManager *networkManager = [YSNetworkManager new];
    networkManager.delegate = self;
    
    NSString *uid = [databaseManager getCurrentUid];
    for (NSInteger i = 0; i < [runDataArray count]; i++)
    {
        // 本地未登录时的跑步数据，附上登录之后的uid
        YSRunDatabaseModel *runDatabaseModel = runDataArray[i];
        runDatabaseModel.uid = uid;
        
        // 数据上传
        [networkManager uploadRunData:runDatabaseModel];
        
        // 将跑步数据附上对应的uid值
        [databaseManager setNotLoginRunDataUid:uid];
    }
    
    // 数据库更改需要更新YSDataManager的值
    [[YSDataManager shareDataManager] resetData];
}

- (void)loginSuccessWithUserInfoResponseModel:(YSUserInfoResponseModel *)userInfoResponseModel
{
    // 登录成功后进行相应的数据库更新，服务器同步操作。
    
    YSUserDatabaseModel *userDatabaseModel = [YSModelReformer userDatabaseModelFromUserInfoResponseModel:userInfoResponseModel];
    
    [self addUserInfoToDatabase:userDatabaseModel];
    
    // 向服务器请求数据
    YSNetworkManager *networkManager = [YSNetworkManager new];
    networkManager.delegate = self;
    
    // 登录完成之后第一次的lasttime传-1，服务器会进行处理。
    [networkManager getRunDataWithUid:userInfoResponseModel.uid lastTime:-1];
    
    [self callback];
}

- (void)registerSuccessWithResponseUserInfo:(YSUserDatabaseModel *)userInfo
{
    // 用户注册成功，用户信息存储到数据库，并将未登录时的跑步数据上传。
    
    [self addUserInfoToDatabase:userInfo];
    [self uploadNotLoginRunData];
    
    [self callback];
}

- (void)recordSingleRunData:(YSRunDatabaseModel *)runDatabaseModel
{
    // 跑步完成，记录单次跑步数据
    
    runDatabaseModel.isUpdate = 2;  // 未上传到服务器
    
    // 保存到本地数据库
    YSDatabaseManager *databaseManager = [YSDatabaseManager new];
    // 插入数据库之后取rowid赋值，上传成功之后需要用rowid作为参数
    NSInteger rowid = [databaseManager addRunData:runDatabaseModel];
    runDatabaseModel.rowid = rowid;
    if (rowid < 1) {
        YSLog(@"lastInsertRunDataRowid 小于1");
    }
    
    // 记录保存到数据库后更新单例的数据。
    [[YSDataManager shareDataManager] resetData];
    
    if ([[YSDataManager shareDataManager] isLogin])
    {
        // 跑步完成之后，上传本次跑步的数据
        
        YSNetworkManager *networkManager = [YSNetworkManager new];
        networkManager.delegate = self;
        [networkManager uploadRunData:runDatabaseModel];
    }
}

- (void)addUserInfoToDatabase:(YSUserDatabaseModel *)userDatabaseModel
{
    // 将用户添加到数据库
    
    YSDatabaseManager *databaseManager = [YSDatabaseManager new];
    [databaseManager addUser:userDatabaseModel];
    
    [[YSDataManager shareDataManager] resetData];
}

- (void)callback
{
    // 回调更新界面
    if ([self.delegate respondsToSelector:@selector(runDataHandleFinish)])
    {
        [self.delegate runDataHandleFinish];
    }
}

#pragma mark - YSNetworkManagerDelegate


#pragma mark - 跑步数据上传

- (void)uploadRunDataSuccessWithRowid:(NSInteger)rowid lasttime:(NSString *)lasttime
{
    // 上传成功，设置对应的跑步数据isUpadate，标记为已上传
    YSDatabaseManager *databaseManager = [YSDatabaseManager new];
    [databaseManager setRunDataHasUpdateWithRowid:rowid];
    
    NSString *uid = [databaseManager getCurrentUid];
    [databaseManager setUser:uid withLastTime:[lasttime integerValue]];
}

- (void)uploadRunDataFailureWithMessage:(NSString *)message
{
    YSLog(@"上传跑步数据失败");
}

#pragma mark - 跑步数据同步

- (void)databaseSynchronizeRunDatas:(NSArray *)runDatas lastTime:(NSInteger)lastTime
{
    // getRunData的请求结果回调，此时将需要同步的数据保存到本地数据库
    
    YSDatabaseManager *databaseManager = [YSDatabaseManager new];
    for (NSInteger i = 0; i < [runDatas count]; i++)
    {
        YSRunDatabaseModel *model = runDatas[i];
        [databaseManager addRunData:model];
    }
    
    // 同步之后设置lasttime，是否需要同步数据到本地根据lasttime判断
    NSString *uid = ((YSRunDatabaseModel *)[runDatas firstObject]).uid;
    [databaseManager setUser:uid withLastTime:lastTime];
    
    // 服务器端有可同步数据时，需要将之前本地未登录时保存的跑步数据删除。
    [databaseManager deleteNotLoginRunData];
    
    [[YSDataManager shareDataManager] resetData];
    
    [self callback];
}

- (void)runDataEmptyInServer
{
    [self uploadNotLoginRunData];
}


@end
