//
//  YSDatabaseManager.h
//  YSRun
//
//  Created by moshuqi on 15/10/23.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YSUserInfoModel;
@class YSRunDatabaseModel;
@class YSUserDatabaseModel;

@interface YSDatabaseManager : NSObject

- (YSUserInfoModel *)getUserInfo;  // 获取页面展示所需的用户信息
- (NSString *)getCurrentUid;    // 获取当前用户uid
- (BOOL)isLogin;    // 当前是否已登录

- (void)addUser:(YSUserDatabaseModel *)userDatabaseModel;
- (NSInteger)addRunData:(YSRunDatabaseModel *)model;    // 返回插入的表中对应的自增id

- (void)setUser:(NSString *)uid withLastTime:(NSInteger)lastTime;
- (void)setUser:(NSString *)uid withHeadImagePath:(NSString *)headImagePath;
- (void)setUser:(NSString *)uid withNickname:(NSString *)nickname;
- (void)deleteNotLoginRunData;

- (void)deleteUserAndRelatedRunDataWithUid:(NSString *)uid;

- (NSArray *)getNotLoginRunData;
- (NSArray *)getLocalNotUpdateRunData;

- (void)setNotLoginRunDataUid:(NSString *)uid;
- (void)setRunDataHasUpdateWithRowid:(NSInteger)rowid;

- (NSInteger)lastInsertRunDataRowid;
- (NSInteger)getLastTimeWithUid:(NSString *)uid;

//- (NSArray *)getAllTheMonthRunDataWithDate:(NSDate *)date;
//- (NSArray *)getRunDataFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (NSInteger)getRunStarRatingWithDate:(NSDate *)date;
- (NSArray *)getRunDataArrayWithDate:(NSDate *)date;

- (void)updateLastTimeToCurrentWithUid:(NSString *)uid;

@end
