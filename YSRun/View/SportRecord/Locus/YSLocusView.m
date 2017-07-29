//
//  YSLocusView.m
//  YSRun
//
//  Created by moshuqi on 16/1/25.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSLocusView.h"
#import <MAMapKit/MAMapKit.h>
#import "YSLocusTimeLabelView.h"
#import "YSLocusDataLabelView.h"
#import "YSAppMacro.h"
#import "YSMapPaintFunc.h"
#import "YSDataRecordModel.h"

@interface YSLocusView ()

@property (nonatomic, weak) IBOutlet YSLocusTimeLabelView *timeLabel;
@property (nonatomic, weak) IBOutlet YSLocusDataLabelView *dataLabel;
@property (nonatomic, weak) IBOutlet MAMapView *mapView;
@property (nonatomic, weak) IBOutlet UIButton *privacyButton;
@property (nonatomic, weak) IBOutlet UIButton *locationButton;

@property (nonatomic, strong) YSMapPaintFunc *paintFunc;
@property (nonatomic, strong) YSDataRecordModel *dataRecordModel;

@property (nonatomic, assign) BOOL bShowMap;    // 默认显示地图
@property (nonatomic, strong) UIView *privacyMaskView;  // 隐藏地图时显示的灰色界面

@end

@implementation YSLocusView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.bShowMap = YES;
    }
    
    return self;
}

- (void)awakeFromNib
{
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    
    self.bShowMap = YES;
    
    // 隐藏掉地图只显示路径不好做，暂时先隐藏掉按钮
    self.privacyButton.hidden = YES;
}

- (void)setupWithDataRecordModel:(YSDataRecordModel *)dataRecordModel
{
    self.dataRecordModel = dataRecordModel;
    
    // 绘制地图路径
    self.paintFunc = [YSMapPaintFunc new];
    [self.paintFunc drawPathWithAnnotationArray:dataRecordModel.locationArray inMapView:self.mapView];
    
    // 日期时间
    [self.timeLabel setupWithTimestamp:dataRecordModel.startTime];
    
    // 距离和时间标签
    [self.dataLabel setupWithDistance:(dataRecordModel.distance / 1000) useTime:(dataRecordModel.endTime - dataRecordModel.startTime)];
}

- (IBAction)clickPrivacyButton:(id)sender
{
    // 开启隐私时，隐藏地图具体信息，显示灰色背景
    
    self.bShowMap = !self.bShowMap;
    
    [self viewChangeWithMapState:self.bShowMap];
}

- (IBAction)clickLocationButton:(id)sender
{
    // 将路径信息完全显示在可视范围内
    [self.mapView showAnnotations:self.dataRecordModel.locationArray animated:YES];
}

- (void)viewChangeWithMapState:(BOOL)bShowMap
{
    if (bShowMap)
    {
        // 显示地图，移除遮罩界面
        [self.privacyMaskView removeFromSuperview];
        self.privacyMaskView = nil;
    }
    else
    {
        // 隐藏地图，显示灰色界面遮住地图
        if ([self.privacyMaskView superview])
        {
            [self.privacyMaskView removeFromSuperview];
            self.privacyMaskView = nil;
        }
        
        self.privacyMaskView = [UIView new];
        self.privacyMaskView.backgroundColor = [UIColor grayColor];
        self.privacyMaskView.frame = self.mapView.frame;
        
        [self addSubview:self.privacyMaskView];
        [self insertSubview:self.privacyMaskView aboveSubview:self.mapView];
        
//        // 将地图路径图添加到遮罩视图上
//        NSArray *overlays = self.mapView.overlays;
//        for (id <MAOverlay> overlay in overlays)
//        {
//            if ([overlay isKindOfClass:[MAPolyline class]])
//            {
//                MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
//                
//                [self.privacyMaskView addSubview:polylineView];
//            }
//        }
    }
}

- (UIImage *)getMapScreenShot
{
    CGRect rect = self.mapView.bounds;
    UIImage *screenshot = [self.mapView takeSnapshotInRect:rect];
    
    return screenshot;
}

@end
