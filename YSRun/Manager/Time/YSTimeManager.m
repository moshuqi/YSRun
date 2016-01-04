//
//  YSTimeManager.m
//  YSRun
//
//  Created by moshuqi on 15/10/20.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSTimeManager.h"

@interface YSTimeManager ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSUInteger startTime; // 时间记录单位全为“秒”
@property (nonatomic, assign) NSUInteger totalTime;
@property (nonatomic, assign) NSUInteger pauseAccumulatedTime;  // 暂停累加的时间

@end

@implementation YSTimeManager

- (id)init
{
    self = [super init];
    if (self)
    {
        self.startTime = 0;
        self.totalTime = 0;
        self.pauseAccumulatedTime = 0;
    }
    
    return self;
}

- (void)start
{
    self.startTime = (NSUInteger)CFAbsoluteTimeGetCurrent();
    
    self.timer = [NSTimer timerWithTimeInterval:0.2
                                              target:self
                                            selector:@selector(clockTick:)
                                            userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)pause
{
    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
        
        NSUInteger currentTime = (NSUInteger)CFAbsoluteTimeGetCurrent();
        NSUInteger elapsedTime = currentTime - self.startTime;
        self.pauseAccumulatedTime += elapsedTime;
    }
}

//- (void)stop
//{
//    if (self.timer)
//    {
//        [self.timer invalidate];
//        self.timer = nil;
//    }
//    
//    NSUInteger currentTime = (NSUInteger)CFAbsoluteTimeGetCurrent();
//    NSUInteger elapsedTime = currentTime - self.startTime;
//    self.totalTime = self.pauseAccumulatedTime + elapsedTime;
//    self.pauseAccumulatedTime = 0;
//}

- (void)clockTick:(NSTimer *)timer
{
    NSUInteger currentAccumulateTime = [self currentAccumulatedTime];
    [self.delegate tickWithAccumulatedTime:currentAccumulateTime];
}

- (NSUInteger)currentAccumulatedTime
{
    if (!self.startTime)
    {
        return 0;
    }
    
    NSUInteger currentTime = (NSUInteger)CFAbsoluteTimeGetCurrent();
    NSUInteger elapsedTime = currentTime - self.startTime;
    
    NSUInteger accumulatedTime = self.pauseAccumulatedTime + elapsedTime;
    return accumulatedTime;
}

- (NSUInteger)getTotalTime
{
    return self.pauseAccumulatedTime;
}

@end
