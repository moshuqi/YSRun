//
//  YSMapManager.h
//  YSRun
//
//  Created by moshuqi on 15/10/18.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@interface YSMapManager : NSObject

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) UILabel *OutputMessageLabel;

- (void)testRoute;

@end
