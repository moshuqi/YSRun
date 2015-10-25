//
//  YSRunningRecordViewController.m
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSRunningRecordViewController.h"
#import "YSRunningGeneralModeView.h"
#import "YSRunningMapModeView.h"
#import "YSRunningResultViewController.h"
#import "YSTimeManager.h"
#import "YSCountdownView.h"
#import "YSRunInfoModel.h"
//#import "NSDate+YSDateLogic.h"

@interface YSRunningRecordViewController () <YSRunningModeViewDelegate, YSTimeManagerDelegate, YSCountdownViewDelegate>

@property (nonatomic, strong) YSRunningGeneralModeView *runningGeneralModeView;
@property (nonatomic, strong) YSRunningMapModeView *runningMapModeView;
@property (nonatomic, strong) YSRunningModeView *currentModeView;
@property (nonatomic, strong) YSCountdownView *countdownView;

@property (nonatomic, strong) YSTimeManager *timeManager;
@property (nonatomic, strong) YSRunInfoModel *runInfoModel;

@end

@implementation YSRunningRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addSubviews];
    [self initTimeManager];
    
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)addSubviews
{
    self.countdownView = [YSCountdownView new];
    self.countdownView.delegate = self;
    
    [self.view addSubview:self.countdownView];
    
    [self addModeView];
}

- (void)addModeView
{
    self.runningGeneralModeView = [[YSRunningGeneralModeView alloc] init];
    self.runningGeneralModeView.delegate = self;
    [self.view addSubview:self.runningGeneralModeView];
    
    self.runningMapModeView = [[YSRunningMapModeView alloc] init];
    self.runningMapModeView.delegate = self;
    [self.view addSubview:self.runningMapModeView];
    
    self.currentModeView = self.runningGeneralModeView;
    [self.view bringSubviewToFront:self.currentModeView];
}

- (void)initTimeManager
{
    self.timeManager = [YSTimeManager new];
    self.timeManager.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.countdownView startCountdownWithTime:3];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.runningGeneralModeView resetLayoutWithFrame:[self getModeViewFrame]];
    [self.runningMapModeView resetLayoutWithFrame:[self getModeViewFrame]];
    
    self.countdownView.frame = self.view.bounds;
    [self.view bringSubviewToFront:self.countdownView];
}

- (CGRect)getModeViewFrame
{
    CGFloat originY = 20;
    CGRect frame = CGRectMake(0, originY, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - originY);
    
    return frame;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startRun
{
    [self.timeManager start];
    
    NSDate *date = [NSDate date];
    
    self.runInfoModel = [YSRunInfoModel new];
    self.runInfoModel.startTime = [date timeIntervalSince1970];
    self.runInfoModel.date = date;
}

#pragma mark - YSRunningModeViewDelegate

- (void)changeMode
{
    BOOL isPause = self.currentModeView.isPause;
    if ([self.currentModeView isKindOfClass:[YSRunningGeneralModeView class]])
    {
        self.currentModeView = self.runningMapModeView;
    }
    else
    {
        self.currentModeView = self.runningGeneralModeView;
    }
    
    self.currentModeView.isPause = isPause;
    [self.currentModeView resetButtonsPositionWithPauseStatus];
    [self.view bringSubviewToFront:self.currentModeView];
}

- (void)runningPause
{
    [self.timeManager pause];
}

- (void)runningContinue
{
    [self.timeManager start];
}

- (void)runningFinish
{
    NSDate *date = [NSDate date];
    
    self.runInfoModel.endTime = [date timeIntervalSince1970];
    self.runInfoModel.useTime = [self.timeManager getTotalTime];
    
    YSRunningResultViewController *resultViewController = [YSRunningResultViewController new];
    [self.navigationController pushViewController:resultViewController animated:YES];
}

#pragma mark - YSTimeManagerDelegate

- (void)tickWithAccumulatedTime:(NSUInteger)time
{
    [self.runningGeneralModeView resetTimeLabelWithTime:time];
    [self.runningMapModeView resetTimeLabelWithTime:time];
}

#pragma mark - YSCountdownViewDelegate

- (void)countdownFinish
{
    [self startRun];
}

@end
