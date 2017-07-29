//
//  YSHeartRateGraphView.h
//  YSRun
//
//  Created by moshuqi on 15/11/25.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSHeartRateGraphViewDelegate <NSObject>

@optional
- (void)tapHelpFromPoint:(CGPoint)point;

@end

@interface YSHeartRateGraphView : UIView

@property (nonatomic, weak) id<YSHeartRateGraphViewDelegate> delegate;

- (void)setupWithStartTime:(NSInteger)startTime endTime:(NSInteger)endTime dictDataArray:(NSArray *)dictDataArray;

@end
