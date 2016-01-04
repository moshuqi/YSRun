//
//  YSMapScreenshotPaint.m
//  YSRun
//
//  Created by moshuqi on 15/12/1.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "YSMapScreenshotPaint.h"
#import "YSMapAnnotation.h"
#import "YSAppMacro.h"

@interface YSMapScreenshotPaint () <MAMapViewDelegate>

@end

@implementation YSMapScreenshotPaint

- (UIImage *)screenshotPaintWithAnnotationArray:(NSArray *)annotationArray size:(CGSize)size;
{
    [MAMapServices sharedServices].apiKey = (NSString *)MapAPIKey;
    
    CGRect mapFrame = CGRectMake(0, 0, size.width, size.height);
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:mapFrame];
    mapView.delegate = self;
    
    // mapview必须加上才能正常截图，截图完成之后才从父视图移除。
    [[UIApplication sharedApplication].keyWindow addSubview:mapView];
    
    mapView.zoomLevel = 15.5;
    
    // 画路径
    NSInteger numberOfCoords = [annotationArray count];
    CLLocationCoordinate2D commonPolylineCoords[numberOfCoords];
    
    for (NSInteger i = 0; i < numberOfCoords; i++)
    {
        YSMapAnnotation *annotation = annotationArray[i];
        CLLocationCoordinate2D coordinate = annotation.coordinate;
        
        commonPolylineCoords[i].latitude = coordinate.latitude;
        commonPolylineCoords[i].longitude = coordinate.longitude;
    }
    
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:numberOfCoords];
    [mapView addOverlay:commonPolyline];
    
    [mapView showAnnotations:annotationArray animated:NO];
    
    // 起点位置图标
    UIImage *startImage = [UIImage imageNamed:@"running_start_icon"];
    MAGroundOverlay *startCoordMark = [MAGroundOverlay groundOverlayWithCoordinate:commonPolylineCoords[0] zoomLevel:mapView.zoomLevel icon:startImage];
    
    // 终点位置图标
    UIImage *endImage = [UIImage imageNamed:@"running_end_icon"];
    MAGroundOverlay *endCoordMark = [MAGroundOverlay groundOverlayWithCoordinate:commonPolylineCoords[numberOfCoords - 1] zoomLevel:mapView.zoomLevel icon:endImage];
    
    [mapView addOverlay:startCoordMark];
    [mapView addOverlay:endCoordMark];
    
    CGRect rect = mapView.bounds;
    UIImage *screenshot = [mapView takeSnapshotInRect:rect];
    [mapView removeFromSuperview];
    
    return screenshot;
}

#pragma mark - MAMapViewDelegate

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth = 8.f;
        polylineView.strokeColor = GreenBackgroundColor;
        //        polylineView.lineJoinType = kMALineJoinRound;//连接类型
        //        polylineView.lineCapType = kMALineCapRound;//端点类型
        
        return polylineView;
    }
    else if ([overlay isKindOfClass:[MAGroundOverlay class]])
    {
        MAGroundOverlayView *groundOverlayView = [[MAGroundOverlayView alloc]
                                                  initWithGroundOverlay:overlay];
        
        return groundOverlayView;
    }
    
    return nil;
}

@end
