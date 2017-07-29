//
//  YSSportRecordViewController.m
//  YSRun
//
//  Created by moshuqi on 16/1/21.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSSportRecordViewController.h"
#import "HTHorizontalSelectionList.h"
#import "YSNavigationBarView.h"
#import "YSAppMacro.h"
#import "YSDetailDataView.h"
#import "YSHeartRateDataView.h"
#import "YSLocusView.h"
#import "YSPaceView.h"
#import "YSDataRecordModel.h"
#import "YSNoHeartRateDataView.h"
#import "YSShareViewController.h"
#import "YSMapAnnotation.h"
#import "YSShareFunc.h"

typedef NS_ENUM(NSInteger, YSSportRecordType)
{
    YSSportRecordTypeLocus = 0,
    YSSportRecordTypeDetail = 1,
    YSSportRecordTypePace = 2,
    YSSportRecordTypeHeartRate = 3
};

@interface YSSportRecordViewController () <HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource>

@property (nonatomic, weak) IBOutlet HTHorizontalSelectionList *selectionList;
@property (nonatomic, weak) IBOutlet YSNavigationBarView *navigationBarView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, strong) NSArray *contentList;
@property (nonatomic, assign) YSSportRecordType *currentType;
@property (nonatomic, strong) YSDataRecordModel *dataRecordModel;

@property (nonatomic, strong) YSLocusView *locusView;
@property (nonatomic, strong) YSDetailDataView *detailDataView;
@property (nonatomic, strong) YSPaceView *paceView;

@property (nonatomic, strong) UIView *heartRateView;    // 根据是否有心率数据显示对应视图

@end

@implementation YSSportRecordViewController

- (id)initWithDataRecordModel:(YSDataRecordModel *)dataRecordModel
{
    self = [super init];
    if (self)
    {
        self.dataRecordModel = dataRecordModel;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = YES; 
    
    [self.navigationBarView setupWithTitle:@"运动记录" target:self action:@selector(viewBack)];
    
    // 本地安装有对应客户端才显示分享按钮
    if ([YSShareFunc hasClientInstalled])
    {
        UIImage *shareImage = [UIImage imageNamed:@"heart_rate_share"];
        [self.navigationBarView setRightButtonWithImage:shareImage target:self action:@selector(shareButtonClicked:)];
    }
    
    self.selectionList.delegate = self;
    self.selectionList.dataSource = self;
    self.selectionList.selectionIndicatorColor = GreenBackgroundColor;

    self.contentList = @[@(YSSportRecordTypeLocus), @(YSSportRecordTypeDetail),
                         @(YSSportRecordTypePace), @(YSSportRecordTypeHeartRate)];
    
    [self setupViews];
    
    // 第一次进入时默认显示路径视图
    [self showContentViewWithType:YSSportRecordTypeLocus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
//    if ([self.heartRateView isKindOfClass:[YSHeartRateDataView class]])
//    {
//        [(YSHeartRateDataView *)self.heartRateView showPercentValue];
//    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewBack
{
    if (self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)shareButtonClicked:(id)sender
{
    UIImage *mapImage = [self.locusView getMapScreenShot];
    YSShareViewController *shareViewController = [[YSShareViewController alloc] initWithDataRecordModel:self.dataRecordModel mapImage:mapImage];
    
    [self presentViewController:shareViewController animated:YES completion:nil];
}

- (void)setupViews
{
    // 初始化每个视图
    self.locusView = [[[UINib nibWithNibName:@"YSLocusView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self.locusView setupWithDataRecordModel:self.dataRecordModel];
    
    self.detailDataView = [[[UINib nibWithNibName:@"YSDetailDataView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self.detailDataView setupWithDataRecordModel:self.dataRecordModel];
    
    self.paceView = [[[UINib nibWithNibName:@"YSPaceView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self.paceView setupWithDataRecordModel:self.dataRecordModel];
    
    // 心率界面
    if ([self.dataRecordModel.heartRateArray count] > 0)
    {
        self.heartRateView = [[[UINib nibWithNibName:@"YSHeartRateDataView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        [(YSHeartRateDataView *)self.heartRateView setupWithDataRecordModel:self.dataRecordModel];
    }
    else
    {
        self.heartRateView = [[[UINib nibWithNibName:@"YSNoHeartRateDataView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    }
    
    [self.contentView addSubview:self.locusView];
    [self.contentView addSubview:self.detailDataView];
    [self.contentView addSubview:self.paceView];
    [self.contentView addSubview:self.heartRateView];
}

- (NSString *)getStringWithSportRecordType:(YSSportRecordType)type
{
    NSString *string = nil;
    switch (type)
    {
        case YSSportRecordTypeLocus: // 轨迹
            string = @"轨迹";
            break;
            
        case YSSportRecordTypeDetail: // 详情
            string = @"详情";
            break;
            
        case YSSportRecordTypePace: // 配速
            string = @"配速";
            break;
            
        case YSSportRecordTypeHeartRate: // 心率
            string = @"心率";
            break;
            
        default:
            break;
    }
    
    return string;
}

- (void)showContentViewWithType:(YSSportRecordType)type
{
    UIView *view = nil;
    switch (type)
    {
        case YSSportRecordTypeLocus: // 轨迹
            view = self.locusView;
            break;
            
        case YSSportRecordTypeDetail: // 详情
            view = self.detailDataView;
            break;
            
        case YSSportRecordTypePace: // 配速
            view = self.paceView;
            break;
            
        case YSSportRecordTypeHeartRate: // 心率
            view = self.heartRateView;
            break;
            
        default:
            break;
    }
    
    view.frame = self.contentView.bounds;
    [self.contentView bringSubviewToFront:view];
}

- (void)didSelectedViewType:(YSSportRecordType)type
{
    [self showContentViewWithType:type];
}

#pragma mark - HTHorizontalSelectionListDataSource

- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList
{
    return self.contentList.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index
{
    YSSportRecordType type = (YSSportRecordType)[self.contentList[index] integerValue];
    NSString *title = [self getStringWithSportRecordType:type];
    
    return title;
}

#pragma mark - HTHorizontalSelectionListDelegate

- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index
{
    YSSportRecordType type = (YSSportRecordType)[self.contentList[index] integerValue];
    [self didSelectedViewType:type];
}

@end
