//
//  YSChartData.h
//  PieChartDemo
//
//  Created by moshuqi on 15/11/11.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSChartElement.h"

@interface YSChartData : NSObject

- (id)initWithElementArray:(NSArray *)elementArray;
- (BOOL)isEmpty;
- (NSInteger)elementCount;

- (NSString *)getElementNameAtIndex:(NSInteger)index;
- (CGFloat)getElementPercentAtIndex:(NSInteger)index;
- (UIColor *)getElementColorAtIndex:(NSInteger)index;

@end
