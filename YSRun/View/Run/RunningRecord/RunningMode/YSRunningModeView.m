//
//  YSRunningModeView.m
//  YSRun
//
//  Created by moshuqi on 15/10/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSRunningModeView.h"

const CGFloat kPulldownViewRadius = 44;
const CGFloat kButtonWidth = 88;

@implementation YSRunningModeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubviews];
        [self addBackView];
        self.isPause = NO;
        [self setupButtonsAppearance];
        
        self.backgroundColor = [UIColor lightGrayColor];
    }
    
    return self;
}

- (void)addSubviews
{
    self.timeLabel = [[[UINib nibWithNibName:@"YSTimeLabel" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
    [self addSubview:self.timeLabel];
    
    self.distanceLabel = [[[UINib nibWithNibName:@"YSSubscriptLabel" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
    [self addSubview:self.distanceLabel];
    
    self.speedLabel = [[[UINib nibWithNibName:@"YSSubscriptLabel" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
    [self addSubview:self.speedLabel];
    
    self.modeStatusView = [[[UINib nibWithNibName:@"YSRunningModeStatusView" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
    [self addSubview:self.modeStatusView];
    
    self.finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.finishButton.frame = CGRectMake(0, 0, kButtonWidth, kButtonWidth);
    [self.finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [self addSubview:self.finishButton];
    
    self.continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.continueButton.frame = CGRectMake(0, 0, kButtonWidth, kButtonWidth);
    [self.continueButton setTitle:@"继续" forState:UIControlStateNormal];
    [self addSubview:self.continueButton];
    
    self.pulldownView = [YSPulldownView defaultPulldownViewWithRadius:kPulldownViewRadius];
    [self addSubview:self.pulldownView];
}

- (void)addBackView
{
    // 子类重载
}

- (void)resetLayoutWithFrame:(CGRect)frame
{
    self.frame = frame;
    
    self.modeStatusView.frame = [self getModeStatusViewFrame];
    self.timeLabel.frame = [self getTimeLabelFrame];
    self.distanceLabel.frame = [self getDistanceLabelFrame];
    self.speedLabel.frame = [self getSpeedLabelFrame];
    
    self.pulldownView.frame = [self getPulldownViewFrame];
    self.continueButton.frame = [self getContinueButtonDisappearFrame];
    self.finishButton.frame = [self getFinishButtonDisappearFrame];
    [self setupButtonsAppearance];
    
//    self.continueButton.frame = [self getContinueButtonAppearFrame];
//    self.finishButton.frame = [self getFinishButtonAppearFrame];
}

- (void)setupButtonsAppearance
{
    // 子类重载，按钮的样式在两种模式下不一致
}

- (CGRect)getModeStatusViewFrame
{
    // 子类重载
    return CGRectZero;
}

- (CGRect)getTimeLabelFrame
{
    // 子类重载
    return CGRectZero;
}

- (CGRect)getDistanceLabelFrame
{
    // 子类重载
    return CGRectZero;
}

- (CGRect)getSpeedLabelFrame
{
    // 子类重载
    return CGRectZero;
}

- (CGRect)getFinishButtonAppearFrame
{
    CGFloat distance = 106;  // 与底边的间距
    CGFloat d = 40;    // 与边缘的间距
    CGSize buttonSize = [self getButtonSize];
    
    CGFloat originY = CGRectGetHeight(self.frame) - distance - buttonSize.height;
    CGRect frame = CGRectMake(d, originY, buttonSize.width, buttonSize.height);
    return frame;
}

- (CGRect)getFinishButtonDisappearFrame
{
    CGRect appearFrame = [self getFinishButtonAppearFrame];
    CGFloat d = 30;
    CGFloat originY = CGRectGetHeight(self.frame) + d + [self getButtonSize].height;
    
    CGRect frame = CGRectMake(appearFrame.origin.x, originY, appearFrame.size.width, appearFrame.size.height);
    return frame;
}

- (CGRect)getContinueButtonAppearFrame
{
    CGFloat distance = 106;  // 与底边的间距
    CGFloat d = 40;    // 与边缘的间距
    CGSize buttonSize = [self getButtonSize];
    
    CGFloat originX = CGRectGetWidth(self.frame) - buttonSize.width - d;
    CGFloat originY = CGRectGetHeight(self.frame) - distance - buttonSize.height;
    
    CGRect frame = CGRectMake(originX, originY, buttonSize.width, buttonSize.height);
    return frame;
}

- (CGRect)getContinueButtonDisappearFrame
{
    CGRect appearFrame = [self getContinueButtonAppearFrame];
    CGFloat d = 30;
    CGFloat originY = CGRectGetHeight(self.frame) + d + [self getButtonSize].height;
    
    CGRect frame = CGRectMake(appearFrame.origin.x, originY, appearFrame.size.width, appearFrame.size.height);
    return frame;
}

- (CGSize)getButtonSize
{
    // 按钮的宽度
    CGSize size = self.continueButton.frame.size;
    return size;
}

- (CGRect)getPulldownViewFrame
{
    CGFloat width = CGRectGetWidth(self.pulldownView.frame);
    CGFloat height = CGRectGetHeight(self.pulldownView.frame);
    
    CGFloat originY = [self getContinueButtonAppearFrame].origin.y;
    CGFloat originX = (CGRectGetWidth(self.frame) - width) / 2;
    
    CGRect frame = CGRectMake(originX, originY, width, height);
    return frame;
}


@end
