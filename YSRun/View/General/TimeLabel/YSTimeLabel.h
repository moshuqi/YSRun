//
//  YSTimeLabel.h
//  YSRun
//
//  Created by moshuqi on 15/10/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSTimeLabel : UIView

- (void)resetTimeLabelWithTotalSeconds:(NSUInteger)totalSeconds;
- (void)setLabelFontSize:(CGFloat)fontSize;

- (void)setBoldWithFontSize:(CGFloat)fontSize;

@end
