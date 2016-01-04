//
//  YSGraphPoint.h
//  PieChartDemo
//
//  Created by moshuqi on 15/11/13.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YSGraphPoint : NSObject

// 横坐标、纵坐标值，比例，数值范围为0~1.0
@property (nonatomic, assign) CGFloat abscissaValue;    // 横坐标值
@property (nonatomic, assign) CGFloat ordinateValue;    // 纵坐标值

@end
