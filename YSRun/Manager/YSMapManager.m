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
@property (nonatomic, assign) CGFloat pace;    // 配速

@property (nonatomic, strong) NSMutableArray *coordinateRecordArray;
@property (nonatomic, copy) NSArray *updateRouteCoordArray;

@property (nonatomic, assign) CGFloat hSpeed;
@property (nonatomic, assign) CGFloat lSpeed;

@property (nonatomic, assign) CGFloat lastLocatedTime;  // 上一次定位的时间
@property (nonatomic, assign) CGFloat currentLocatedTime;   // 当前定位的时间

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
        
        // 初始化，之后通过是否大于0来判断有没有赋值
        self.lastLocatedTime = -1;
        self.currentLocatedTime = -1;
        self.hSpeed = -1;
        self.lSpeed = -1;
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

- (void)calculationSpeed
{
    // 每次位置更新都计算最近一段距离内的速度
    NSInteger count = [self.coordinateRecordArray count];
    if ((count < 2) || (self.lastLocatedTime < 0))
    {
        return;
    }
    
    NSValue *coordinateValue1 = self.coordinateRecordArray[count - 1];
    CLLocationCoordinate2D coordinate1;
    [coordinateValue1 getValue:&coordinate1];
    
    NSValue *coordinateValue2 = self.coordinateRecordArray[count - 2];
    CLLocationCoordinate2D coordinate2;
    [coordinateValue2 getValue:&coordinate2];
    
    CGFloat distance = [self distanceBetweenCoordinate1:coordinate1 coordinate2:coordinate2];
    CGFloat time = self.currentLocatedTime - self.lastLocatedTime;
    CGFloat speed = distance / time;    // m/s
    
    // 第一次计算速度时未赋值。
    if (self.hSpeed < 0 && self.lSpeed)
    {
        self.hSpeed = speed;
        self.lSpeed = speed;
    }
    
    // 最低速度
    if (self.lSpeed > speed)
    {
        self.lSpeed = speed;
    }
    
    // 最高速度
    if (self.hSpeed < speed)
    {
        self.hSpeed = speed;
    }
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        CLLocationCoordinate2D coordinate = userLocation.coordinate;
        [self addLocationCoordinate:coordinate];
        [self updateRoute];
        
        // 计算最快、最慢速度
        self.lastLocatedTime = self.currentLocatedTime;
        self.currentLocatedTime = CFAbsoluteTimeGetCurrent();
        [self calculationSpeed];
        
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
