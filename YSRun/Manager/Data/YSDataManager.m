//
//  YSDataManager.m
//  YSRun
//
//  Created by moshuqi on 15/10/26.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSDataManager.h"
#import "YSDatabaseManager.h"
#import "YSUserInfoModel.h"
#import "YSShareFunc.h"

// 此类用来保存在多个视图控制器中共用的数据

@interface YSDataManager ()

@property (nonatomic, strong) YSUserInfoModel *userInfo;
@property (nonatomic, assign) BOOL isLogin;

@end

@implementation YSDataManager

static YSDataManager *_instance;

+ (id)allocWithZone:(struct _NSZone *)zone
{
    //调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)shareDataManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YSDataManager alloc] init];
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
        [self resetData];
    }
    
    return self;
}

- (void)resetData
{
    YSDatabaseManager *databaseManager = [YSDatabaseManager new];
    
    self.userInfo = [databaseManager getUserInfo];
    self.isLogin = [databaseManager isLogin];
}

- (YSUserInfoModel *)getUserInfo
{
    return self.userInfo;
}

- (NSString *)getUserName
{
    return self.userInfo.nickname;
}

- (NSString *)getUid
{
    return self.userInfo.uid;
}

- (NSString *)getUserPhone
{
    return self.userInfo.phone;
}

- (BOOL)isThirdPartLogin
{
    BOOL isThirdPartLogin = [YSShareFunc hasAuthorized];
    return isThirdPartLogin;
}

@end
