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

@end

@implementation YSRunningMapModeView

- (void)addBackView
{
    
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
