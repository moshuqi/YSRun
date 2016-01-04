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
#import "YSMapManager.h"
#import "YSDatabaseManager.h"
#import "YSDataManager.h"
#import "YSModelReformer.h"
#import "YSRunDatabaseModel.h"
#import "YSUtilsMacro.h"
#import "YSBluetoothConnect.h"
#import "YSRunDataHandler.h"
#import "YSHeartRateDataManager.h"
#import "YSVoicePrompt.h"
#import "YSConfigManager.h"

typedef NS_ENUM(NSInteger, RunningState) {
    RunningStateNone = 0,
    RunningStateStart,
    RunningStateEnd
};

@interface YSRunningRecordViewController () <YSRunningModeViewDelegate, YSTimeManagerDelegate, YSCountdownViewDelegate>

@property (nonatomic, strong) YSRunningGeneralModeView *runningGeneralModeView;
@property (nonatomic, strong) YSRunningMapModeView *runningMapModeView;
@property (nonatomic, strong) YSRunningModeView *currentModeView;
@property (nonatomic, strong) YSCountdownView *countdownView;

@property (nonatomic, strong) YSTimeManager *timeManager;
@property (nonatomic, strong) YSRunInfoModel *runInfoModel;
@property (nonatomic, strong) YSRunDataHandler *runDataHandler;

@property (nonatomic, strong) YSHeartRateDataManager *heartRateManager;
@property (nonatomic, strong) YSVoicePrompt *voicePrompt;

@property (nonatomic, assign) dispatch_once_t onceDispatch;

@end

@implementation YSRunningRecordViewController

- (void)dealloc
{
    [[YSBluetoothConnect shareBluetoothConnect] removeHeartRateObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addSubviews];
    [self initTimeManager];
    
    self.navigationController.navigationBarHidden = YES;
    
    YSBluetoothConnect *bluetoothConnect = [YSBluetoothConnect shareBluetoothConnect];
    [bluetoothConnect addHeartRateObserver:self];
    
    self.runDataHandler = [YSRunDataHandler new];
    self.heartRateManager = [YSHeartRateDataManager new];
    
    self.voicePrompt = [YSVoicePrompt new];
    [self.voicePrompt setPeripheralsConnectState:[bluetoothConnect hasConnectPeripheral]];
    
    // 设置声音提示类型
    YSVoicePromptType voiceType = [YSConfigManager voicePromptType];
    [self.voicePrompt setVoicePromptType:voiceType];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
    
    [self.countdownView startAnimationCountdownWithTime:3];
    
    [self.runningMapModeView setupMap];
}

//- (void)viewWillLayoutSubviews
//{
//    [super viewWillLayoutSubviews];
//    [self.runningGeneralModeView resetLayoutWithFrame:[self getModeViewFrame]];
//    [self.runningMapModeView resetLayoutWithFrame:[self getModeViewFrame]];
//    
//    self.countdownView.frame = self.view.bounds;
//    [self.view bringSubviewToFront:self.countdownView];
//}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // 子视图的设置只需要设置一次，否则会导致拖动下拉按钮位置闪烁的问题。
    dispatch_once(&_onceDispatch, ^{
        [self.runningGeneralModeView resetLayoutWithFrame:[self getModeViewFrame]];
        [self.runningMapModeView resetLayoutWithFrame:[self getModeViewFrame]];
        
        self.countdownView.frame = self.view.bounds;
        [self.view bringSubviewToFront:self.countdownView];
    });
}

- (CGRect)getModeViewFrame
{
    CGFloat originY = 0;
    CGRect frame = CGRectMake(0, originY, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - originY);
    
    return frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startRun
{
    [self.timeManager start];
    
    [self setupRunningInfoWithState:RunningStateStart];
    [self.runningMapModeView mapLocation];
}

- (void)setupRunningInfoWithState:(RunningState)state
{
    // 记录跑步信息
    NSDate *date = [NSDate date];
    if (state == RunningStateStart)
    {
        self.runInfoModel = [YSRunInfoModel new];
        self.runInfoModel.beginTime = [date timeIntervalSince1970];
        self.runInfoModel.date = date;
        self.runInfoModel.uid = [[YSDataManager shareDataManager] getUid];
    }
    else if (state == RunningStateEnd)
    {
        self.runInfoModel.endTime = [date timeIntervalSince1970];
        self.runInfoModel.useTime = [self.timeManager getTotalTime];
        
        YSMapManager *mapManager = [self.runningMapModeView getMapManager];
        self.runInfoModel.locationArray = [mapManager getCoordinateRecord];
        
//        YSBluetoothConnect *bluetoothConnect = [YSBluetoothConnect shareBluetoothConnect];
//        self.runInfoModel.heartRateArray = [bluetoothConnect getHeartRateData];
        
        // 随机生成心率数据的测试代码
//        NSArray *testArray = [self testHeartRateData];
//        for (id obj in testArray)
//        {
//            NSInteger heartRate = [obj integerValue];
//            [self.heartRateManager addHeartRate:heartRate];
//        }
        
        self.runInfoModel.heartRateArray = [self.heartRateManager getHeartRateDataArray];
        
        self.runInfoModel.pace = 0;
        CGFloat distance = [mapManager getTotalDistance];
        if (distance > 0)
        {
            self.runInfoModel.pace = (self.runInfoModel.useTime / 60) / (distance / 1000); // 分钟/公里
        }
        
        self.runInfoModel.hSpeed = [mapManager getHighestSpeed];
        self.runInfoModel.lSpeed = [mapManager getLowestSpeed];
        
        self.runInfoModel.distance = distance;
        self.runInfoModel.speed = (CGFloat)distance / self.runInfoModel.useTime;
        
        NSInteger star = [self evaluateStarWithDistance:distance useTime:self.runInfoModel.useTime speed:self.runInfoModel.speed];
        self.runInfoModel.star = star;
    }
}

- (NSArray *)testHeartRateData
{
    NSInteger from = 60;
    NSInteger to = 220;
    
    NSMutableArray *heartRateArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 600; i++)
    {
        NSInteger value = (NSInteger)(from + (arc4random() % (to - from + 1)));
        [heartRateArray addObject:[NSNumber numberWithInteger:value]];
    }
    
    return heartRateArray;
}

- (NSInteger)evaluateStarWithDistance:(CGFloat)distance useTime:(NSInteger)useTime speed:(CGFloat)speed
{
    // 评分规则：依次判断 距离大于0 ★；运动时间大于40分钟 ★★；速度在3~6km/s之间 ★★★
    NSInteger star = 0;
    if (distance > 0)
    {
        star ++;
        // usetime为秒。
        if ((useTime / 60) > 40)
        {
            star ++;
            if ((speed >= 3) && (speed <= 6))
            {
                star ++;
            }
        }
    }
    
    return star;
}

- (void)recordRunData
{
    // 完成后记录本次跑步的数据
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(){
        YSRunDatabaseModel *runDatabaseModel = [YSModelReformer runDatabaseModelFromRunInfoModel:self.runInfoModel];
        [self.runDataHandler recordSingleRunData:runDatabaseModel];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
           // 跑步数据保存到本地后，日历界面刷新以显示最新的数据
            [self.delegate runningRecordFinish];
        });
    });
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:YSBluetoothConnectHeartRateKey])
    {
        // 监听心率
        NSInteger heartRate = [[change valueForKey:@"new"] integerValue];
        [self.runningGeneralModeView setHeartRate:heartRate];
        [self.runningMapModeView setHeartRate:heartRate];
        
        // 将每一次心率保存到
        [self.heartRateManager addHeartRate:heartRate];
        
        // 语音心率提示。
        YSMapManager *mapManager = [self.runningMapModeView getMapManager];
        CGFloat distance = [mapManager getTotalDistance] / 1000;
        [self voicePromptWithHeartRate:heartRate distance:distance];
    }
}

- (void)voicePromptWithHeartRate:(NSInteger)heartRate distance:(CGFloat)distance
{
    [self.voicePrompt updateWithHeartRate:heartRate distance:distance time:0];
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
    [self setupRunningInfoWithState:RunningStateEnd];
    
    YSMapManager *mapManager = [self.runningMapModeView getMapManager];
    [mapManager endLocation];
//    UIImage *image = [mapManager getScreenshotImage];
    
    [self recordRunData];
    
    YSRunningResultViewController *resultViewController = [[YSRunningResultViewController alloc] initWithRunData:self.runInfoModel];
    [self.navigationController pushViewController:resultViewController animated:YES];
}

- (void)resetDistanceLabel:(CGFloat)distance
{
    CGFloat pace = 0;
    
    // distance单位为公里，刚开始位置有小距离波动，大于一定距离时才进行配速计算，否则配速得到的值会很大
    if (distance > 0.2)
    {
        CGFloat min = (CGFloat)[self.timeManager currentAccumulatedTime] / 60;
        pace = (1 / distance) * min;
    }
    
    [self.runningMapModeView setPace:pace];
    [self.runningMapModeView setDistance:distance];
    
    [self.runningGeneralModeView setPace:pace];
    [self.runningGeneralModeView setDistance:distance];
    
    // 若未连接蓝牙设备，则通过这里进行语音提示。
    if (![[YSBluetoothConnect shareBluetoothConnect] hasConnectPeripheral])
    {
        [self voicePromptWithHeartRate:0 distance:distance];
    }
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
