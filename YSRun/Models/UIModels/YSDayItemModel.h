//
//  YSDayItemModel.h
//  YSRun
//
//  Created by moshuqi on 15/11/2.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSDayItemModel : NSObject

@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) BOOL isCurrentDate;    // 是否为[NSDate date]当天
@property (nonatomic, assign) BOOL isCurrentMonth;   // 是否为当前展示月份里的日期
@property (nonatomic, assign) NSInteger starRating;  // 跑步评分
@property (nonatomic, assign) BOOL hasRunRecord;     // 是否有跑步记录

@property (nonatomic, assign) BOOL selected;         // 是否被选中

@end
