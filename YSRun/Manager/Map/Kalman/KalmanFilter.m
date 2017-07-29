//
//  KalmanFilter.m
//  YSRun
//
//  Created by moshuqi on 16/1/14.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "KalmanFilter.h"
#import <UIKit/UIKit.h>
#import "LocationData.h"

@interface KalmanFilter ()

@property (nonatomic, assign) NSInteger timestamp;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) CGFloat variance;

@property (nonatomic, strong) LocationData *filteredLocationData;

@end

@implementation KalmanFilter

- (id)init
{
    self = [super init];
    if (self)
    {
        self.variance = -1;
    }
    
    return self;
}

- (void)setStateWithLatitude:(double)latitude
                   longitude:(double)longitude
                   timestamp:(NSInteger)timestamp
                    accuracy:(CGFloat)accuracy
{
    self.latitude = latitude;
    self.longitude = longitude;
    self.timestamp = timestamp;
    self.variance = accuracy * accuracy;
}

- (void)locationUpdate:(LocationData *)locationData
{
    [self processWithNewSpeed:locationData.getSpeed
                  newLatitude:locationData.getLatitude
                 newLongitude:locationData.getLongitude
                 newTimestamp:locationData.getTimestamp
                  newAccuracy:locationData.getAccuracy];
}

- (void)processWithNewSpeed:(CGFloat)newSpeed
                newLatitude:(double)newLatitude
               newLongitude:(double)newLongitude
               newTimestamp:(NSInteger)newTimestamp
                newAccuracy:(double)newAccuracy
{
    if (self.variance < 0)
    {
        [self setStateWithLatitude:newLatitude longitude:newLongitude timestamp:newTimestamp accuracy:newAccuracy];
        
        //  在这也初始化self.filteredLocationData，保证getFilteredLocationData在第一次返回时也不为空
        self.filteredLocationData = [[LocationData alloc] initWithLatitude:newLatitude longitude:newLongitude speed:newSpeed timestamp:newTimestamp];
    }
    else
    {
        NSInteger duration = newTimestamp - self.timestamp;
        if (duration > 0)
        {
            self.variance += duration * newSpeed * newSpeed;
            self.timestamp = newTimestamp;
        }
        
        float k = self.variance / (self.variance + newAccuracy * newAccuracy);
        self.latitude += k * (newLatitude - self.latitude);
        self.longitude += k * (newLongitude - self.longitude);
        
        self.variance = (1 - k) * self.variance;
        
        self.filteredLocationData = [[LocationData alloc] initWithLatitude:self.latitude longitude:self.longitude speed:newSpeed timestamp:self.timestamp];
    }
}

- (LocationData *)getFilteredLocationData
{
    return self.filteredLocationData;
}

@end
