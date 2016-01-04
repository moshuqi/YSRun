//
//  YSCalorieCalculateFunc.m
//  YSRun
//
//  Created by moshuqi on 15/12/11.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSCalorieCalculateFunc.h"

@implementation YSCalorieCalculateFunc

+ (CGFloat)calculateManCalorieWithAge:(NSInteger)age
                               weight:(CGFloat)weight
                          heartRateAvg:(CGFloat)heartRateAvg
                      exerciseTimeMin:(CGFloat)exerciseTimeMin
{
    // 男：卡路里 = (年龄 x 0.2017 + 体重 x0.1988 + 平均心率 x 0.6309 - 55.0969] x 运动时间 * 4.184.
    
    // 体重为：kg，运动时间为：分钟
    CGFloat calorie = (age * 0.2017 + weight * 0.1988 + heartRateAvg * 0.6309 - 55.0969) * exerciseTimeMin * 4.184;
    
    return calorie;
}

+ (CGFloat)calculateWomanCalorieWithAge:(NSInteger)age
                                 weight:(CGFloat)weight
                           heartRateAvg:(CGFloat)heartRateAvg
                          calmHeartRate:(CGFloat)calmHeartRate
                       exerciseTimeMin:(CGFloat)exerciseTimeMin
{
    // 女：总卡路里 = ((-59.3954+0.45*平均心率+5.814*（208-0.7*年龄）/静息心率+0.107*体重+0.274*年龄)/4.184)*分钟
    
    // 体重为：kg，运动时间为：分钟
    
    CGFloat calorie = ((-59.3954 + 0.45 * heartRateAvg + 5.814 * (208 - 0.7 * age) / calmHeartRate + 0.107 * weight + 0.274 * age) / 4.184) * exerciseTimeMin;
    
    return calorie;
}

+ (CGFloat)calculateCalorieWithWeight:(CGFloat)weight distance:(CGFloat)distance
{
    // 暂时用这个算卡路里
    
    // 跑步热量（kcal）＝体重（kg）×距离（公里）×1.036
    CGFloat calorie = weight * distance * 1.036;
    return calorie;
}

@end
