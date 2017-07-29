//
//  YSMapCalculateFunc.m
//  YSRun
//
//  Created by moshuqi on 16/1/15.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSMapCalculateFunc.h"
#import "YSMapAnnotation.h"

@implementation YSMapCalculateFunc

+ (CGFloat)distanceBetweenAnnotation1:(YSMapAnnotation *)annotation1
                          annotation2:(YSMapAnnotation *)annotation2
{
    return [YSMapCalculateFunc distanceBetweenCoordinate1:annotation1.coordinate
                                              coordinate2:annotation2.coordinate];
}

+ (CGFloat)distanceBetweenCoordinate1:(CLLocationCoordinate2D)coordinate1
                          coordinate2:(CLLocationCoordinate2D)coordinate2
{
    // 两个坐标间的距离
    MAMapPoint point1 = MAMapPointForCoordinate(coordinate1);
    MAMapPoint point2 = MAMapPointForCoordinate(coordinate2);
    
    // 距离为米
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    return distance;
}

+ (CGFloat)totalDistance:(NSArray<YSMapAnnotation *> *)annotationArray
{
    // 总距离
    CGFloat totalDistance = 0.0;
    
    NSInteger numberOfCoords = [annotationArray count];
    if (numberOfCoords > 1)
    {
        for (NSInteger i = 0; i < numberOfCoords - 1; i++)
        {
            YSMapAnnotation *annotation1 = annotationArray[i];
            YSMapAnnotation *annotation2 = annotationArray[i + 1];
            
            CGFloat distance = [YSMapCalculateFunc distanceBetweenAnnotation1:annotation1 annotation2:annotation2];
            totalDistance += distance;
        }
    }
    
    return totalDistance;
}

+ (CGFloat)calculateSpeedWithTime:(NSInteger)time
                  annotationArray:(NSArray<YSMapAnnotation *> *)annotationArray
{
    // time单位为秒
    if (([annotationArray count] < 2) || (time <= 0))
    {
        return 0;
    }
    
    CGFloat distance = [YSMapCalculateFunc totalDistance:annotationArray];
    CGFloat speed = distance / time;
    
    return speed;
}

+ (void)addAnnotationArray:(NSArray<YSMapAnnotation *> *)annotationArray
               toMapView:(MAMapView *)mapView
{
    // 根据坐标点添加路径
    
    NSInteger count = [annotationArray count];
    CLLocationCoordinate2D polylineCoords[count];
    for (NSInteger i = 0; i < count; i++)
    {
        YSMapAnnotation *annotation = annotationArray[i];
        CLLocationCoordinate2D coordinate = annotation.coordinate;
        
        polylineCoords[i].latitude = coordinate.latitude;
        polylineCoords[i].longitude = coordinate.longitude;
    }
    
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:polylineCoords count:count];
    [mapView addOverlay:polyline];
}

+ (NSArray *)getLastObjectsFromArray:(NSArray *)fromArray numberOfObjects:(NSInteger)number
{
    // 取数组最后几个元素
    NSInteger count = [fromArray count];
    if (number > count)
    {
        return nil;
    }
    
    NSInteger location = count - number;
    NSRange range = {location, number};
    
    NSArray *result = [fromArray subarrayWithRange:range];
    return result;
}

@end
