//
//  YSDatabaseQueue.h
//  YSRun
//
//  Created by moshuqi on 15/12/29.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class YSUserDatabaseModel;
@class YSRunDatabaseModel;

@interface YSDatabaseQueue : NSObject

+ (instancetype)shareDatabaseQueue;

- (YSUserDatabaseModel *)getUser;
- (NSInteger)getLocalUserCount;

- (CGFloat)getTotalDistance;
- (NSInteger)getTotalUsetime;
- (NSInteger)getTotalRunTimes;

- (NSArray *)getRunDataWithUid:(NSString *)uid;
- (NSArray *)getRunDataWithUpdateState:(NSInteger)isUpdate;
- (NSInteger)lastInsertRowidInRunDataTable;

- (NSArray *)getRunInfoInDate:(NSDate *)date;

- (BOOL)uidExsit:(NSString *)uid;

- (NSInteger)insertRunData:(YSRunDatabaseModel *)runData;   // 本地插入跑步数据,返回跑步数据的id
- (void)insertUser:(YSUserDatabaseModel *)userInfo;    // 插入用户

- (void)insertHeartRateDataWithRunid:(NSInteger)runid dataString:(NSString *)dataString;    // 插入心率数据
- (void)insertLocationDataWithRunid:(NSInteger)runid dataString:(NSString *)dataString;     // 插入位置数据

- (void)deleteUser:(NSString *)uid; // 删除用户
- (void)deleteRunDataWithUid:(NSString *)uid; // 删除对应uid的跑步数据

- (void)updateRunDataUid:(NSString *)uid withNewUid:(NSString *)newUid;    // 修改跑步数据的uid
- (void)updateUser:(NSString *)uid withLastTime:(NSInteger)lastTime;    // 修改用户的lasttime
- (void)updateUser:(NSString *)uid withHeadImagePath:(NSString *)headImagePath; // 修改用户的头像图片路径
- (void)updateUser:(NSString *)uid withNickname:(NSString *)nickname;   // 修改用户昵称
- (void)setRunDataUpdateState:(BOOL)isUpdate byRowid:(NSInteger)rowid;

@end
