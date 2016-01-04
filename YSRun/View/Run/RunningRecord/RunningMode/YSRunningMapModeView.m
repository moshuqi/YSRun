//
//  YSRunningMapModeView.m
//  YSRun
//
//  Created by moshuqi on 15/10/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSRunningMapModeView.h"
#import "YSMapManager.h"
#import "YSAppMacro.h"
#import "YSAppUIDefine.h"

@interface YSRunningMapModeView () <YSMapManagerDelegate>

@property (nonatomic, strong) YSMapManager *mapManager;
@property (nonatomic, strong) UIButton *testButton;

@end

static const CGFloat kDistanceLabelMargin = 10; // 公里标签距离屏幕左边缘的间距

@implementation YSRunningMapModeView

- (void)addBackView
{
    if (!self.mapManager)
    {
        self.mapManager = [[YSMapManager alloc] init];
        self.mapManager.delegate = self;
        self.mapManager.mapView.frame = self.bounds;
        
        [self addSubview:self.mapManager.mapView];
        [self sendSubviewToBack:self.mapManager.mapView];
        
        // 在地图上蒙上透明灰色
        UIView *maskView = [[UIView alloc] initWithFrame:self.bounds];
        maskView.userInteractionEnabled = NO;
        maskView.backgroundColor = RGBA(0, 0, 0, 0.3);
        
        [self insertSubview:maskView aboveSubview:self.mapManager.mapView];
    }
    
    if (!self.testButton)
    {
        self.testButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.testButton.backgroundColor = GreenBackgroundColor;
        [self.testButton setTitle:@"Duang!" forState:UIControlStateNormal];
        [self.testButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        CGFloat w = 99;
        CGFloat d = 20;
        CGRect frame = CGRectMake((CGRectGetWidth(self.frame) - w - d), d, w, w);
        
        self.testButton.frame = frame;
        self.testButton.layer.cornerRadius = w / 2;
//        [self addSubview:self.testButton];
        
        [self.testButton addTarget:self action:@selector(testFunc) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (![self.mapManager.OutputMessageLabel superview])
    {
        CGFloat height = 180;
        CGRect frame = CGRectMake(0, (CGRectGetHeight(self.frame) - height) / 2, CGRectGetWidth(self.frame), height);
        self.mapManager.OutputMessageLabel.frame = frame;
//        [self addSubview:self.mapManager.OutputMessageLabel];
    }
}

- (void)testFunc
{
    [self.mapManager testRoute];
}

- (YSMapManager *)getMapManager
{
    return self.mapManager;
}

- (void)setupMap
{
    [self.mapManager setupMapView];
}

- (void)mapLocation
{
    [self.mapManager startLocation];
}

- (void)setupLabelsAppearance
{
    UIImage *modeImage = [UIImage imageNamed:@"run_mode.png"];
    [self.modeStatusView setModeIconWithImage:modeImage modeName:@"跑步模式"];
    
    [self.timeLabel setBoldWithFontSize:[self timeLabelFontSize]];
    
    [self setContentFontSize:28 subscriptFontSize:10];
}

- (void)resetLayoutWithFrame:(CGRect)frame
{
    [super resetLayoutWithFrame:frame];
    [self.pulldownView setAppearanceWithType:YSPulldownTypeMapMode];
}

- (CGRect)getModeStatusViewFrame
{
    CGFloat originX = 15;
    CGFloat originY = 25;
    CGFloat width = 120;
    CGFloat height = 36;
    
    CGRect frame = CGRectMake(originX, originY, width, height);
    return frame;
}

- (CGRect)getTimeLabelFrame
{
    CGFloat distance = [self distanceFromModeStatusViewToTimeLabel];  // 与模式图标的垂直间距
    CGFloat width = CGRectGetWidth(self.frame) / 3 * 2;
    CGFloat height = [self timeLabelHeight];
    
    CGRect modeStatusViewFrame = [self getModeStatusViewFrame];
    CGFloat originX = modeStatusViewFrame.origin.x;
    CGFloat originY = modeStatusViewFrame.origin.y + modeStatusViewFrame.size.height + distance;
    
    CGRect frame = CGRectMake(originX, originY, width, height);
    return frame;
}

- (CGRect)getDistanceLabelFrame
{
    CGFloat distance = [self distanceFromTimeLabelToLabel];  // 与时间标签的垂直间距
    CGSize labelSize = [self getLabelSize];
    
    CGRect timeLabelFrame = [self getTimeLabelFrame];
    CGFloat originX = kDistanceLabelMargin;
    CGFloat originY = timeLabelFrame.origin.y + timeLabelFrame.size.height + distance;
    
    CGRect frame = CGRectMake(originX, originY, labelSize.width, labelSize.height);
    return frame;
}

- (CGRect)getPaceLabelFrame
{
    CGSize labelSize = [self getLabelSize];
    
    CGRect distanceLabelFrame = [self getDistanceLabelFrame];
    CGFloat originX = (CGRectGetWidth(self.frame) - labelSize.width) / 2;
    CGFloat originY = distanceLabelFrame.origin.y;
    
    CGRect frame = CGRectMake(originX, originY, labelSize.width, labelSize.height);
    return frame;
}

- (CGRect)getHeartRateLabelFrame
{
    CGSize labelSize = [self getLabelSize];
    
    CGRect paceLabelFrame = [self getPaceLabelFrame];
    CGFloat originX = CGRectGetWidth(self.frame) - labelSize.width - kDistanceLabelMargin;
    CGFloat originY = paceLabelFrame.origin.y;
    
    CGRect frame = CGRectMake(originX, originY, labelSize.width, labelSize.height);
    return frame;
}

- (CGSize)getLabelSize
{
    CGFloat labelWidth = 76;
    CGFloat labelHeight = 56;
    CGSize size = CGSizeMake(labelWidth, labelHeight);
    
    return size;
}

- (void)setupButtonsAppearance
{
    [self.pulldownView setAppearanceWithType:YSPulldownTypeGeneralMode];
    
    UIColor *orangeColor = RGBA(238, 78, 66, 0.75);
    [self setupButton:self.finishButton withColor:orangeColor];
    
    UIColor *blueColor = RGBA(0, 202, 238, 0.75);
    [self setupButton:self.continueButton withColor:blueColor];
}

- (void)setupButton:(UIButton *)button withColor:(UIColor *)color
{
    CGFloat continueBtnRadius = CGRectGetWidth(button.frame) / 2;
    button.layer.cornerRadius = continueBtnRadius;
    button.backgroundColor = color;
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

#pragma mark - YSMapManagerDelegate

- (void)updateDistance:(CGFloat)distance
{
    if ([self.delegate respondsToSelector:@selector(resetDistanceLabel:)])
    {
        [self.delegate resetDistanceLabel:distance];
    }
}

#pragma mark - 获取控件之间的间距、尺寸方法

// 暂时的处理是按照5的尺寸，等比例适用到6和6p

- (CGFloat)timeLabelFontSize
{
    // 在5上为60，按比例放大到6
    CGFloat fontSize = 55.f * (ScreenPtheight / iPhone5ScreenPtHeight);
    return fontSize;
}

- (CGFloat)timeLabelHeight
{
    return [self actualValue:42];
}

- (CGFloat)distanceFromModeStatusViewToTimeLabel
{
    // 模式图标与时间标签的间距
    return [self actualValue:27];
}

- (CGFloat)distanceFromTimeLabelToLabel
{
    // 时间标签与显示数据标签的间距
    return [self actualValue:18];
}

- (CGFloat)actualValue:(CGFloat)value
{
    // 按比例转换成实际屏幕上的值
    CGFloat scale = value / iPhone5ScreenPtHeight;
    CGFloat actual = ScreenPtheight * scale;
    
    return actual;
}


@end
