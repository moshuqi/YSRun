//
//  YSRunInfoModel.h
//  YSRun
//
//  Created by moshuqi on 15/10/23.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YSRunInfoModel : NSObject

@property (nonatomic, assign) NSInteger rowid;  // 本地数据库作为唯一标识的id

// 跑步的开始时间，结束时间，用时。单位为秒，timeIntervalSince1970
@property (nonatomic, assign) NSInteger beginTime;
@property (nonatomic, assign) NSInteger endTime;
@property (nonatomic, assign) NSInteger useTime;

@property (nonatomic, copy) NSDate *date;     // 此次跑步的日期

@property (nonatomic, assign) CGFloat hSpeed;   // 最快速度
@property (nonatomic, assign) CGFloat lSpeed;   // 最低速度
@property (nonatomic, assign) CGFloat speed;    // 平均速度
@property (nonatomic, assign) CGFloat pace;     // 配速

@property (nonatomic, assign) CGFloat distance;     // 跑步总距离，单位：米
@property (nonatomic, copy) NSString *uid;      // 对应user
@property (nonatomic, assign) NSInteger star;   // 评星

@property (nonatomic, copy) NSArray *locationArray;     // 保存定位坐标数据
@property (nonatomic, copy) NSArray *heartRateArray;    // 保存心率数据

@end
