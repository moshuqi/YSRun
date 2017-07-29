//
//  YSResultDataLabelsView.h
//  YSRun
//
//  Created by moshuqi on 16/2/23.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSResultDataLabelsView : UIView

- (void)setupWithDistance:(NSString *)distance
                     time:(NSString *)time
                  calorie:(NSString *)calorie;
- (void)setStandarRate:(CGFloat)rate;

@end
