//
//  LocationData.m
//  YSRun
//
//  Created by moshuqi on 16/1/14.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "LocationData.h"
#import <UIKit/UIKit.h>

@interface LocationData ()

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, assign) NSInteger timestamp;
@property (nonatomic, assign) double accuracy;

@end

@implementation LocationData

- (id)initWithLatitude:(double)latitude
             longitude:(double)longitude
                 speed:(CGFloat)speed
             timestamp:(NSInteger)timestamp
{
    self = [super init];
    if (self)
    {
        self.latitude = latitude;
        self.longitude = longitude;
        self.speed = speed;
        self.timestamp = timestamp;
        
        self.accuracy = 8;
    }
    
    return self;
}

- (CLLocationCoordinate2D)getCoordinate
{
    CLLocationCoordinate2D coordinate = {self.latitude, self.longitude};
    return coordinate;
}

- (double)getLatitude
{
    return self.latitude;
}

- (double)getLongitude
{
    return self.longitude;
}

- (CGFloat)getSpeed
{
    return self.speed;
}

- (NSInteger)getTimestamp
{
    return self.timestamp;
}

- (double)getAccuracy
{
    return self.accuracy;
}

@end
