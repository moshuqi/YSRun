//
//  YSRunningGeneralModeView.m
//  YSRun
//
//  Created by moshuqi on 15/10/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSRunningGeneralModeView.h"
#import "YSAppMacro.h"

@interface YSRunningGeneralModeView ()

@property (nonatomic, strong) UIImageView *clockIcon;
@property (nonatomic, strong) UIImageView *backImageView;

@end

@implementation YSRunningGeneralModeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addClockIcon];
    }
    
    return self;
}

- (void)addClockIcon
{
    UIImage *image = [UIImage imageNamed:@"clock.png"];
    self.clockIcon = [[UIImageView alloc] initWithImage:image];
    
    [self addSubview:self.clockIcon];
}

- (void)addBackView
{
    
}

- (void)resetLayoutWithFrame:(CGRect)frame
{
    [super resetLayoutWithFrame:frame];
    
    self.clockIcon.frame = [self getClockIconFrame];
    [self.pulldownView setAppearanceWithType:YSPulldownTypeGeneralMode];
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
    CGFloat distance = 56;  // 与模式图标的垂直间距
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = 96;
    
    CGRect modeStatusViewFrame = [self getModeStatusViewFrame];
    CGFloat originY = modeStatusViewFrame.origin.y + modeStatusViewFrame.size.height + distance;
    
    CGRect frame = CGRectMake(0, originY, width, height);
    return frame;
}

- (CGRect)getClockIconFrame
{
    CGFloat distance = 25;  // 与显示时间标签的间距
    CGFloat iconWidth = 36;
    CGFloat iconHeight = iconWidth;
    
    CGFloat originX = (CGRectGetWidth(self.frame) - iconWidth) / 2;
    CGRect timeLabelFrame = [self getTimeLabelFrame];
    CGFloat originY = timeLabelFrame.origin.y + timeLabelFrame.size.height + distance;
    
    CGRect frame = CGRectMake(originX, originY, iconWidth, iconHeight);
    return frame;
}

- (CGRect)getDistanceLabelFrame
{
    CGFloat distance = 46;  // 与时钟图标的间距
    CGFloat d = 40;    // 与边缘的间距
    CGSize labelSize = [self getLabelSize];
    
    CGRect iconFrame = [self getClockIconFrame];
    CGFloat originY = iconFrame.origin.y + iconFrame.size.height + distance;
    
    CGRect frame = CGRectMake(d, originY, labelSize.width, labelSize.height);
    return frame;
}

- (CGRect)getSpeedLabelFrame
{
    CGFloat distance = 46;  // 与时钟图标的间距
    CGFloat d = 40;    // 与边缘的间距
    CGSize labelSize = [self getLabelSize];
    
    CGRect iconFrame = [self getClockIconFrame];
    CGFloat originX = CGRectGetWidth(self.frame) - d - labelSize.width;
    CGFloat originY = iconFrame.origin.y + iconFrame.size.height + distance;
    
    CGRect frame = CGRectMake(originX, originY, labelSize.width, labelSize.height);
    return frame;
}

- (CGSize)getLabelSize
{
    // 公里、配速标签的size
    CGSize size = CGSizeMake(88, 56);
    return size;
}

- (void)setupButtonsAppearance
{
    [self.pulldownView setAppearanceWithType:YSPulldownTypeGeneralMode];
    
    UIColor *orangeColor = RGB(251, 105, 94);
    [self setupButton:self.finishButton withColor:orangeColor];
    
    UIColor *blueColor = RGB(38, 205, 235);
    [self setupButton:self.continueButton withColor:blueColor];
}

- (void)setupButton:(UIButton *)button withColor:(UIColor *)color
{
    CGFloat borderWidth = 3;
    button.layer.borderWidth = borderWidth;
    
    CGFloat continueBtnRadius = CGRectGetWidth(button.frame) / 2;
    button.layer.cornerRadius = continueBtnRadius;
    
    button.layer.borderColor = color.CGColor;
    button.backgroundColor = [UIColor clearColor];
    
    [button setTitleColor:color forState:UIControlStateNormal];
}

@end
