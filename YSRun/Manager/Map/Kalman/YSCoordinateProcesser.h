//
//  YSCoordinateProcesser.h
//  YSRun
//
//  Created by moshuqi on 16/1/15.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@interface YSCoordinateProcesser : NSObject

- (CLLocationCoordinate2D)processWithCoordinate:(CLLocationCoordinate2D)coordinate speed:(CGFloat)speed timestamp:(NSInteger)timestamp;

@end
