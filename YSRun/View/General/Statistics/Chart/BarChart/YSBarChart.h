//
//  YSBarChart.h
//  PieChartDemo
//
//  Created by moshuqi on 15/11/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSChart.h"

@class YSChartData;

@interface YSBarChart : YSChart

- (id)initWithFrame:(CGRect)frame charData:(YSChartData *)chartData;
- (void)setupWithChartData:(YSChartData *)chartData;

@end
