//
//  LocationData.h
//  YSRun
//
//  Created by moshuqi on 16/1/14.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@interface LocationData : NSObject

- (id)initWithLatitude:(double)latitude
             longitude:(double)longitude
                 speed:(CGFloat)speed
             timestamp:(NSInteger)timestamp;
- (CLLocationCoordinate2D)getCoordinate;

- (double)getLatitude;
- (double)getLongitude;
- (CGFloat)getSpeed;
- (NSInteger)getTimestamp;
- (double)getAccuracy;

@end
