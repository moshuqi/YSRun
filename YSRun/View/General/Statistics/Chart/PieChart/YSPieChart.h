//
//  YSPieChart.h
//  PieChartDemo
//
//  Created by moshuqi on 15/11/11.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSChart.h"

@interface YSPieChart : YSChart

- (id)initWithData:(YSChartData *)data
    pieChartRadius:(CGFloat)pieChartRadius
      annularWidth:(CGFloat)annularWidth;

- (void)setupWithChartData:(YSChartData *)chartData
            pieChartRadius:(CGFloat)pieChartRadius
              annularWidth:(CGFloat)annularWidth;

@end
