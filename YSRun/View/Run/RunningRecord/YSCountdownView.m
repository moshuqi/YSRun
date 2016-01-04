//
//  YSCountdownView.m
//  YSRun
//
//  Created by moshuqi on 15/10/23.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSCountdownView.h"
#import "YSAppMacro.h"

@interface YSCountdownView ()

@property (nonatomic, strong) UILabel *countdownLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger countdownTime;

@end

@implementation YSCountdownView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.countdownLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.countdownLabel.textAlignment = NSTextAlignmentCenter;
//        self.countdownLabel.font = [UIFont systemFontOfSize:46];
        self.countdownLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:200];
        self.countdownLabel.textColor = [UIColor whiteColor];
        
        [self addSubview:self.countdownLabel];
        self.backgroundColor = RGBA(0, 0, 0, 0.7);
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.countdownLabel.frame = self.bounds;
}

- (void)startAnimationCountdownWithTime:(NSInteger)time
{
    // 动画效果倒计时
    self.countdownTime = time;
    
    [self animationCountdown];
}

- (void)animationCountdown
{
    [self resetLabelText];
    
    NSTimeInterval totalInterval = 1;
    NSTimeInterval fadeOutInterval = 0.4;
    
    [UIView animateWithDuration:(totalInterval - fadeOutInterval) animations:^(){
        self.countdownLabel.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }completion:^(BOOL finished){
        
        [UIView animateWithDuration:fadeOutInterval animations:^(){
            [self.countdownLabel setAlpha:0.0];
        }completion:^(BOOL finished){
            self.countdownTime --;
            
            self.countdownLabel.transform = CGAffineTransformIdentity;
            [self.countdownLabel setAlpha:1.0];
            
            if (self.countdownTime > 0)
            {
                [self animationCountdown];
            }
            else
            {
                [self countdownEnd];
            }
        }];
        
        
    }];
}

- (void)startCountdownWithTime:(NSInteger)time
{
    self.countdownTime = time;
    [self resetLabelText];
    self.timer = [NSTimer timerWithTimeInterval:1
                                         target:self
                                       selector:@selector(countdown)
                                       userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)countdown
{
    self.countdownTime -= 1;
    [self resetLabelText];
    
    [UIView animateWithDuration:0.5 animations:^(){
        self.countdownLabel.transform = CGAffineTransformMakeScale(3, 3);
    }];
    
    if (self.countdownTime < 1)
    {
        [self countdownEnd];
    }
}

- (void)countdownEnd
{
    [self.timer invalidate];
    self.timer = nil;
    
    [self removeFromSuperview];
    [self.delegate countdownFinish];
}

- (void)resetLabelText
{
    self.countdownLabel.text = [NSString stringWithFormat:@"%@", @(self.countdownTime)];
}

@end
