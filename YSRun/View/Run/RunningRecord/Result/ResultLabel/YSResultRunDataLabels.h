//
//  YSResultRunDataLabels.h
//  YSRun
//
//  Created by moshuqi on 15/12/11.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSResultRunDataLabelsDelegate <NSObject>

@required
- (void)runDataLabelsTapDetail;

@end

@interface YSResultRunDataLabels : UIView

@property (nonatomic, weak) id<YSResultRunDataLabelsDelegate> delegate;

- (void)setDistance:(CGFloat)distance time:(NSString *)time calorie:(CGFloat)calorie;

@end
