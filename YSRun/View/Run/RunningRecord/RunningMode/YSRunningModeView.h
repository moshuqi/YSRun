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

@interface YSRunningModeView : UIView

@property (nonatomic, strong) YSTimeLabel *timeLabel;
@property (nonatomic, strong) YSSubscriptLabel *distanceLabel;
@property (nonatomic, strong) YSSubscriptLabel *speedLabel;
@property (nonatomic, strong) YSRunningModeStatusView *modeStatusView;

@property (nonatomic, strong) UIButton *continueButton;
@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, strong) YSPulldownView *pulldownView;

@property (nonatomic, assign) BOOL isPause;

- (void)resetLayoutWithFrame:(CGRect)frame;

@end
