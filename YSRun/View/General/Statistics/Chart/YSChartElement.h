//
//  YSChartElement.h
//  PieChartDemo
//
//  Created by moshuqi on 15/11/11.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YSChartElement : NSObject

@property (nonatomic, copy) NSString *elementName;
@property (nonatomic, strong) UIColor *color;       // 饼图中表现的颜色
@property (nonatomic, assign) CGFloat quantity;     // 单位量，除以总量可得在饼图中所占比例

@end
