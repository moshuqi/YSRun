//
//  YSCaptchaTimer.m
//  YSRun
//
//  Created by moshuqi on 15/11/3.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSCaptchaTimer.h"

@interface YSCaptchaTimer ()

@property (nonatomic, assign) NSInteger starTime;
@property (nonatomic, assign) BOOL isCountdowning;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) CallbackBlock callbackBlock;

@end

@implementation YSCaptchaTimer

static YSCaptchaTimer *_instance;
const NSInteger kCountdownTime = 60;    // 倒计时1分钟后才能再发验证码短信

+ (id)allocWithZone:(struct _NSZone *)zone
{
    //调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)shareCaptchaTimer
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YSCaptchaTimer alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.isCountdowning = NO;
    }
    
    return self;
}

- (void)startWithBlock:(CallbackBlock)block
{
    self.callbackBlock = block;
    self.isCountdowning = YES;
    self.starTime = [[NSDate date] timeIntervalSince1970];
    
    self.timer = [NSTimer timerWithTimeInterval:0.2
                                         target:self
                                       selector:@selector(clockTick:)
                                       userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)clockTick:(NSTimer *)timer
{
    NSInteger currentTime = [[NSDate date] timeIntervalSince1970];
    NSInteger remainTime = kCountdownTime - (currentTime - self.starTime);
    
    BOOL finished = (remainTime <= 0);
    if (finished)
    {
        [self countdownFinished];
    }
    
    self.callbackBlock(remainTime, finished);
}

- (void)countdownFinished
{
    [self.timer invalidate];
    self.timer = nil;
    
    self.isCountdowning = NO;
}

- (BOOL)isCountdownState
{
    return self.isCountdowning;
}

- (void)setCallbackWithBlock:(CallbackBlock)block
{
    self.callbackBlock = block;
}

@end
