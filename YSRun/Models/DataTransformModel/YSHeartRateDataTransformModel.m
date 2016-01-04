//
//  YSHeartRateDataTransformModel.m
//  YSRun
//
//  Created by moshuqi on 15/11/27.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSHeartRateDataTransformModel.h"
#import "YSUtilsMacro.h"

@implementation YSHeartRateDataTransformModel

- (NSString *)separatedString
{
    // 心率以“心率1,心率2”格式用字符串进行数据库的存储，取出时通过“,”进行数据拆分
    return @",";
}

- (NSArray *)getDataArrayWithComponents:(NSArray *)components
{
    // dataArray包含的是心率NSInteger数据
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *string in components)
    {
        NSInteger heartRate = [string integerValue];
        [array addObject:[NSNumber numberWithInteger:heartRate]];
    }
    
    return array;
}

- (NSString *)getDataStringWithArray:(NSArray *)array
{
    // 将心率数据数组转化成“心率1,心率2”格式的字符串
    NSMutableString *dataString = [NSMutableString string];
    if ([array count] > 0)
    {
        NSInteger heartRate = [[array firstObject] integerValue];
        NSString *string = [NSString stringWithFormat:@"%@", @(heartRate)];
        [dataString appendString:string];
        
        for (NSInteger i = 1; i < [array count]; i++)
        {
            heartRate = [array[i] integerValue];
            string = [NSString stringWithFormat:@",%@", @(heartRate)];
            [dataString appendString:string];
        }
    }
    else
    {
        YSLog(@"array数组元素为空！");
        return nil;
    }
    
    return dataString;
}

@end
