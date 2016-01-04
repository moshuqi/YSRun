//
//  YSResultHeartRateDataLabels.h
//  YSRun
//
//  Created by moshuqi on 15/11/23.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSResultHeartRateDataLabelsDelegate <NSObject>

@required
- (void)heartRateDataLabelsTapDetail;

@end

@interface YSResultHeartRateDataLabels : UIView

@property (nonatomic, weak) id<YSResultHeartRateDataLabelsDelegate> delegate;

- (void)setDistance:(CGFloat)distance time:(NSString *)time calorie:(CGFloat)calorie heartRateProportion:(CGFloat)proportion;

@end
