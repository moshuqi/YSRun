//
//  YSGraphData.m
//  YSRun
//
//  Created by moshuqi on 15/11/17.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSGraphData.h"
#import "YSGraphPoint.h"
#import "YSUtilsMacro.h"
#import "YSStatisticsDefine.h"

@interface YSGraphData ()

@property (nonatomic, strong) NSMutableArray *graphData;

// 分3个区域，每个区域的颜色不一致
@property (nonatomic, strong) UIColor *topColor;
@property (nonatomic, strong) UIColor *middleColor;
@property (nonatomic, strong) UIColor *bottomColor;

@end

@implementation YSGraphData

- (id)initWithDataArray:(NSArray *)dataArray
{
    self = [super init];
    if (self)
    {
        [self setGraphDataWithArray:dataArray];
        [self config];
    }
    
    return self;
}

- (void)setGraphDataWithArray:(NSArray *)dataArray
{
    // dataArray为存储dict的数组，每个dict包含心率和时间戳信息。
    
    self.graphData = [NSMutableArray array];
    for (NSDictionary *dict in dataArray)
    {
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            NSInteger heartRate = [[dict valueForKey:YSGraphDataHeartRateKey] integerValue];
            NSInteger timestamp = [[dict valueForKey:YSGraphDataTimestampKey] integerValue];
            
            // 横坐标为时间轴
            YSGraphPoint *graphPoint = [YSGraphPoint new];
            graphPoint.abscissaValue = timestamp;
            graphPoint.ordinateValue = heartRate;
            
            [self.graphData addObject:graphPoint];
        }
    }
}

- (void)config
{
    // 根据数据内容设定各项值
    
    if (([self.graphData count] < 1) || !self.graphData)
    {
        YSLog(@"self.graphData数值有误。");
        return;
    }
    
    // 横坐标为时间戳，纵坐标为心率，心率范围设为60~200，其中140~160为高效燃脂区间
    self.ordinateMin = YSGraphDataOrdinateMin;
    self.ordinateMax = YSGraphDataOrdinateMax;
    
    self.middleSectionMax = YSGraphDataMiddleSectionMax;
    self.middleSectionMin = YSGraphDataMiddleSectionMin;
    
    // 数组中的数据以时间递增的方式存储，固第一个元素为开始时间，最后一个为结束时间
    YSGraphPoint *firstGraphPoint = [self.graphData firstObject];
    self.abscissaMin = firstGraphPoint.abscissaValue;
    
    YSGraphPoint *lastGraphPoint = [self.graphData lastObject];
    self.abscissaMax = lastGraphPoint.abscissaValue;
    
    
}

- (void)setBackgroundWithTopColor:(UIColor *)topColor middleColor:(UIColor *)middleColor bottomColor:(UIColor *)bottomColor
{
    self.topColor = topColor;
    self.middleColor = middleColor;
    self.bottomColor = bottomColor;
}

- (UIColor *)getTopColor
{
    return self.topColor;
}

- (UIColor *)getMiddleColor
{
    return self.middleColor;
}

- (UIColor *)getBottomColor
{
    return self.bottomColor;
}

- (NSInteger)dataCount
{
    return [self.graphData count];
}

- (YSGraphPoint *)graphPointAtIndex:(NSInteger)index
{
    if (index > [self.graphData count])
    {
        YSLog(@"数组访问越界。");
        return nil;
    }
    
    YSGraphPoint *graphPoint = self.graphData[index];
    return graphPoint;
}

@end
