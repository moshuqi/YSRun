//
//  KalmanFilter.h
//  YSRun
//
//  Created by moshuqi on 16/1/14.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LocationData;

@interface KalmanFilter : NSObject

- (void)locationUpdate:(LocationData *)locationData;
- (LocationData *)getFilteredLocationData;

@end
