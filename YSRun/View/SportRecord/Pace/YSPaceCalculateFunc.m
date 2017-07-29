//
//  YSPaceCalculateFunc.m
//  YSRun
//
//  Created by moshuqi on 16/1/26.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSPaceCalculateFunc.h"
#import "YSTimeLocationModel.h"
#import "YSTimeLocationArray.h"
#import "YSMapCalculateFunc.h"
#import "YSMapAnnotation.h"
#import "YSPaceSectionDataModel.h"
#import "YSUtilsMacro.h"

@interface YSPaceCalculateFunc ()

@property (nonatomic, strong) YSTimeLocationArray *timeLocationArray;
@property (nonatomic, assign) NSInteger useTime;    // 总时间，秒

@property (nonatomic, strong) NSMutableArray *sectionDataArray;
@property (nonatomic, assign) CGFloat averagePace;

// 最高最低配速
@property (nonatomic, assign) CGFloat lowPace;
@property (nonatomic, assign) CGFloat highPace;

@end

@implementation YSPaceCalculateFunc

- (id)initWithTimeLocationArray:(YSTimeLocationArray *)timeLocationArray
                        useTime:(NSInteger)useTime
{
    self = [super init];
    if (self)
    {
        self.timeLocationArray = timeLocationArray;
        self.useTime = useTime;
        
        [self calculate];
    }
    
    return self;
}

- (NSArray *)getPaceSectionDataArray
{
    return self.sectionDataArray;
}

- (void)calculate
{
    // 计算各段的配速
    
    NSArray *timeLocationModels = [self.timeLocationArray getDataArray];
    NSInteger locationModelCount = [timeLocationModels count];
    if (locationModelCount < 2)
    {
        YSLog(@"数据小于2，无法计算");
        return;
    }
    
    // 平均配速
    CGFloat totalDistance = [self calculateDistance:timeLocationModels] / 1000;
    self.averagePace = self.useTime / 60.0 / totalDistance;
    
    // 计算每一段的数据，按每公里分段
    NSArray *splitArray = [self splitTimeLocationModelArray:timeLocationModels byDistance:[self splitDistance]];
    self.sectionDataArray = [NSMutableArray array];
    
    for (NSArray *array in splitArray)
    {
        YSPaceSectionDataModel *sectionData = [self getPaceSectionDataWithArray:array];
        [self.sectionDataArray addObject:sectionData];
    }
    
    // 更新配速值
    [self updatePaceValue];
    
    NSInteger sectionCount = [self.sectionDataArray count];
    for (NSInteger i = 0; i < sectionCount; i++)
    {
        YSPaceSectionDataModel *sectionData = self.sectionDataArray[i];
        sectionData.section = i + 1;
        sectionData.isLastSection = NO;
        
        if ((i + 1) == sectionCount)
        {
            sectionData.section = totalDistance;
            sectionData.isLastSection = YES;
        }
    }
    
    [self setupPaceSectionProgressValue];
}

- (void)updatePaceValue
{
    // 更新配速的最低最高值
    NSInteger count = [self.sectionDataArray count];
    if (count < 1)
    {
        return;
    }
    
    YSPaceSectionDataModel *sectionData = [self.sectionDataArray firstObject];
    
    self.lowPace = sectionData.pace;
    self.highPace = sectionData.pace;
    
    for (NSInteger i = 1; i < count; i++)
    {
        sectionData = self.sectionDataArray[i];
        CGFloat pace = sectionData.pace;
        
        if (pace < self.lowPace)
        {
            self.lowPace = pace;
        }
        else if (pace > self.highPace)
        {
            self.highPace = pace;
        }
    }
}

- (void)setupPaceSectionProgressValue
{
    // 计算进度条显示的值
    
    // 左边必须保证至少有一段值，右边保证有一段进度未满的间距
    CGFloat leftValue = 0.25;
    CGFloat rightValue = 0.2;
    
    CGFloat value = 1 - leftValue - rightValue;
    CGFloat rangeValue = self.highPace - self.lowPace;
    
    NSInteger count = [self.sectionDataArray count];
    if (count < 2)
    {
        // 当只有一个数据时，特殊处理 --2016.2.21
        YSPaceSectionDataModel *sectionData = [self.sectionDataArray firstObject];
        sectionData.progress = 0.66;
    }
    else
    {
        if (rangeValue > 0)
        {
            for (NSInteger i = 0; i < count; i++)
            {
                YSPaceSectionDataModel *sectionData = self.sectionDataArray[i];
                CGFloat p = (sectionData.pace - self.lowPace) / rangeValue;
                sectionData.progress = p * value + leftValue;
            }
        }
    }
}

- (CGFloat)splitDistance
{
    return 1000.0;
}

- (YSPaceSectionDataModel *)getPaceSectionDataWithArray:(NSArray<YSTimeLocationModel *> *)array
{
    // 根据数组数据做计算
    YSPaceSectionDataModel *dataModel = [YSPaceSectionDataModel new];
    
    // 计算时间，若没有时间数据，则根据比例取时间值
    NSInteger duration = 0;
    
    
    if ([self.timeLocationArray hasTimeData])
    {
        YSTimeLocationModel *first = [array firstObject];
        YSTimeLocationModel *last = [array lastObject];
        
        duration = last.timestamp - first.timestamp;
    }
    else
    {
        CGFloat proportion = [array count] * 1.0 / ([[self.timeLocationArray getDataArray] count]);
        duration = self.useTime * proportion;
    }
    
    // 配速
    CGFloat pace = duration / 60.0 / ([self splitDistance] / 1000);
    dataModel.pace = pace;
    
    // 其他属性
    dataModel.useTime = duration;
    dataModel.locationCount = [array count];
    
    return dataModel;
}

- (NSArray *)splitTimeLocationModelArray:(NSArray *)modelArray byDistance:(CGFloat)distance
{
    // 按照距离将timeLocationModel数组，按照distance距离段拆分成几个数组
    
    NSMutableArray *sectionArray = [NSMutableArray array];
    YSTimeLocationModel *lastModel = [modelArray firstObject];
    
    NSInteger count = [modelArray count];
    NSInteger startIndex = 0;
    CGFloat accumulationDistance = 0;
    
    for (NSInteger i = 1; i < count; i ++)
    {
        YSTimeLocationModel *currentModel = modelArray[i];
        CGFloat d = [YSMapCalculateFunc distanceBetweenCoordinate1:lastModel.coordinate coordinate2:currentModel.coordinate];
        
        accumulationDistance += d;
        if (accumulationDistance > distance)
        {
            // 找到范围，范围内数据产生新数组保存到返回值中
            NSInteger length = i - startIndex + 1; // +1表示包含当前索引
            NSRange range = {startIndex, length};
            
            NSArray *section = [modelArray subarrayWithRange:range];
            [sectionArray addObject:section];
            
            // 将标记数据重置
            accumulationDistance = 0;
            startIndex = i + 1;
        }
        
        lastModel = currentModel;
    }
    
    if (startIndex < count)
    {
        // 最后余下没有超出distance范围的一段
        NSRange range = {startIndex, count - startIndex};
        NSArray *section = [modelArray subarrayWithRange:range];
        
        [sectionArray addObject:section];
    }
    
    return sectionArray;
}

- (CGFloat)calculateDistance:(NSArray<YSTimeLocationModel *> *)modelArray
{
    // 计算所包含的位置数据点的总距离
    NSMutableArray *annotationArray = [NSMutableArray array];
    for (YSTimeLocationModel *model in modelArray)
    {
        YSMapAnnotation *annotation = [[YSMapAnnotation alloc] initWithCoordinate:model.coordinate];
        [annotationArray addObject:annotation];
    }
    
    CGFloat distance = [YSMapCalculateFunc totalDistance:annotationArray];
    return distance;
}

@end
