//
//  YSRunningModeView.h
//  YSRun
//
//  Created by moshuqi on 15/10/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTimeLabel.h"
#import "YSSubscriptLabel.h"
#import "YSRunningModeStatusView.h"
#import "YSPulldownView.h"

@protocol YSRunningModeViewDelegate <NSObject>

- (void)changeMode;
- (void)runningPause;
- (void)runningContinue;
- (void)runningFinish;

@optional
- (void)resetDistanceLabel:(CGFloat)distance;

@end

@interface YSRunningModeView : UIView

@property (nonatomic, strong) YSTimeLabel *timeLabel;
@property (nonatomic, strong) YSSubscriptLabel *distanceLabel;
@property (nonatomic, strong) YSSubscriptLabel *paceLabel;
@property (nonatomic, strong) YSSubscriptLabel *heartRateLabel;
@property (nonatomic, strong) YSRunningModeStatusView *modeStatusView;

@property (nonatomic, strong) UIButton *continueButton;
@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, strong) YSPulldownView *pulldownView;

@property (nonatomic, assign) BOOL isPause;
@property (nonatomic, assign) id<YSRunningModeViewDelegate> delegate;

- (void)resetLayoutWithFrame:(CGRect)frame;
- (void)resetButtonsPositionWithPauseStatus;
- (void)resetTimeLabelWithTime:(NSUInteger)time;

- (void)setDistance:(CGFloat)distance;
- (void)setPace:(CGFloat)pace;
- (void)setHeartRate:(NSInteger)heartRate;

- (void)setContentFontSize:(CGFloat)contentSize subscriptFontSize:(CGFloat)subscriptSize;

@end
