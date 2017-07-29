//
//  KalmanTestViewController.m
//  YSRun
//
//  Created by moshuqi on 16/1/14.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "KalmanTestViewController.h"
#import "KalmanFilter.h"
#import "LocationData.h"
#import "YSNavigationBarView.h"
#import "YSDataRecordModel.h"
#import <MAMapKit/MAMapKit.h>
#import "YSAppMacro.h"
#import "YSMapAnnotation.h"

@interface KalmanTestViewController () <MAMapViewDelegate>

@property (nonatomic, weak) IBOutlet YSNavigationBarView *navigationBar;
@property (nonatomic, weak) IBOutlet MAMapView *mapView;

@property (nonatomic, strong) YSDataRecordModel *dataRecordModel;
@property (nonatomic, strong) UIColor *pathColor;

@end

@implementation KalmanTestViewController

- (id)initWithDataRecordModel:(YSDataRecordModel *)dataRecordModel
{
    self = [super init];
    if (self)
    {
        self.dataRecordModel = dataRecordModel;
        self.pathColor = GreenBackgroundColor;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationBar setupWithTitle:@"Kalman" barBackgroundColor:GreenBackgroundColor target:self action:@selector(viewBack)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupMapView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self drawPath];
}

- (void)setupMapView
{
    self.mapView.delegate = self;
    self.mapView.zoomLevel = 15.5;
    
    self.mapView.pausesLocationUpdatesAutomatically = NO;
    self.mapView.allowsBackgroundLocationUpdates = YES;
    
//    self.mapView.showsUserLocation = YES;
//    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)drawPath
{
    [self drawKalmanPath];
    [self drawActualPath];
}

- (void)drawKalmanPath
{
    NSArray *annotationArray = [self filterWithLocationArray:self.dataRecordModel.locationArray];
    self.pathColor = [UIColor redColor];
    
    [self drawPathWithAnnotationArray:annotationArray];
}

- (void)drawActualPath
{
    self.pathColor = GreenBackgroundColor;
    [self drawPathWithAnnotationArray:self.dataRecordModel.locationArray];
}

- (void)drawPathWithAnnotationArray:(NSArray *)annotationArray
{
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
    [self.mapView addOverlay:commonPolyline];
    
    [self.mapView showAnnotations:annotationArray animated:NO];
}

- (NSArray *)filterWithLocationArray:(NSArray *)locationArray
{
    NSMutableArray *filteredArray = [NSMutableArray array];
    KalmanFilter *kalmanFilter = [KalmanFilter new];
    
    NSInteger timestamp = 1452760581;
    NSInteger detal = 3;
    
    for (YSMapAnnotation *annotation in locationArray)
    {
        CLLocationCoordinate2D coordinate = annotation.coordinate;
        LocationData *locationData = [[LocationData alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude speed:3 timestamp:timestamp];
        timestamp += detal;
        
        [kalmanFilter locationUpdate:locationData];
        LocationData *newLocationData = [kalmanFilter getFilteredLocationData];
        
        if (newLocationData)
        {
            CLLocationCoordinate2D newCoordinate = {newLocationData.getLatitude, newLocationData.getLongitude};
            YSMapAnnotation *newAnnotation = [[YSMapAnnotation alloc] initWithCoordinate:newCoordinate];
            
            [filteredArray addObject:newAnnotation];
        }
    }
    
    return filteredArray;
}

#pragma mark - MAMapViewDelegate

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth = 4.f;
        
        if (!self.pathColor)
        {
            self.pathColor = GreenBackgroundColor;
        }
        polylineView.strokeColor = self.pathColor;
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
