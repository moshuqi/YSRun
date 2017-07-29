//
//  YSMapCalculateFunc.h
//  YSRun
//
//  Created by moshuqi on 16/1/15.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@class YSMapAnnotation;

@interface YSMapCalculateFunc : NSObject

+ (CGFloat)distanceBetweenAnnotation1:(YSMapAnnotation *)annotation1
                          annotation2:(YSMapAnnotation *)annotation2;
+ (CGFloat)distanceBetweenCoordinate1:(CLLocationCoordinate2D)coordinate1
                          coordinate2:(CLLocationCoordinate2D)coordinate2;

+ (CGFloat)totalDistance:(NSArray<YSMapAnnotation *> *)annotationArray;
+ (CGFloat)calculateSpeedWithTime:(NSInteger)time
                  annotationArray:(NSArray<YSMapAnnotation *> *)annotationArray;

+ (void)addAnnotationArray:(NSArray<YSMapAnnotation *> *)annotationArray
               toMapView:(MAMapView *)mapView;

+ (NSArray *)getLastObjectsFromArray:(NSArray *)fromArray
                     numberOfObjects:(NSInteger)number;

@end
