//
//  YSHeartRateGraphView.h
//  YSRun
//
//  Created by moshuqi on 15/11/25.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSHeartRateGraphView : UIView

- (void)setupWithStartTime:(NSInteger)startTime endTime:(NSInteger)endTime dictDataArray:(NSArray *)dictDataArray;

@end
