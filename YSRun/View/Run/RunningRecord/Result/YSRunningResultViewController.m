//
//  YSRunningResultViewController.m
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSRunningResultViewController.h"
#import "YSResultRecordView.h"
#import "YSAppMacro.h"
#import "YSMapManager.h"
#import "YSRunInfoModel.h"
#import "YSShareFunc.h"
#import "YSMapPaintFunc.h"
#import "YSDataRecordModel.h"
#import "YSHeartRateRecordViewController.h"
#import "YSRunDataRecordViewController.h"
#import "YSModelReformer.h"
#import <MAMapKit/MAMapKit.h>
#import "YSSportRecordViewController.h"

@interface YSRunningResultViewController () <YSResultRecordViewDelegate>

@property (nonatomic, weak) IBOutlet YSResultRecordView *resultRecordView;
//@property (nonatomic, weak) IBOutlet UIButton *returnButton;
//@property (nonatomic, weak) IBOutlet UIButton *shareButton;
@property (nonatomic, weak) IBOutlet UIView *mapContentView;
@property (nonatomic, weak) IBOutlet MAMapView *mapView;

@property (nonatomic, strong) YSMapManager *mapManager;
@property (nonatomic, strong) YSRunInfoModel *runInfoModel;

@property (nonatomic, strong) YSMapPaintFunc *mapPaintFunc;
@property (nonatomic, strong) UIImage *screenshotImage;

@end

@implementation YSRunningResultViewController

- (id)initWithRunData:(YSRunInfoModel *)runInfoModel
{
    self = [super init];
    if (self)
    {
        self.runInfoModel = runInfoModel;
        self.mapPaintFunc = [YSMapPaintFunc new];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupButtons];
    
    [self.resultRecordView setupRecordWith:self.runInfoModel];
    self.resultRecordView.delegate = self;
    
    [self.mapPaintFunc drawPathWithAnnotationArray:self.runInfoModel.locationArray inMapView:self.mapView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.mapPaintFunc drawPathWithAnnotationArray:self.runInfoModel.locationArray inMapView:self.mapView];
//    [self addMapBackgroundImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setupButtons
{
//    self.returnButton.backgroundColor = GreenBackgroundColor;
//    self.returnButton.layer.cornerRadius = ButtonCornerRadius;
//    self.returnButton.clipsToBounds = YES;
    
//    self.shareButton.backgroundColor = GreenBackgroundColor;
//    self.shareButton.layer.cornerRadius = ButtonCornerRadius;
//    self.shareButton.clipsToBounds = YES;
}

//- (void)addMapBackgroundImageView
//{
//    CGSize size = self.mapContentView.bounds.size;
//    
//    self.paint = [YSMapPaintFunc new];
//    self.screenshotImage = [self.paint screenshotWithAnnotationArray:self.runInfoModel.locationArray size:size];
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.screenshotImage];
//    imageView.frame = self.mapContentView.bounds;
//    
//    [self.mapContentView addSubview:imageView];
//    [self.mapContentView sendSubviewToBack:imageView];
//}

- (IBAction)returnButtonClicked:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareButtonClicked:(id)sender
{
    // 分享的回调处理
    ShareFuncCallbackBlock callbackBlock = ^(YSShareFuncResponseState state)
    {
        // 分享成功则返回到主界面
        if (state == YSShareFuncResponseStateSuccess)
        {
            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        }
    };
    
    YSShareInfo *shareInfo = [YSShareInfo defaultShareInfoWithImages:@[self.screenshotImage]];
    [YSShareFunc shareInfo:shareInfo fromView:self.view callbackBlock:callbackBlock];
}

- (IBAction)showDetail:(id)sender
{
    YSSportRecordViewController *sportRecordViewController = [[YSSportRecordViewController alloc] initWithDataRecordModel:[self getRecordModel]];
    [self.navigationController pushViewController:sportRecordViewController animated:YES];
}

- (YSDataRecordModel *)getRecordModel
{
    YSDataRecordModel *recordModel = [YSModelReformer dataRecordModelFromRunInfoModel:self.runInfoModel];
    return recordModel;
}

#pragma mark - YSResultRecordViewDelegate

- (void)showRunDataDetail
{
    YSRunDataRecordViewController *viewController = [[YSRunDataRecordViewController alloc] initWithDataRecordModel:[self getRecordModel]];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showHeartRateDataDetail
{
    YSHeartRateRecordViewController *viewController = [[YSHeartRateRecordViewController alloc] initWithDataRecordModel:[self getRecordModel]];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)resultRecordViewBack
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
