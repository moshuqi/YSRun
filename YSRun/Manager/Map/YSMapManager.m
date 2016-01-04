//
//  YSMapManager.m
//  YSRun
//
//  Created by moshuqi on 15/10/18.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSMapManager.h"
#import "YSAppMacro.h"
#import "YSMapAnnotation.h"

@interface YSMapManager () <MAMapViewDelegate>

@property (nonatomic, assign) CGFloat distance; // 公里

//@property (nonatomic, copy) NSArray *updateRouteCoordArray;
@property (nonatomic, strong) NSMutableArray *annotationRecordArray;

@property (nonatomic, assign) CGFloat hSpeed;
@property (nonatomic, assign) CGFloat lSpeed;

@property (nonatomic, assign) CGFloat lastLocatedTime;  // 上一次定位的时间
@property (nonatomic, assign) CGFloat currentLocatedTime;   // 当前定位的时间

@end

@implementation YSMapManager

static const double kMapDistanceFilter = 10;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.annotationRecordArray = [NSMutableArray array];
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
    [MAMapServices sharedServices].apiKey = (NSString *)MapAPIKey;
    
    self.mapView = [[MAMapView alloc] init];
    self.mapView.delegate = self;
    
    self.mapView.distanceFilter = kMapDistanceFilter;
    
//    self.mapView.showsUserLocation = YES;
//    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
//    self.mapView.pausesLocationUpdatesAutomatically = NO;
//    self.mapView.allowsBackgroundLocationUpdates = YES;
//    self.mapView.zoomLevel = 1;
}

- (void)setupMapView
{
    // 在viewDidAppear时设定相应的值，提前设置有可能无效。
    self.mapView.zoomLevel = 15.5;
    //    self.mapManager.mapView.userTrackingMode = MAUserTrackingModeFollow;
    //    [self.mapManager.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    
    self.mapView.pausesLocationUpdatesAutomatically = NO;
    self.mapView.allowsBackgroundLocationUpdates = YES;
}

- (void)startLocation
{
    // 开始进行定位
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
}

- (void)endLocation
{
    // 定位结束
    self.mapView.showsUserLocation = NO;
}

- (void)addUpdateRoute
{
    // 通过最近记录的两点添加新的路线
//    NSInteger numberOfCoords = [self.updateRouteCoordArray count];
//    CLLocationCoordinate2D commonPolylineCoords[numberOfCoords];
//    
//    for (NSInteger i = 0; i < numberOfCoords; i++)
//    {
//        YSMapAnnotation *annotation = self.updateRouteCoordArray[i];
//        CLLocationCoordinate2D coordinate = annotation.coordinate;
//        
//        commonPolylineCoords[i].latitude = coordinate.latitude;
//        commonPolylineCoords[i].longitude = coordinate.longitude;
//        
////        [self.mapView setCenterCoordinate:commonPolylineCoords[i]];
//    }
//    
//    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:numberOfCoords];
//    
//    [self.mapView addOverlay:commonPolyline];
//    
//    // 将定位在屏幕正中间显示。
//    [self.mapView setCenterCoordinate:commonPolylineCoords[numberOfCoords - 1] animated:YES];

    
    // 新的路径
    NSInteger newCount = [self.annotationRecordArray count];
    CLLocationCoordinate2D newPolylineCoords[newCount];
    for (NSInteger i = 0; i < newCount; i++)
    {
        YSMapAnnotation *annotation = self.annotationRecordArray[i];
        CLLocationCoordinate2D coordinate = annotation.coordinate;
        
        newPolylineCoords[i].latitude = coordinate.latitude;
        newPolylineCoords[i].longitude = coordinate.longitude;
    }
    
    // 旧的路径
    NSInteger oldCount = [self.annotationRecordArray count] - 1;
    CLLocationCoordinate2D oldPolylineCoords[oldCount];
    for (NSInteger i = 0; i < oldCount; i++)
    {
        YSMapAnnotation *annotation = self.annotationRecordArray[i];
        CLLocationCoordinate2D coordinate = annotation.coordinate;
        
        oldPolylineCoords[i].latitude = coordinate.latitude;
        oldPolylineCoords[i].longitude = coordinate.longitude;
    }
    
    MAPolyline *newPolyline = [MAPolyline polylineWithCoordinates:newPolylineCoords count:newCount];
    MAPolyline *oldPolyline = [MAPolyline polylineWithCoordinates:oldPolylineCoords count:oldCount];
    
    [self.mapView removeOverlay:oldPolyline];
    [self.mapView addOverlay:newPolyline];
    
    [self.mapView setCenterCoordinate:newPolylineCoords[newCount - 1] animated:YES];
}


- (void)testRoute
{
    // 测试代码。随机定位一个坐标
    int latitude = arc4random() % 10;
    int longitude = arc4random() % 10;
    
    CLLocationCoordinate2D coordinate = {22.2 + latitude / 1000.0, 113.5 + longitude / 1000.0};
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

- (CGFloat)getHighestSpeed
{
    return self.hSpeed;
}

- (CGFloat)getLowestSpeed
{
    return self.lSpeed;
}

- (CGFloat)getTotalDistance
{
    return [self getTotalRunningDistance];
}

- (void)addLocationCoordinate:(CLLocationCoordinate2D)coordinate
{
    // 将新位置保存到数组中。
    YSMapAnnotation *annotation = [[YSMapAnnotation alloc] initWithCoordinate:coordinate];
    [self.annotationRecordArray addObject:annotation];
}

- (void)updateRoute
{
    // 更新路径
    NSInteger numberOfCoords = [self.annotationRecordArray count];
    NSInteger requiredCount = 2;    // 需要两点来绘制新的路线
    if (numberOfCoords < requiredCount)
    {
        // 只有初始点
        return;
    }
    
//    self.updateRouteCoordArray = @[self.annotationRecordArray[numberOfCoords - 2], self.annotationRecordArray[numberOfCoords - 1]];
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
    
    NSInteger numberOfCoords = [self.annotationRecordArray count];
    if (numberOfCoords > 1)
    {
        for (NSInteger i = 0; i < numberOfCoords - 1; i++)
        {
            YSMapAnnotation *annotation1 = self.annotationRecordArray[i];
            YSMapAnnotation *annotation2 = self.annotationRecordArray[i + 1];
            
            CGFloat distance = [self distanceBetweenCoordinate1:annotation1.coordinate coordinate2:annotation2.coordinate];
            totalDistance += distance;
        }
    }
    
    return totalDistance;
}

- (void)calculationSpeed
{
    // 每次位置更新都计算最近一段距离内的速度
    NSInteger count = [self.annotationRecordArray count];
    if ((count < 2) || (self.lastLocatedTime < 0))
    {
        return;
    }
    
    YSMapAnnotation *annotation1 = self.annotationRecordArray[count - 1];
    YSMapAnnotation *annotation2 = self.annotationRecordArray[count - 2];
    
    CGFloat distance = [self distanceBetweenCoordinate1:annotation1.coordinate coordinate2:annotation2.coordinate];
    CGFloat time = self.currentLocatedTime - self.lastLocatedTime;
    if (time <= 0)
    {
        return;
    }
    CGFloat speed = distance / time;    // m/s
    
    // 第一次计算速度时未赋值。
    if (self.hSpeed < 0 && self.lSpeed < 0)
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

- (void)updataRunningRecordViewData
{
    // 更新界面显示距离、配速的值
    CGFloat distance = [self getTotalDistance] / 1000; // 公里
    [self.delegate updateDistance:distance];
}

- (void)showAllCoordinate
{
    [self.mapView showAnnotations:self.annotationRecordArray animated:YES];
}

- (NSArray *)getCoordinateRecord
{
    return self.annotationRecordArray;
}

- (UIImage *)getScreenshotImage
{
    // 先将所以路径显示在可视范围内
    [self showAllCoordinate];
    
    // 缩小一定比例，最后只截取中间一部分图。
    CGFloat zoomLevel = self.mapView.zoomLevel;
    zoomLevel *= 0.9;   // 经验值.
    self.mapView.zoomLevel = zoomLevel;
    
    // 路径图在中间显示，高度大概为可视全范围30%。
    CGFloat scale = 0.3;
    CGRect rect = self.mapView.bounds;
    
    CGFloat height = rect.size.height;
    CGFloat imageHeight = height * scale;
    
    rect = CGRectMake(0, (height - imageHeight) / 2 , rect.size.width, imageHeight);
    UIImage *screenshotImage = [self.mapView takeSnapshotInRect:rect];
    
    return screenshotImage;
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
        
//        [self showAllCoordinate];
        
        [self updataRunningRecordViewData];
        
        NSString *message = [NSString stringWithFormat:@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude];
        NSLog(@"%@", message);
        
//        NSString *message = [NSString stringWithFormat:@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude];
//        self.OutputMessageLabel.text = message;
//        
//        int r = arc4random() % 255;
//        int g = arc4random() % 255;
//        int b = arc4random() % 255;
//        
//        UIColor *color = RGB(r, g, b);
//        self.OutputMessageLabel.textColor = color;

    }
    
}

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
    return nil;
}

@end
