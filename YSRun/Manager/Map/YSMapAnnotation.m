//
//  YSMapAnnotation.m
//  YSRun
//
//  Created by moshuqi on 15/11/10.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSMapAnnotation.h"

@implementation YSMapAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self)
    {
        _coordinate = coordinate;
    }
    
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;
}

@end
