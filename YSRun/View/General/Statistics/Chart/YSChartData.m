//
//  YSPieChartData.m
//  PieChartDemo
//
//  Created by moshuqi on 15/11/11.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSChartData.h"

@interface YSChartData ()

@property (nonatomic, copy) NSArray *elementArray;
@property (nonatomic, assign) CGFloat amount;

@end

@implementation YSChartData

- (id)initWithElementArray:(NSArray *)elementArray
{
    self = [super init];
    if (self)
    {
        self.elementArray = elementArray;
        self.amount = [self getAmountWithElementArray:elementArray];
    }
    
    return self;
}

- (BOOL)isEmpty
{
    return [self.elementArray count] < 1;
}

- (NSInteger)elementCount
{
    return [self.elementArray count];
}

- (CGFloat)getAmountWithElementArray:(NSArray *)elementArray
{
    CGFloat amount = 0;
    
    for (NSInteger i = 0; i < [elementArray count]; i++)
    {
        YSChartElement *element = elementArray[i];
        amount += element.quantity;
    }
    
    return amount;
}

- (NSString *)getElementNameAtIndex:(NSInteger)index
{
    NSString *name = 0;
    if (index < [self.elementArray count])
    {
        YSChartElement *element = self.elementArray[index];
        name = element.elementName;
    }
    
    return name;
}

- (CGFloat)getElementPercentAtIndex:(NSInteger)index
{
    CGFloat percent = 0;
    if (index < [self.elementArray count])
    {
        YSChartElement *element = self.elementArray[index];
        percent = element.quantity / self.amount;
    }
    
    return percent;
}

- (UIColor *)getElementColorAtIndex:(NSInteger)index
{
    UIColor *color = nil;
    if (index < [self.elementArray count])
    {
        YSChartElement *element = self.elementArray[index];
        color = element.color;
    }
    
    return color;
}

@end
