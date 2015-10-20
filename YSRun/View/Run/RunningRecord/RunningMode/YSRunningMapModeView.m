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

@interface YSRunningMapModeView ()

@property (nonatomic, strong) YSMapManager *mapManager;
@property (nonatomic, strong) UIButton *testButton;

@end

@implementation YSRunningMapModeView

- (void)addBackView
{
    if (!self.mapManager)
    {
        self.mapManager = [[YSMapManager alloc] init];
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
        [self addSubview:self.testButton];
        
        [self.testButton addTarget:self action:@selector(testFunc) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (![self.mapManager.OutputMessageLabel superview])
    {
        CGFloat height = 180;
        CGRect frame = CGRectMake(0, (CGRectGetHeight(self.frame) - height) / 2, CGRectGetWidth(self.frame), height);
        self.mapManager.OutputMessageLabel.frame = frame;
        [self addSubview:self.mapManager.OutputMessageLabel];
    }
}

- (void)testFunc
{
    [self.mapManager testRoute];
}

- (void)setupLabelsAppearance
{
    UIImage *modeImage = [UIImage imageNamed:@"run_mode.png"];
    [self.modeStatusView setModeIconWithImage:modeImage modeName:@"跑步模式"];
    
    [self.timeLabel setLabelFontSize:30];
}

- (void)resetLayoutWithFrame:(CGRect)frame
{
    [super resetLayoutWithFrame:frame];
    [self.pulldownView setAppearanceWithType:YSPulldownTypeMapMode];
}

- (CGRect)getModeStatusViewFrame
{
    CGFloat originX = 13;
    CGFloat originY = 11;
    CGFloat width = 120;
    CGFloat height = 34;
    
    CGRect frame = CGRectMake(originX, originY, width, height);
    return frame;
}

- (CGRect)getTimeLabelFrame
{
    CGFloat distance = 20;  // 与模式图标的垂直间距
    CGFloat width = CGRectGetWidth(self.frame) / 2;
    CGFloat height = 76;
    
    CGRect modeStatusViewFrame = [self getModeStatusViewFrame];
    CGFloat originX = modeStatusViewFrame.origin.x;
    CGFloat originY = modeStatusViewFrame.origin.y + modeStatusViewFrame.size.height + distance;
    
    CGRect frame = CGRectMake(originX, originY, width, height);
    return frame;
}

- (CGRect)getDistanceLabelFrame
{
    CGFloat distance = 36;  // 与时间标签的间距
    CGSize labelSize = [self getLabelSize];
    
    CGRect timeLabelFrame = [self getTimeLabelFrame];
    CGFloat originX = timeLabelFrame.origin.x;
    CGFloat originY = timeLabelFrame.origin.y + timeLabelFrame.size.height + distance;
    
    CGRect frame = CGRectMake(originX, originY, labelSize.width, labelSize.height);
    return frame;
}

- (CGRect)getSpeedLabelFrame
{
    CGFloat distance = 36;  // 与时间标签的间距
    CGSize labelSize = [self getLabelSize];
    
    CGRect timeLabelFrame = [self getTimeLabelFrame];
    CGFloat originX = timeLabelFrame.origin.x + labelSize.width;
    CGFloat originY = timeLabelFrame.origin.y + timeLabelFrame.size.height + distance;
    
    CGRect frame = CGRectMake(originX, originY, labelSize.width, labelSize.height);
    return frame;
}

- (CGSize)getLabelSize
{
    CGFloat labelHeight = 56;
    CGFloat labelWidth = [self getTimeLabelFrame].size.width / 2;
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


@end
