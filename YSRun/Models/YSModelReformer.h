//
//  YSModelReformer.h
//  YSRun
//
//  Created by moshuqi on 15/10/28.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YSRunDatabaseModel;
@class YSRunInfoModel;
@class YSUserDatabaseModel;
@class YSUserInfoResponseModel;
@class YSDataRecordModel;

@interface YSModelReformer : NSObject

+ (YSRunDatabaseModel *)runDatabaseModelFromRunInfoModel:(YSRunInfoModel *)runInfoModel;
+ (YSUserDatabaseModel *)userDatabaseModelFromUserInfoResponseModel:(YSUserInfoResponseModel *)userInfoResponse;
+ (YSDataRecordModel *)dataRecordModelFromRunDatabaseModel:(YSRunDatabaseModel *)runDatabaseModel;
+ (YSDataRecordModel *)dataRecordModelFromRunInfoModel:(YSRunInfoModel *)runInfoModel;
+ (NSString *)stringFromDate:(NSDate *)date;

@end
