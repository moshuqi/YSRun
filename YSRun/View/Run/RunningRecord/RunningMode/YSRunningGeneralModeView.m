//
//  YSRunningGeneralModeView.m
//  YSRun
//
//  Created by moshuqi on 15/10/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSRunningGeneralModeView.h"
#import "YSAppMacro.h"
#import "YSAppUIDefine.h"

@interface YSRunningGeneralModeView ()

@property (nonatomic, strong) UIImageView *clockIcon;
@property (nonatomic, strong) UIImageView *backImageView;

@end

static const CGFloat kDistanceLabelMargin = 25; // 公里标签距离屏幕左边缘的间距

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
    UIImage *image = [UIImage imageNamed:@"clock"];
    self.clockIcon = [[UIImageView alloc] initWithImage:image];
    
    [self addSubview:self.clockIcon];
}

- (void)addBackView
{
    if (!self.backImageView)
    {
        UIImage *image = [UIImage imageNamed:@"background_image1"];
        self.backImageView = [[UIImageView alloc] initWithImage:image];
        self.backImageView.frame = self.bounds;
        
        [self addSubview:self.backImageView];
        [self sendSubviewToBack:self.backImageView];
    }
}

- (void)setupLabelsAppearance
{
    UIImage *modeImage = [UIImage imageNamed:@"map_mode.png"];
    [self.modeStatusView setModeIconWithImage:modeImage modeName:@"地图模式"];
    
    [self.timeLabel setBoldWithFontSize:[self timeLabelFontSize]];
    
    [self setContentFontSize:36 subscriptFontSize:10];
}

- (void)resetLayoutWithFrame:(CGRect)frame
{
    [super resetLayoutWithFrame:frame];
    
    self.clockIcon.frame = [self getClockIconFrame];
    [self.pulldownView setAppearanceWithType:YSPulldownTypeGeneralMode];
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
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = [self timeLabelHeight];
    
    CGRect modeStatusViewFrame = [self getModeStatusViewFrame];
    CGFloat originY = modeStatusViewFrame.origin.y + modeStatusViewFrame.size.height + distance;
    
    CGRect frame = CGRectMake(0, originY, width, height);
    return frame;
}

- (CGRect)getClockIconFrame
{
    CGFloat distance = [self distanceFromTimeLabelToClockIcon];  // 与显示时间标签的间距
    CGFloat iconWidth = 23;
    CGFloat iconHeight = 27;
    
    CGFloat originX = (CGRectGetWidth(self.frame) - iconWidth) / 2;
    CGRect timeLabelFrame = [self getTimeLabelFrame];
    CGFloat originY = timeLabelFrame.origin.y + timeLabelFrame.size.height + distance;
    
    CGRect frame = CGRectMake(originX, originY, iconWidth, iconHeight);
    return frame;
}

- (CGRect)getDistanceLabelFrame
{
    CGFloat distance = [self distanceFromClockIconToLabel];  // 与时钟图标的间距
//    CGFloat d = 40;    // 与边缘的间距
    CGSize labelSize = [self getLabelSize];
    
    CGRect iconFrame = [self getClockIconFrame];
    CGFloat originY = iconFrame.origin.y + iconFrame.size.height + distance;
    CGFloat originX = kDistanceLabelMargin;
    
    CGRect frame = CGRectMake(originX, originY, labelSize.width, labelSize.height);
    return frame;
}

- (CGRect)getPaceLabelFrame
{
    CGFloat distance = [self distanceFromClockIconToLabel];  // 与时钟图标的间距
    CGSize labelSize = [self getLabelSize];
    
    CGRect iconFrame = [self getClockIconFrame];
    CGFloat originX = (CGRectGetWidth(self.frame) - labelSize.width) / 2;
    CGFloat originY = iconFrame.origin.y + iconFrame.size.height + distance;
    
    CGRect frame = CGRectMake(originX, originY, labelSize.width, labelSize.height);
    return frame;
}

- (CGRect)getHeartRateLabelFrame
{
    CGFloat distance = [self distanceFromClockIconToLabel];  // 与时钟图标的间距
    CGSize labelSize = [self getLabelSize];
    
    CGRect iconFrame = [self getClockIconFrame];
    CGFloat originX = CGRectGetWidth(self.frame) - labelSize.width - kDistanceLabelMargin;
    CGFloat originY = iconFrame.origin.y + iconFrame.size.height + distance;
    
    CGRect frame = CGRectMake(originX, originY, labelSize.width, labelSize.height);
    return frame;
}

- (CGSize)getLabelSize
{
    // 公里、配速标签的size
    CGSize size = CGSizeMake(82, 56);
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

#pragma mark - 获取控件之间的间距、尺寸方法

// 暂时的处理是按照5的尺寸，等比例适用到6和6p

- (CGFloat)timeLabelFontSize
{
    // 在5上为60，按比例放大到6
    CGFloat fontSize = 60.f * (ScreenPtheight / iPhone5ScreenPtHeight);
    return fontSize;
}

- (CGFloat)timeLabelHeight
{
    return [self actualValue:55];
}

- (CGFloat)distanceFromClockIconToLabel
{
    // 标签与时钟图标的间距
    return [self actualValue:53];
}

- (CGFloat)distanceFromModeStatusViewToTimeLabel
{
    // 模式图标与时间标签的间距
    return [self actualValue:42];
}

- (CGFloat)distanceFromTimeLabelToClockIcon
{
    // 时间标签与时钟图片的间距
    return [self actualValue:20];
}

- (CGFloat)actualValue:(CGFloat)value
{
    // 按比例转换成实际屏幕上的值
    CGFloat scale = value / iPhone5ScreenPtHeight;
    CGFloat actual = ScreenPtheight * scale;
    
    return actual;
}

@end
