//
//  YSTimeManager.h
//  YSRun
//
//  Created by moshuqi on 15/10/20.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YSTimeManagerDelegate <NSObject>

- (void)tickWithAccumulatedTime:(NSUInteger)time;

@end

@interface YSTimeManager : NSObject

@property (nonatomic, weak) id<YSTimeManagerDelegate> delegate;

- (void)start;
- (void)pause;
//- (void)stop;
- (NSUInteger)getTotalTime;
- (NSUInteger)currentAccumulatedTime;

@end
