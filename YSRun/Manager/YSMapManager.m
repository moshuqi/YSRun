//
//  YSMapManager.m
//  YSRun
//
//  Created by moshuqi on 15/10/18.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSMapManager.h"
#import "YSAppMacro.h"

@interface YSMapManager () <MAMapViewDelegate>

@property (nonatomic, assign) CGFloat distance; // 公里
@property (nonatomic, assign) CGFloat speed;    // 配速

@property (nonatomic, strong) NSMutableArray *coordinateRecordArray;
@property (nonatomic, copy) NSArray *updateRouteCoordArray;

@end

const static NSString *APIKey = @"45e4efb100710051075252c2407f9402";

@implementation YSMapManager

- (id)init
{
    self = [super init];
    if (self)
    {
        self.coordinateRecordArray = [NSMutableArray array];
        [self initMap];
        
        self.OutputMessageLabel = [[UILabel alloc] init];
        self.OutputMessageLabel.textColor = [UIColor blueColor];
        self.OutputMessageLabel.numberOfLines = 0;
        self.OutputMessageLabel.font = [UIFont systemFontOfSize:26];
        self.OutputMessageLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return self;
}

- (void)initMap
{
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
    
    self.mapView = [[MAMapView alloc] init];
    self.mapView.delegate = self;
    
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.pausesLocationUpdatesAutomatically = NO;
    self.mapView.allowsBackgroundLocationUpdates = YES;
}

- (void)addUpdateRoute
{
    // 通过最近记录的两点添加新的路线
    NSInteger numberOfCoords = [self.updateRouteCoordArray count];
    CLLocationCoordinate2D commonPolylineCoords[numberOfCoords];
    
    for (NSInteger i = 0; i < numberOfCoords; i++)
    {
        NSValue *coordinateValue = self.updateRouteCoordArray[i];
        CLLocationCoordinate2D coordinate;
        [coordinateValue getValue:&coordinate];
        
        commonPolylineCoords[i].latitude = coordinate.latitude;
        commonPolylineCoords[i].longitude = coordinate.longitude;
    }
    
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:numberOfCoords];
    
    [self.mapView addOverlay:commonPolyline];
}


- (void)testRoute
{
    int latitude = arc4random() % 10;
    int longitude = arc4random() % 10;
    
    CLLocationCoordinate2D coordinate = {22.2 + latitude / 100.0, 113.5 + longitude / 100.0};
    [self addLocationCoordinate:coordinate];
    [self updateRoute];
    
    CGFloat totalDistace = [self getTotalRunningDistance];
    NSString *text = [NSString stringWithFormat:@"totalDistance = %@", @(totalDistace)];
    self.OutputMessageLabel.text = text;
    
    int r = arc4random() % 255;
    int g = arc4random() % 255;
    int b = arc4random() % 255;
    
    UIColor *color = RGB(r, g, b);
    self.OutputMessageLabel.textColor = color;
}

- (void)addLocationCoordinate:(CLLocationCoordinate2D)coordinate
{
    // 将新位置保存到数组中。
    NSValue *value = [NSValue valueWithBytes:&coordinate objCType:@encode(CLLocationCoordinate2D)];
    [self.coordinateRecordArray addObject:value];
}

- (void)updateRoute
{
    // 更新路径
    NSInteger numberOfCoords = [self.coordinateRecordArray count];
    NSInteger requiredCount = 2;    // 需要两点来绘制新的路线
    if (numberOfCoords < requiredCount)
    {
        // 只有初始点
        return;
    }
    
    self.updateRouteCoordArray = @[self.coordinateRecordArray[numberOfCoords - 2], self.coordinateRecordArray[numberOfCoords - 1]];
    [self addUpdateRoute];
}

- (CGFloat)distanceBetweenCoordinate1:(CLLocationCoordinate2D)coordinate1 coordinate2:(CLLocationCoordinate2D)coordinate2
{
    // 两个坐标间的距离
    MAMapPoint point1 = MAMapPointForCoordinate(coordinate1);
    MAMapPoint point2 = MAMapPointForCoordinate(coordinate2);
    
    // 距离为米
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    return distance;
}

- (CGFloat)getTotalRunningDistance
{
    // 总距离
    CGFloat totalDistance = 0.0;
    
    NSInteger numberOfCoords = [self.coordinateRecordArray count];
    if (numberOfCoords > 1)
    {
        for (NSInteger i = 0; i < numberOfCoords - 1; i++)
        {
            NSValue *coordinateValue1 = self.coordinateRecordArray[i];
            CLLocationCoordinate2D coordinate1;
            [coordinateValue1 getValue:&coordinate1];
            
            NSValue *coordinateValue2 = self.coordinateRecordArray[i + 1];
            CLLocationCoordinate2D coordinate2;
            [coordinateValue2 getValue:&coordinate2];
            
            CGFloat distance = [self distanceBetweenCoordinate1:coordinate1 coordinate2:coordinate2];
            totalDistance += distance;
        }
    }
    
    return totalDistance;
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        CLLocationCoordinate2D coordinate = userLocation.coordinate;
        [self addLocationCoordinate:coordinate];
        [self updateRoute];
        
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
    
//    NSString *message = [NSString stringWithFormat:@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude];
//    self.OutputMessageLabel.text = message;
//    
//    int r = arc4random() % 255;
//    int g = arc4random() % 255;
//    int b = arc4random() % 255;
//    
//    UIColor *color = RGB(r, g, b);
//    self.OutputMessageLabel.textColor = color;
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth = 10.f;
        polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.6];
//        polylineView.lineJoinType = kMALineJoinRound;//连接类型
//        polylineView.lineCapType = kMALineCapRound;//端点类型
        
        return polylineView;
    }
    return nil;
}

@end
