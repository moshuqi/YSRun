//
//  YSCoordinateProcesser.m
//  YSRun
//
//  Created by moshuqi on 16/1/15.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSCoordinateProcesser.h"
#import "KalmanFilter.h"
#import "LocationData.h"

@interface YSCoordinateProcesser ()

@property (nonatomic, strong) KalmanFilter *kalmanFilter;

@end

@implementation YSCoordinateProcesser

- (id)init
{
    self = [super init];
    if (self)
    {
        self.kalmanFilter = [KalmanFilter new];
    }
    
    return self;
}

- (CLLocationCoordinate2D)processWithCoordinate:(CLLocationCoordinate2D)coordinate speed:(CGFloat)speed timestamp:(NSInteger)timestamp
{
    // 将坐标通过卡尔曼滤波算法处理后返回
    LocationData *locationData = [[LocationData alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude speed:speed timestamp:timestamp];
    [self.kalmanFilter locationUpdate:locationData];
    
    LocationData *filteredData = [self.kalmanFilter getFilteredLocationData];
    CLLocationCoordinate2D filterdCoordinate = [filteredData getCoordinate];
    
    return filterdCoordinate;
}

@end
