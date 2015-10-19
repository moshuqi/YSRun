//
//  YSRunningModeView.m
//  YSRun
//
//  Created by moshuqi on 15/10/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSRunningModeView.h"
#import "YSRunningModeView+GetMethod.h"

const CGFloat kPulldownViewRadius = 44;
const CGFloat kButtonWidth = 88;

@interface YSRunningModeView () <YSRunningModeStatusViewDelegate>

@end

@implementation YSRunningModeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubviews];
        [self setupButtonsAppearance];
        [self setupLabelsAppearance];
        
        self.isPause = NO;
        self.backgroundColor = [UIColor lightGrayColor];
        
        [self addPulldownGesture];
    }
    
    return self;
}

- (void)addSubviews
{
    self.timeLabel = [[[UINib nibWithNibName:@"YSTimeLabel" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
    self.timeLabel.userInteractionEnabled = NO;
    [self addSubview:self.timeLabel];
    
    self.distanceLabel = [[[UINib nibWithNibName:@"YSSubscriptLabel" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
    self.distanceLabel.userInteractionEnabled = NO;
    [self.distanceLabel setSubscriptText:@"公里"];
    [self addSubview:self.distanceLabel];
    
    self.speedLabel = [[[UINib nibWithNibName:@"YSSubscriptLabel" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
    self.speedLabel.userInteractionEnabled = NO;
    [self.speedLabel setSubscriptText:@"配速"];
    [self addSubview:self.speedLabel];
    
    self.modeStatusView = [[[UINib nibWithNibName:@"YSRunningModeStatusView" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
    self.modeStatusView.delegate = self;
    [self addSubview:self.modeStatusView];
    
    self.finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.finishButton.frame = CGRectMake(0, 0, kButtonWidth, kButtonWidth);
    [self.finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.finishButton addTarget:self action:@selector(finishButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.finishButton];
    
    self.continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.continueButton.frame = CGRectMake(0, 0, kButtonWidth, kButtonWidth);
    [self.continueButton setTitle:@"继续" forState:UIControlStateNormal];
    [self.continueButton addTarget:self action:@selector(continueButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.continueButton];
    
    self.pulldownView = [YSPulldownView defaultPulldownViewWithRadius:kPulldownViewRadius];
    [self addSubview:self.pulldownView];
}

- (void)addBackView
{
    // 子类重载
}

- (void)addPulldownGesture
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pulldown:)];
    [self.pulldownView addGestureRecognizer:panGesture];
}

- (void)setupLabelsAppearance
{
    // 设置标签字号大小和颜色，子类重载
}

- (void)resetLayoutWithFrame:(CGRect)frame
{
    self.frame = frame;
    
    self.modeStatusView.frame = [self getModeStatusViewFrame];
    self.timeLabel.frame = [self getTimeLabelFrame];
    self.distanceLabel.frame = [self getDistanceLabelFrame];
    self.speedLabel.frame = [self getSpeedLabelFrame];
    
    [self resetButtonsPositionWithPauseStatus];
    [self setupButtonsAppearance];
    
    [self addBackView];
}

- (void)setupButtonsAppearance
{
    // 子类重载，按钮的样式在两种模式下不一致
}

- (void)pulldown:(UIPanGestureRecognizer *)panGesture
{
    CGPoint point = [panGesture locationInView:self];
    CGPoint originPoint = [self pulldownViewOriginPoint]; // 原来中心点的位置
    CGFloat dy = point.y - originPoint.y;
    
    if (panGesture.state == UIGestureRecognizerStateBegan)
    {
        
    }
    else if (panGesture.state == UIGestureRecognizerStateChanged)
    {
        
        if (point.y >= originPoint.y)
        {
            CGRect frame = CGRectMake(self.pulldownView.frame.origin.x,
                                      point.y - self.pulldownView.frame.size.height / 2,
                                      self.pulldownView.frame.size.width,
                                      self.pulldownView.frame.size.height);
            self.pulldownView.frame = frame;
            
            [self updateButtonsPositionByDeltaY:dy];
        }
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded ||
             panGesture.state == UIGestureRecognizerStateCancelled)
    {
        [self panGestureEndWithDeltaY:dy];
    }
}

- (void)updateButtonsPositionByDeltaY:(CGFloat)dy
{
    // 拖动过程中实时更新完成按钮和继续按钮的位置
    
    CGFloat scale = dy / [self getPulldownViewOriginDistanceFromEdge];
    
    CGFloat continueButtonDy = [self getContinueButtonChangeDistance] * scale;
    CGRect continueButtonFrame = [self getContinueButtonDisappearFrame];
    CGRect continueButtonChangeFrame = CGRectMake(continueButtonFrame.origin.x,
                                                  continueButtonFrame.origin.y - continueButtonDy,
                                                  continueButtonFrame.size.width,
                                                  continueButtonFrame.size.height);
    self.continueButton.frame = continueButtonChangeFrame;
    
    CGFloat finishButtonDy = [self getFinishButtonChangeDistance] * scale;
    CGRect finishButtonFrame = [self getFinishButtonDisappearFrame];
    CGRect finishButtonChangeFrame = CGRectMake(finishButtonFrame.origin.x,
                                                finishButtonFrame.origin.y - finishButtonDy,
                                                finishButtonFrame.size.width,
                                                finishButtonFrame.size.height);
    self.finishButton.frame = finishButtonChangeFrame;
}

- (void)panGestureEndWithDeltaY:(CGFloat)dy
{
    // 手势拖动结束后，根据实际拖动的距离dy来决定按钮的显示情况。通过动画来复位按钮位置
    
    BOOL bPause = NO;
    if (dy > ([self getPulldownViewOriginDistanceFromEdge] / 3 * 2))
    {
        // 拖动超过三分之二的距离则拖动按钮消失，此时暂停，并显示完成和继续按钮；否则按钮复位
        bPause = YES;
        [self runningPause];
    }
    
    self.isPause = bPause;
    
    CGRect continueButtonFrame = [self getContinueButtonDisappearFrame];
    CGRect finishButtonFrame = [self getFinishButtonDisappearFrame];
    CGRect pulldownViewFrame = [self getPulldownViewFrame];
    
    if (bPause)
    {
        continueButtonFrame = [self getContinueButtonAppearFrame];
        finishButtonFrame = [self getFinishButtonAppearFrame];
        pulldownViewFrame = [self getPulldownViewDisappearFrame];
    }
    
    [UIView animateWithDuration:0.5 animations:^(){
        self.continueButton.frame = continueButtonFrame;
        self.finishButton.frame = finishButtonFrame;
        self.pulldownView.frame = pulldownViewFrame;
    }completion:nil];
}

- (void)runningPause
{
    // 跑步暂停
}

- (void)runningContinue
{
    // 跑步继续
    
}

- (void)continueButtonClicked:(id)sender
{
    // 继续
    self.isPause = NO;
    [self resetButtonsPositionWithPauseStatus];
    
    [self runningContinue];
}

- (void)finishButtonClicked:(id)sender
{
    // 完成
}

- (void)resetButtonsPositionWithPauseStatus
{
    if (self.isPause)
    {
        self.continueButton.frame = [self getContinueButtonAppearFrame];
        self.finishButton.frame = [self getFinishButtonAppearFrame];
        self.pulldownView.frame = [self getPulldownViewDisappearFrame];
    }
    else
    {
        self.continueButton.frame = [self getContinueButtonDisappearFrame];
        self.finishButton.frame = [self getFinishButtonDisappearFrame];
        self.pulldownView.frame = [self getPulldownViewFrame];
    }
}


#pragma mark - YSRunningModeStatusViewDelegate

- (void)modeStatusChange
{
    [self.delegate changeMode];
}


@end
