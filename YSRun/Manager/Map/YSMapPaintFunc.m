//
//  YSMapPaintFunc.m
//  YSRun
//
//  Created by moshuqi on 15/12/1.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "YSMapPaintFunc.h"
#import "YSMapAnnotation.h"
#import "YSAppMacro.h"

@interface YSMapPaintFunc () <MAMapViewDelegate>

@property (nonatomic, strong) YSMapAnnotation *startAnnotation;
@property (nonatomic, strong) YSMapAnnotation *endAnnotation;

@end

@implementation YSMapPaintFunc

- (UIImage *)screenshotWithAnnotationArray:(NSArray *)annotationArray size:(CGSize)size;
{
    CGRect mapFrame = CGRectMake(0, 0, size.width, size.height);
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:mapFrame];
    mapView.delegate = self;
    
    // mapview必须加上才能正常截图，截图完成之后才从父视图移除。
    [[UIApplication sharedApplication].keyWindow addSubview:mapView];
    
//    mapView.zoomLevel = 15.5;
    
    // 画路径
    [self addOverlayWithAnnotationArray:annotationArray inMapView:mapView];
    
    [self addStartAnnotation:[annotationArray firstObject]
               endAnnotation:[annotationArray lastObject]
                   inMapView:mapView];
    
    CGRect rect = mapView.bounds;
    UIImage *screenshot = [mapView takeSnapshotInRect:rect];
    [mapView removeFromSuperview];
    
    return screenshot;
}

- (void)drawPathWithAnnotationArray:(NSArray *)annotationArray inMapView:(MAMapView *)mapView
{
    mapView.showsCompass = NO;

    if ([annotationArray count] < 2)
    {
        return;
    }
    
    mapView.delegate = self;
    
    [self addOverlayWithAnnotationArray:annotationArray inMapView:mapView];
    
    [self addStartAnnotation:[annotationArray firstObject]
               endAnnotation:[annotationArray lastObject]
                   inMapView:mapView];
}

- (void)addOverlayWithAnnotationArray:(NSArray *)annotationArray inMapView:(MAMapView *)mapView
{
    // 路径添加到地图上
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
}

- (void)addStartAnnotation:(YSMapAnnotation *)startAnnotation
             endAnnotation:(YSMapAnnotation *)endAnnotation
                 inMapView:(MAMapView *)mapView
{
    // 起点位置图标
    self.startAnnotation = startAnnotation;
    [mapView addAnnotation:self.startAnnotation];
    
    // 终点位置图标
    self.endAnnotation = endAnnotation;
    [mapView addAnnotation:self.endAnnotation];
}

- (UIImage *)getStartAnnotationImage
{
    UIImage *image = [UIImage imageNamed:@"pathStartPointImage"];
    return image;
}

- (UIImage *)getEndAnnotationImage
{
    UIImage *image = [UIImage imageNamed:@"pathEndPointImage"];
    return image;
}

#pragma mark - MAMapViewDelegate

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth = 4.f;
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

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[YSMapAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        
        UIImage *image = nil;
        if (annotation == self.startAnnotation)
        {
            image = [self getStartAnnotationImage];
        }
        else if (annotation == self.endAnnotation)
        {
            image = [self getEndAnnotationImage];
        }
        annotationView.image = image;
        
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}

@end
