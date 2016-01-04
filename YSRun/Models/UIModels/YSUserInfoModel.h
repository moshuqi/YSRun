//
//  YSUserInfoModel.h
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YSUserInfoModel : NSObject

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *nickname;     // 用户昵称
@property (nonatomic, strong) UIImage *headImage;   // 头像
@property (nonatomic, assign) NSInteger grade;      // 等级
@property (nonatomic, assign) CGFloat progress;     // 当前等级的升级进度
@property (nonatomic, copy) NSString *achieveTitle;   // 等级所对应的头衔

@property (nonatomic, assign) CGFloat totalDistance;    // 总公里数
@property (nonatomic, assign) NSInteger totalRunTimes;  // 总跑步次数
@property (nonatomic, assign) NSInteger totalUseTime;     // 总时间，单位：分

@property (nonatomic, assign) NSInteger upgradeRequireTimes;    // 升下一级还需要的跑步次数

@property (nonatomic, copy) NSString *phone;

@end
