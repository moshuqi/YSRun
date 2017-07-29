//
//  YSMapManager.h
//  YSRun
//
//  Created by moshuqi on 15/10/18.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@protocol YSMapManagerDelegate <NSObject>

@required
- (void)updateDistance:(CGFloat)distance;

@end

@interface YSMapManager : NSObject

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, weak) id<YSMapManagerDelegate> delegate;

@property (nonatomic, strong) UILabel *testLabel;   // 显示数据的标签

- (void)testRoute;
- (void)setupMapView;
- (void)startLocation;
- (void)endLocation;

- (CGFloat)getHighestSpeed;
- (CGFloat)getLowestSpeed;
- (CGFloat)getTotalDistance;
- (NSArray *)getCoordinateRecord;

@end
