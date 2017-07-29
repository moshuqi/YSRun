//
//  YSTimeLocationArray.m
//  YSRun
//
//  Created by moshuqi on 16/1/26.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSTimeLocationArray.h"
#import "YSTimeLocationModel.h"
#import "YSMapAnnotation.h"

@interface YSTimeLocationArray ()

@property (nonatomic, assign) BOOL hasTime;     // 是否有时间数据
@property (nonatomic, copy) NSArray *dataArray;

@end

@implementation YSTimeLocationArray

- (id)init
{
    self = [super init];
    if (self)
    {
        self.hasTime = NO;
    }
    
    return self;
}

- (id)initWithLocationArray:(NSArray *)locationArray
             timestampArray:(NSArray *)timestampArray
{
    self = [super init];
    if (self)
    {
        // 根据位置数据和时间数据重新构造一个数组
        
        NSInteger timestampCount = [timestampArray count];
        NSInteger locationCount = [locationArray count];
        
        self.hasTime = (timestampCount > 0) ? YES : NO;
        NSMutableArray *dataArray = [NSMutableArray array];
        
        // 初始化数组数据
        NSInteger dataCount = self.hasTime ? MIN(timestampCount, locationCount) : locationCount;
        for (NSInteger i = 0; i < dataCount; i ++)
        {
            YSTimeLocationModel *model = [YSTimeLocationModel new];
            [dataArray addObject:model];
        }
        
        // 数据赋值
        for (NSInteger i = 0; i < dataCount; i++)
        {
            YSTimeLocationModel *model = dataArray[i];
            
            // 位置数据
            YSMapAnnotation *annotation = locationArray[i];
            model.coordinate = annotation.coordinate;
            
            // 时间数据
            if (self.hasTime)
            {
                NSInteger timestamp = [timestampArray[i] integerValue];
                model.timestamp = timestamp;
            }
        }
        
        self.dataArray = [NSArray arrayWithArray:dataArray];
    }
    
    return self;
}

- (BOOL)hasTimeData
{
    return self.hasTime;
}

- (NSArray *)getDataArray
{
    return self.dataArray;
}

@end
