//
//  YSTimeShaftView.h
//  YSRun
//
//  Created by moshuqi on 15/11/25.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSTimeShaftView : UIView

- (void)setupWithStartTime:(NSInteger)startTime endTime:(NSInteger)endTime;
- (void)setupLabelTextColor:(UIColor *)textColor fontSize:(CGFloat)fontSize;

@end
