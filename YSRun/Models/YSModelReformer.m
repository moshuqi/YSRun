//
//  YSModelReformer.m
//  YSRun
//
//  Created by moshuqi on 15/10/28.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSModelReformer.h"
#import "YSRunDatabaseModel.h"
#import "YSRunInfoModel.h"
#import "YSUserDatabaseModel.h"
#import "YSUserInfoResponseModel.h"
#import <CoreLocation/CoreLocation.h>
#import "YSMapAnnotation.h"

#import "YSDataRecordModel.h"
#import "YSHeartRateDataTransformModel.h"
#import "YSLocationDataTransformModel.h"
#import "YSCalorieCalculateFunc.h"

// 用来封装各种model之间的转换

@implementation YSModelReformer

+ (YSRunDatabaseModel *)runDatabaseModelFromRunInfoModel:(YSRunInfoModel *)runInfoModel
{
    YSRunDatabaseModel *runDatabaseModel = [YSRunDatabaseModel new];
    
    NSString *uid = (runInfoModel.uid == nil) ? (NSString *)[NSNull null] : runInfoModel.uid;
    runDatabaseModel.uid = uid;
    runDatabaseModel.date = [YSModelReformer stringFromDate:runInfoModel.date];
    runDatabaseModel.bdate = runInfoModel.beginTime;
    runDatabaseModel.edate = runInfoModel.endTime;
    runDatabaseModel.usetime = runInfoModel.useTime;
    runDatabaseModel.lSpeed = runInfoModel.lSpeed;
    runDatabaseModel.hSpeed = runInfoModel.hSpeed;
    runDatabaseModel.speed = runInfoModel.speed;
    runDatabaseModel.pace = runInfoModel.pace;
    runDatabaseModel.distance = runInfoModel.distance;
    runDatabaseModel.star = runInfoModel.star;
    
    CGFloat calorie = [YSCalorieCalculateFunc calculateCalorieWithWeight:65 distance:(runInfoModel.distance / 1000)];
    
    runDatabaseModel.cost = calorie;
    
    YSHeartRateDataTransformModel *heartRateDataTransform = [[YSHeartRateDataTransformModel alloc] initWithDataArray:runInfoModel.heartRateArray];
    runDatabaseModel.heartRateDataString = heartRateDataTransform.dataString;
    
    YSLocationDataTransformModel *locationDataTransform = [[YSLocationDataTransformModel alloc] initWithDataArray:runInfoModel.locationArray];
    runDatabaseModel.locationDataString = locationDataTransform.dataString;
    
    return runDatabaseModel;
}

+ (YSUserDatabaseModel *)userDatabaseModelFromUserInfoResponseModel:(YSUserInfoResponseModel *)userInfoResponse
{
    YSUserDatabaseModel *userDatabaseModel = [YSUserDatabaseModel new];
    
    userDatabaseModel.uid = userInfoResponse.uid;
    userDatabaseModel.phone = userInfoResponse.phone;
    userDatabaseModel.nickname = userInfoResponse.nickname;
    userDatabaseModel.birthday = userInfoResponse.birthday;
    userDatabaseModel.headimg = userInfoResponse.headimg;
    
    // Response里不包含lasttime
    userDatabaseModel.lasttime = (NSString *)[NSNull null];
    
    userDatabaseModel.age = ([userInfoResponse.age isKindOfClass:[NSNull class]]) ? 0 : [userInfoResponse.age integerValue];
    userDatabaseModel.sex = ([userInfoResponse.sex isKindOfClass:[NSNull class]]) ? 0 : [userInfoResponse.sex integerValue];
    userDatabaseModel.height = ([userInfoResponse.height isKindOfClass:[NSNull class]]) ? 0 : [userInfoResponse.height integerValue];
    
    return userDatabaseModel;
}

+ (YSDataRecordModel *)dataRecordModelFromRunDatabaseModel:(YSRunDatabaseModel *)runDatabaseModel
{
    YSDataRecordModel *heartRateModel = [YSDataRecordModel new];
    
    heartRateModel.startTime = runDatabaseModel.bdate;
    heartRateModel.endTime = runDatabaseModel.edate;
    heartRateModel.calorie = runDatabaseModel.cost;
    heartRateModel.distance = runDatabaseModel.distance;
    
    YSHeartRateDataTransformModel *heartRateDataTransform = [[YSHeartRateDataTransformModel alloc] initWithDataString:runDatabaseModel.heartRateDataString];
    heartRateModel.heartRateArray = heartRateDataTransform.dataArray;
    
    YSLocationDataTransformModel *locationDataTransformModel = [[YSLocationDataTransformModel alloc] initWithDataString:runDatabaseModel.locationDataString];
    heartRateModel.locationArray = locationDataTransformModel.dataArray;
    
    return heartRateModel;
}

+ (YSDataRecordModel *)dataRecordModelFromRunInfoModel:(YSRunInfoModel *)runInfoModel
{
    YSRunDatabaseModel *runDatabaseModel = [YSModelReformer runDatabaseModelFromRunInfoModel:runInfoModel];
    YSDataRecordModel *recordModel = [YSModelReformer dataRecordModelFromRunDatabaseModel:runDatabaseModel];
    return recordModel;
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    // 将date转换成string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destString = [dateFormatter stringFromDate:date];
    return destString;
}

@end
