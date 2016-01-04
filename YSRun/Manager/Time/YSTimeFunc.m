//
//  YSTimeFunc.m
//  YSRun
//
//  Created by moshuqi on 15/11/25.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSTimeFunc.h"
#import "NSDate+YSDateLogic.h"

@implementation YSTimeFunc

+ (NSString *)timeStrFromUseTime:(NSInteger)useTime
{
    // 将秒转换成“00:00:00”的格式来显示
    NSInteger secPerHour = 60 * 60;
    NSInteger hour = useTime / secPerHour;
    NSInteger min = (useTime % secPerHour) / 60;
    NSInteger sec = (useTime % secPerHour) % 60;
    
    NSString *hourStr = (hour >= 10) ? [NSString stringWithFormat:@"%@", @(hour)] : [NSString stringWithFormat:@"0%@", @(hour)];
    NSString *minStr = (min >= 10) ? [NSString stringWithFormat:@"%@", @(min)] : [NSString stringWithFormat:@"0%@", @(min)];
    NSString *secStr = (sec >= 10) ? [NSString stringWithFormat:@"%@", @(sec)] : [NSString stringWithFormat:@"0%@", @(sec)];
    
    NSString *timeStr = [NSString stringWithFormat:@"%@:%@:%@", hourStr, minStr, secStr];
    return timeStr;
}

+ (NSString *)dateStrFromTimestamp:(NSInteger)timestamp
{
    // 将时间戳转换成“XX月XX日 hh:mm”格式的字符串
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSInteger month = [date monthValue];
    NSInteger day = [date dayValue];
    
    NSInteger hour = [date hourValue];
    NSInteger min = [date minuteValue];
    
    NSString *hourStr = (hour >= 10) ? [NSString stringWithFormat:@"%@", @(hour)] : [NSString stringWithFormat:@"0%@", @(hour)];
    NSString *minStr = (min >= 10) ? [NSString stringWithFormat:@"%@", @(min)] : [NSString stringWithFormat:@"0%@", @(min)];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@月%@日  %@:%@", @(month), @(day), hourStr, minStr];
    
    return dateStr;
}

@end
