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
        self.countdownLabel.font = [UIFont systemFontOfSize:46];
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
