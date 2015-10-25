//
//  YSUserInfoManager.m
//  YSRun
//
//  Created by moshuqi on 15/10/23.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSUserInfoManager.h"
#import "YSDatabaseManager.h"
#import "YSUserInfoModel.h"

@interface YSUserInfoManager ()

@property (nonatomic, strong) YSDatabaseManager *databaseManager;

@end

@implementation YSUserInfoManager

- (id)init
{
    self = [super init];
    if (self)
    {
        self.databaseManager = [YSDatabaseManager new];
    }
    
    return self;
}

- (YSUserInfoModel *)getUserInfo
{
    YSUserInfoModel *userInfoModel = [YSUserInfoModel new];
    
    
    
    return userInfoModel;
}

@end
