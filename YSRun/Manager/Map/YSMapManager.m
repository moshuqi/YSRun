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
#import "YSMapCalculateFunc.h"
#import "YSCoordinateProcesser.h"

@interface YSMapManager () <MAMapViewDelegate>

@property (nonatomic, strong) NSMutableArray *annotationRecordArray;

@property (nonatomic, assign) CGFloat hSpeed;
@property (nonatomic, assign) CGFloat lSpeed;
@property (nonatomic, assign) CGFloat currentSpeed;

@property (nonatomic, assign) double lastLocatedTime;  // 上一次定位的时间
@property (nonatomic, assign) double currentLocatedTime;   // 当前定位的时间

@property (nonatomic, assign) NSInteger updateuLocationTimes;   // 系统回调更新定位数据的次数
@property (nonatomic, strong) YSCoordinateProcesser *processer;

// 用来记录测试数据
@property (nonatomic, assign) CGFloat calculationDistance;
@property (nonatomic, assign) CGFloat actualCalcutationSpeed;

// 记录上次和当前的定位未处理过的点，用来计算当前速度
@property (nonatomic, assign) CLLocationCoordinate2D lastLocationCoordinate;
@property (nonatomic, assign) CLLocationCoordinate2D currentLocationCoordinate;

@end

@implementation YSMapManager

static const double kMapDistanceFilter = 3.0;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.annotationRecordArray = [NSMutableArray array];
        [self initMap];
        
        // 初始化，之后通过是否大于0来判断有没有赋值
        self.lastLocatedTime = -1;
        self.currentLocatedTime = -1;
        
        self.hSpeed = -1;
        self.lSpeed = -1;
        self.currentSpeed = 0;
        
        self.updateuLocationTimes = 0;
        self.processer = [YSCoordinateProcesser new];
        
        [self setupTestLabel];
    }
    
    return self;
}

- (void)initMap
{
//    [MAMapServices sharedServices].apiKey = (NSString *)MapAPIKey;
    
    self.mapView = [[MAMapView alloc] init];
    self.mapView.delegate = self;
    
    self.mapView.distanceFilter = kMapDistanceFilter;
}

- (void)setupMapView
{
    // 在viewDidAppear时设定相应的值，提前设置有可能无效。
    self.mapView.zoomLevel = 15.5;
    
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
    // 先移除之前绘制的路径
    [YSMapCalculateFunc addAnnotationArray:self.annotationRecordArray toMapView:self.mapView];
    [self removePreviousRoute];
    
    // 绘制最新的路径
    YSMapAnnotation *annotation = [self.annotationRecordArray lastObject];
    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
}

- (void)removePreviousRoute
{
    NSArray *overlays = self.mapView.overlays;
    NSInteger count = [overlays count];
    
    NSInteger requireNumber = 1;    // 只需要1条路径来展示线路。
    if (count > requireNumber)
    {
        NSRange range = {0, count - requireNumber};
        NSArray *subOverlays = [overlays subarrayWithRange:range];
        [self.mapView removeOverlays:subOverlays];
    }
}

- (void)testRoute
{
//    // 测试代码。随机定位一个坐标
//    int latitude = arc4random() % 10;
//    int longitude = arc4random() % 10;
//    
//    CLLocationCoordinate2D coordinate = {22.2 + latitude / 1000.0, 113.5 + longitude / 1000.0};
//    [self addLocationCoordinate:coordinate];
//    [self updateRoute];
    
    // 测试代码，移除所有路径
    NSArray *overlays = self.mapView.overlays;
    [self.mapView removeOverlays:overlays];
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
    return [YSMapCalculateFunc totalDistance:self.annotationRecordArray];
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
    
    [self addUpdateRoute];
}

- (void)updateSpeed:(CGFloat)speed
{
    // 防止把最低速度赋值为0
    if (speed <= 0.01)
    {
        return;
    }
    
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

- (NSArray *)getCoordinateRecord
{
    return self.annotationRecordArray;
}

- (void)updateSpeedWithNewCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    // 每次定位更新时调用，更新时间和位置，计算当前速度
    
    // 上次定位和本次定位的时间
    self.lastLocatedTime = self.currentLocatedTime;
    self.currentLocatedTime = CFAbsoluteTimeGetCurrent();
    
    // 上次定位和本次定位的坐标
    self.lastLocationCoordinate = self.currentLocationCoordinate;
    self.currentLocationCoordinate = newCoordinate;
    
    double timeInterval = (self.currentLocatedTime - self.lastLocatedTime);
    if (timeInterval <= 0.01)
    {
        return;
    }
    
    CGFloat distance = [YSMapCalculateFunc distanceBetweenCoordinate1:self.lastLocationCoordinate coordinate2:self.currentLocationCoordinate];
    self.calculationDistance = distance;
    if (distance > 3000)
    {
        // 距离大于一定距离可当做定位出错，或者self.lastLocationCoordinate未赋值
        return;
    }
    
    self.currentSpeed = distance / timeInterval;    // m/s
    self.actualCalcutationSpeed = self.currentSpeed;
    
    // 防止因为定位漂移产生的速度过大，当速度大于一定值时做特殊处理
    if (self.currentSpeed > 50)
    {
        self.currentSpeed = 5;
    }
    
    [self updateSpeed:self.currentSpeed];
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        // 定位刚开始的几个点比较飘，忽略掉
        self.updateuLocationTimes++;
        NSInteger ignoreTimes = 5;
        if (self.updateuLocationTimes <= ignoreTimes)
        {
            return;
        }
        
        // 滤波在处理慢速运行时，会出现路径端点与定位点连接不上的情况，所以在绘制路径时，将未处理过的当前点添加到数组的末尾，每次有新位置进行计算时，先将上一次数组末尾的点移除。
        if ([self.annotationRecordArray count] > 0)
        {
            [self.annotationRecordArray removeLastObject];
        }
        
        // 本次定位坐标
        CLLocationCoordinate2D coordinate = userLocation.coordinate;
        
        // 计算当前速度，最快、最慢速度。
        [self updateSpeedWithNewCoordinate:coordinate];
        
        // 滤波算法处理后的坐标
        CLLocationCoordinate2D filteredCoordinate = [self.processer processWithCoordinate:coordinate speed:self.currentSpeed timestamp:self.currentLocatedTime];
        
        [self addLocationCoordinate:filteredCoordinate];
        [self addLocationCoordinate:coordinate];
        [self updateRoute];
        
        [self updataRunningRecordViewData];
        
//        [self testMessageWithSpeed:self.currentSpeed];
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

#pragma mark - test code

- (void)testMessageWithSpeed:(CGFloat)speed;
{
//    YSMapAnnotation *annotation = [self.annotationRecordArray lastObject];
//    CLLocationCoordinate2D coordinate = annotation.coordinate;
    
//    NSString *locationStr = [NSString stringWithFormat:@"latitude : %f,longitude: %f",
//                             coordinate.latitude, coordinate.longitude];
    
    NSString *speedStr = [NSString stringWithFormat:@"最快速度: %.3f, 最慢速度: %.3f", self.hSpeed, self.lSpeed];
    
//    NSString *timeStr = [NSString stringWithFormat:@"上次定位时间: %f\n本次定位时间: %f", self.lastLocatedTime, self.currentLocatedTime];
    
    NSString *timeIntervalStr = [NSString stringWithFormat:@"定位时间间隔: %f", (self.currentLocatedTime - self.lastLocatedTime)];
    
    NSString *currentSpeedStr = [NSString stringWithFormat:@"当前速度: %.3f", speed];
    
    NSString *distanceStr = [NSString stringWithFormat:@"计算的距离: %.4f", self.calculationDistance];
    NSString *actualSpeedStr = [NSString stringWithFormat:@"计算的速度: %f", self.actualCalcutationSpeed];
    
    NSString *accuracyStr = [NSString stringWithFormat:@"定位精度: %f", self.mapView.desiredAccuracy];
    
    NSString *outputMessage = [NSString stringWithFormat:@"%@\n\n%@\n%@\n\n%@\n%@\n\n%@", speedStr, timeIntervalStr, distanceStr, currentSpeedStr,actualSpeedStr, accuracyStr];
    NSLog(@"%@", outputMessage);
    
    if ([self.testLabel superview])
    {
//        int r = arc4random() % 255;
//        int g = arc4random() % 255;
//        int b = arc4random() % 255;
//        UIColor *color = RGB(r, g, b);
        
        self.testLabel.text = outputMessage;
        self.testLabel.textColor = [UIColor redColor];
    }
}

- (void)setupTestLabel
{
    self.testLabel = [[UILabel alloc] init];
    self.testLabel.font = [UIFont systemFontOfSize:18];
    self.testLabel.textAlignment = NSTextAlignmentCenter;
    self.testLabel.adjustsFontSizeToFitWidth = YES;
    self.testLabel.numberOfLines = 0;
}

@end
