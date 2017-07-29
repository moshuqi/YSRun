//
//  YSRunningModeView+GetMethod.h
//  YSRun
//
//  Created by moshuqi on 15/10/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSRunningModeView.h"

@interface YSRunningModeView (GetMethod)

- (CGRect)getModeStatusViewFrame;
- (CGRect)getTimeLabelFrame;
- (CGRect)getDistanceLabelFrame;
- (CGRect)getPaceLabelFrame;
- (CGRect)getHeartRateLabelFrame;
- (CGRect)getDataViewFrame;
- (CGRect)getFinishButtonAppearFrame;
- (CGRect)getFinishButtonDisappearFrame;
- (CGRect)getContinueButtonAppearFrame;
- (CGRect)getContinueButtonDisappearFrame;
- (CGSize)getButtonSize;
- (CGRect)getPulldownViewFrame;
- (CGRect)getPulldownViewDisappearFrame;
- (CGPoint)pulldownViewOriginPoint;
- (CGFloat)getPulldownViewOriginDistanceFromEdge;
- (CGFloat)getContinueButtonChangeDistance;
- (CGFloat)getFinishButtonChangeDistance;


@end
