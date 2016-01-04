//
//  YSGraphData.h
//  YSRun
//
//  Created by moshuqi on 15/11/17.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class YSGraphPoint;

@interface YSGraphData : NSObject

// 横坐标、纵坐标的最大最小值
@property (nonatomic, assign) CGFloat abscissaMax;
@property (nonatomic, assign) CGFloat abscissaMin;
@property (nonatomic, assign) CGFloat ordinateMax;
@property (nonatomic, assign) CGFloat ordinateMin;

// 中间段的最大值、最小值
@property (nonatomic, assign) CGFloat middleSectionMax;
@property (nonatomic, assign) CGFloat middleSectionMin;

- (id)initWithDataArray:(NSArray *)dataArray;

- (void)setBackgroundWithTopColor:(UIColor *)topColor middleColor:(UIColor *)middleColor bottomColor:(UIColor *)bottomColor;
- (UIColor *)getTopColor;
- (UIColor *)getMiddleColor;
- (UIColor *)getBottomColor;

- (NSInteger)dataCount;
- (YSGraphPoint *)graphPointAtIndex:(NSInteger)index;

@end
