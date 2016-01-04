//
//  YSBarChart.m
//  PieChartDemo
//
//  Created by moshuqi on 15/11/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSBarChart.h"
#import "YSChartData.h"
#import "YSChartElement.h"

@implementation YSBarChart

- (id)initWithFrame:(CGRect)frame charData:(YSChartData *)chartData
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.chartData = chartData;
    }
    
    return self;
}

- (void)setupWithChartData:(YSChartData *)chartData
{
    self.chartData = chartData;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    [super drawRect:rect];
    
    if ([self.chartData isEmpty])
    {
        return;
    }
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    NSInteger count = [self.chartData elementCount];
    CGFloat originX = 0;
    for (NSInteger i = 0; i < count; i++)
    {
        // 分别绘制每个颜色段
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, height);
        
        CGContextMoveToPoint(context, originX, height / 2);
        
        UIColor *color = [self.chartData getElementColorAtIndex:i];
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        
        CGFloat percent = [self.chartData getElementPercentAtIndex:i];
        originX += (width * percent);
        
        CGPoint toPoint = CGPointMake(originX, height / 2);
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
        
        CGContextStrokePath(context);
    }
    
}

- (CGRect)getElementLabelFrameAtIndex:(NSInteger)index
{
    CGFloat totalPercent = 0;
    for (NSInteger i = 0; i < index; i++)
    {
        totalPercent += [self.chartData getElementPercentAtIndex:i];
    }
    
    CGFloat labelHeight = CGRectGetHeight(self.frame);
    CGFloat labelWidth = labelHeight * 1.2;
    CGFloat width = CGRectGetWidth(self.frame);
    
    CGFloat x = width * totalPercent;
    CGFloat d = 5;  // 间距
    CGRect frame = CGRectMake(x + d, 0, labelWidth, labelHeight);
    
    return frame;
}


@end
