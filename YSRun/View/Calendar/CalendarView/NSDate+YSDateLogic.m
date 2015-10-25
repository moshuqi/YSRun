//
//  NSDate+YSDateLogic.m
//  YSRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "NSDate+YSDateLogic.h"

@implementation NSDate (YSDateLogic)

- (NSInteger)yearValue
{
    NSCalendar *calendar = [self getCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    
    NSInteger year = components.year;
    return year;
}

- (NSInteger)monthValue
{
    NSCalendar *calendar = [self getCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    
    NSInteger month = components.month;
    return month;
}

- (NSInteger)dayValue
{
    NSCalendar *calendar = [self getCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    
    // components.day会比实际的值大1，所以做处理
    NSInteger day = components.day;
    return day;
}

- (NSInteger)weekdayValue
{
    NSCalendar *calendar = [self getCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:self];
    
    NSInteger weekday = components.weekday;
    return weekday;
}

- (NSDate *)beforeDays:(NSInteger)days
{
    // 前几天
    return [self intervalDays:-days];
}

- (NSDate *)afterDays:(NSInteger)days
{
    // 后几天
    return [self intervalDays:days];
}

- (NSDate *)intervalDays:(NSInteger)days
{
    NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([self timeIntervalSinceReferenceDate] + (24 * 3600 * days))];
    return newDate;
}

- (NSDate *)firstDayOfCurrentMonth
{
    // 返回当前月份的第一天
    NSInteger day = [self dayValue];
    NSDate *firstDay = [self beforeDays:day - 1];
    
    return firstDay;
}

- (NSDate *)lastDayOfCurrentMonth
{
    // 返回当前月份的最后一天
    NSInteger day = [self dayValue];
    NSInteger numberOfDays = [self numberOfDaysInCurrentMonth];
    
    NSDate *lastDay = [self afterDays:numberOfDays - day];
    return lastDay;
}

- (NSUInteger)numberOfDaysInCurrentMonth
{
    // 当前月一共有几天
    return [[self getCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
}

- (NSCalendar *)getCalendar
{
    return [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
}

+ (NSDate *)dateFromString:(NSString *)dateString
{
    // 将string转换成date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *destDate = [dateFormatter dateFromString:dateString];
    return destDate;
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    // 将date转换成string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destString = [dateFormatter stringFromDate:date];
    return destString;
}

@end
