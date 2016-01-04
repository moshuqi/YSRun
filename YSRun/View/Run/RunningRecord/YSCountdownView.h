//
//  YSCountdownView.h
//  YSRun
//
//  Created by moshuqi on 15/10/23.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSCountdownViewDelegate <NSObject>

- (void)countdownFinish;

@end

@interface YSCountdownView : UIView

@property (nonatomic, weak) id<YSCountdownViewDelegate> delegate;

- (void)startCountdownWithTime:(NSInteger)time;
- (void)startAnimationCountdownWithTime:(NSInteger)time;

@end
