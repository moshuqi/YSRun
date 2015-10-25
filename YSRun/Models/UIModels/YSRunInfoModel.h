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

// 跑步的开始时间，结束时间，用时。单位为秒，timeIntervalSince1970
@property (nonatomic, assign) CGFloat startTime;
@property (nonatomic, assign) CGFloat endTime;
@property (nonatomic, assign) CGFloat useTime;

@property (nonatomic, strong) NSDate *date;     // 此次跑步的日期

@property (nonatomic, assign) CGFloat hSpeed;   // 最快速度
@property (nonatomic, assign) CGFloat lSpeed;   // 最低速度
@property (nonatomic, assign) CGFloat speed;    // 平均速度
@property (nonatomic, assign) CGFloat pace;     // 配速

@property (nonatomic, assign) CGFloat distance;     // 跑步总距离，单位：米

@end
