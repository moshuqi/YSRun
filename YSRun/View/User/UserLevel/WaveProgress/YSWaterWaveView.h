//
//  YSWaterWaveView.h
//  Wave
//
//  Created by moshuqi on 16/1/7.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSWaterWaveView : UIView

- (void)startWaveToPercent:(CGFloat)percent;

- (void)setGrowthSpeed:(CGFloat)growthSpeed;    // 设置上升速度
- (void)setGradientColors:(NSArray *)colors;    // 设置渐变色

@end
