//
//  YSMapManager.m
//  YSRun
//
//  Created by moshuqi on 15/10/18.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSMapManager.h"

@interface YSMapManager () <MAMapViewDelegate>

@property (nonatomic, assign) CGFloat distance; // 公里
@property (nonatomic, assign) CGFloat speed;    // 配速

@end

static NSString *APIKey = @"45e4efb100710051075252c2407f9402";

@implementation YSMapManager

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initMap];
    }
    
    return self;
}

- (void)initMap
{
    [MAMapServices sharedServices].apiKey = APIKey;
    
    self.mapView = [[MAMapView alloc] init];
    self.mapView.delegate = self;
}

@end
