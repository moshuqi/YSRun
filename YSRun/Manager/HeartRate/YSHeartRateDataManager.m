//
//  YSHeartRateDataManager.m
//  YSRun
//
//  Created by moshuqi on 15/12/1.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSHeartRateDataManager.h"
#import "YSStatisticsDefine.h"

@interface YSHeartRateDataManager ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation YSHeartRateDataManager

- (id)init
{
    self = [super init];
    if (self)
    {
        self.dataArray = [NSMutableArray array];
    }
    
    return self;
}

- (void)addHeartRate:(NSInteger)heartRate
{
    [self.dataArray addObject:[NSNumber numberWithInteger:heartRate]];
}

- (NSArray *)getHeartRateDataArray
{
    // 数据太多，每一段取平均数保存，减少数组大小
    NSInteger currentDataCount = [self.dataArray count];
    if (currentDataCount < [self maxDataCount])
    {
        return self.dataArray;
    }
    
    NSInteger segmentCount = currentDataCount / [self maxDataCount];
    if (segmentCount < 2)
    {
        segmentCount = 2;
    }
    
    NSArray *heartDataArray = [self handleDataArray:self.dataArray withSegmentCount:segmentCount];
    return heartDataArray;
}

+ (double)efficientProportionWithHeartRateArray:(NSArray *)heartRateArray
{
    // 计算达标心率的比例
    NSInteger count = [heartRateArray count];
    if (count < 1)
    {
        return 0;
    }
    
    NSInteger efficientCount = 0;    // 达标的心率个数
    for (NSInteger i = 0; i < count; i++)
    {
        NSInteger heartRate = [heartRateArray[i] integerValue];
        if ((heartRate >= YSGraphDataMiddleSectionMin) &&
            (heartRate <= YSGraphDataMiddleSectionMax)) {
            efficientCount ++;
        }
    }
    
    double proportion = efficientCount * 1.0 / count;
    return proportion;
}

- (NSArray *)handleDataArray:(NSArray *)dataArray withSegmentCount:(NSInteger)segmentCount
{
    // 按照每段segmentCount个数取平均值，拼成一个新的数组
    if (segmentCount > [dataArray count])
    {
        return dataArray;
    }
    
    NSMutableArray *newArray = [NSMutableArray array];
    NSInteger count = [dataArray count];
    for (NSInteger i = 0; i < count; )
    {
        NSRange range = {i, segmentCount};
        if (range.length + i > count)
        {
            range.length = count - i;
        }
        
        NSArray *subArray = [dataArray subarrayWithRange:range];
        NSInteger avg = [self getAveragesWithArray:subArray];
        
        [newArray addObject:[NSNumber numberWithInteger:avg]];
        
        i += segmentCount;
    }
    
    return newArray;
}

- (NSInteger)getAveragesWithArray:(NSArray *)array
{
    // 取一个数组的平局值
    NSNumber *avg = [array valueForKeyPath:@"@avg.floatValue"];
    float averages = [avg floatValue];
    
    return (NSInteger)averages;
}

- (NSInteger)maxDataCount
{
    return 50;
}

@end
