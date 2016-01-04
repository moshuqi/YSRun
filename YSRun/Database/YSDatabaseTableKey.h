//
//  YSDatabaseTableKey.h
//  YSRun
//
//  Created by moshuqi on 15/10/26.
//  Copyright © 2015年 msq. All rights reserved.
//

#ifndef YSDatabaseTableKey_h
#define YSDatabaseTableKey_h

// 数据库名称
#define DatabaseName @"Yspaobu_Database.sqlite"

// 数据库表单
#define DatabaseUserTable           @"Yspaobu_UserTable"
#define DatabaseRunDataTable        @"Yspaobu_RunDataTable"
#define DatabaseRunDataCellTable    @"Yspaobu_RunDataCellTable"

#define DatabaseRunHeartRateDataTable    @"Yspaobu_RunHeartRateDataTable"
#define DatabaseRunLocationDataTable     @"Yspaobu_RunLocationDataTable"

// Yspaobu_userTable
#define UserTableUidKey             @"uid"
#define UserTableBirthdayKey        @"birthday"
#define UserTableSexKey             @"sex"
#define UserTablePhoneKey           @"phone"
#define UserTableHeightKey          @"height"
#define UserTableNicknameKey        @"nickname"
#define UserTableLastTimeKey        @"lasttime"
#define UserTableHeadImgKey         @"headimg"
#define UserTableAgeKey             @"age"

// version2，增加个体重字段
#define UserTableWeightKey          @"weight"


// Yspaobu_RunDataTable
#define RunDataTableUidKey          @"uid"
#define RunDataTablePaceKey         @"pace"
#define RunDataTableDistanceKey     @"distance"
#define RunDataTableSpeedKey        @"speed"
#define RunDataTableEdateKey        @"edate"
#define RunDataTableStarKey         @"star"
#define RunDataTableLowestSpeedKey  @"l_speed"
#define RunDataTableUsetimeKey      @"usetime"
#define RunDataTableBdateKey        @"bdate"
#define RunDataTableDateKey         @"date"
#define RunDataTableCostKey         @"cost"
#define RunDataTableIsUpdateKey     @"isUpdate"
#define RunDataTableHighestSpeedKey @"h_speed"
#define RunDataTableDetailKey       @"detail"

// Yspaobu_RunHeartRateData
#define RunHeartRateDataTableHeartRateKey       @"heartRateData"

// Yspaobu_RunLocationData
#define RunLocationDataTableLocationKey         @"locationData"

#define RunDataIDKey        @"runid"

#endif /* YSDatabaseTableKey_h */
