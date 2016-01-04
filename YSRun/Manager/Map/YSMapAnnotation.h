//
//  YSMapAnnotation.h
//  YSRun
//
//  Created by moshuqi on 15/11/10.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@interface YSMapAnnotation : NSObject <MAAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
