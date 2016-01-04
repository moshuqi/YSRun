//
//  YSPieChart.m
//  PieChartDemo
//
//  Created by moshuqi on 15/11/11.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSPieChart.h"

@interface YSPieChart ()

@property (nonatomic, assign) CGFloat pieChartRadius;   // 饼图的半径
@property (nonatomic, assign) CGFloat annularWidth;     // 圆环宽度，小于半径时饼图未圆环状

@property (nonatomic, assign) CGFloat startAngle;

@end

@implementation YSPieChart

const CGFloat kDistanceAngle = M_PI / 150;  // 颜色之间的间隙

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        
    }
    
    return self;
}

- (id)initWithData:(YSChartData *)data
    pieChartRadius:(CGFloat)pieChartRadius
      annularWidth:(CGFloat)annularWidth
{
    self = [super init];
    if (self)
    {
//        self.chartData = data;
//        self.pieChartRadius = pieChartRadius;
//        
//        self.annularWidth = annularWidth;
//        if (annularWidth > pieChartRadius)
//        {
//            self.annularWidth = pieChartRadius;
//        }
//        
//        // 为0则起点为圆右侧端点，逆时针绘起
//        self.startAngle = 0;
        
        [self setupWithChartData:data pieChartRadius:pieChartRadius annularWidth:annularWidth];
        
        // 根据图表半径设置视图大小
        CGSize size = CGSizeMake(pieChartRadius * 2, pieChartRadius * 2);
        self.frame = CGRectMake(0, 0, size.width, size.height);
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)setupWithChartData:(YSChartData *)chartData
            pieChartRadius:(CGFloat)pieChartRadius
              annularWidth:(CGFloat)annularWidth
{
    self.chartData = chartData;
    self.pieChartRadius = pieChartRadius;
    
    self.annularWidth = annularWidth;
    if (annularWidth > pieChartRadius)
    {
        self.annularWidth = pieChartRadius;
    }
    
    // 为0则起点为圆右侧端点，逆时针绘起
    self.startAngle = -M_PI_2;
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
    
    NSInteger count = [self.chartData elementCount];
    
    CGFloat totalAngle = 2 * M_PI - kDistanceAngle * count;  // 单位为弧度
    CGFloat currentDrawingAngle = self.startAngle;
    
    for (NSInteger i = 0; i < count; i++)
    {
        UIColor *color = [self.chartData getElementColorAtIndex:i];
        CGFloat percent = [self.chartData getElementPercentAtIndex:i];
        
        CGFloat drawingAngle = totalAngle * percent;
        CGPoint point = CGPointMake(CGRectGetWidth(self.bounds) / 2,
                                    CGRectGetHeight(self.bounds) / 2);
        CGFloat endAngle = currentDrawingAngle +drawingAngle;
        UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:point
                                                              radius:self.pieChartRadius - self.annularWidth / 2
                                                          startAngle:currentDrawingAngle
                                                            endAngle:endAngle
                                                           clockwise:YES];
        
        circle.lineWidth = self.annularWidth;
        circle.lineCapStyle = kCGLineCapButt;
        
        [color setStroke];
        [circle stroke];
        
        currentDrawingAngle += (drawingAngle + kDistanceAngle);
    }
}

- (CGRect)getElementLabelFrameAtIndex:(NSInteger)index
{
    CGFloat labelWidth = self.annularWidth;
    CGFloat labelHeight = labelWidth;
    
    CGPoint point = [self getElementPointAtIndex:index];
    CGRect frame = CGRectMake(point.x - labelWidth / 2, point.y - labelHeight / 2,
                              labelWidth, labelHeight);
    
    return frame;
}

- (CGPoint)getElementPointAtIndex:(NSInteger)index
{
    CGFloat percent = [self.chartData getElementPercentAtIndex:index];   // index所占比例
    
    CGFloat totalPercent = percent;     // 0~index总共所占比例
    for (NSInteger i = 0; i < index; i++)
    {
        totalPercent += [self.chartData getElementPercentAtIndex:i];
    }
    
    // index元素弧形中点的弧度
    CGFloat angle = self.startAngle + (2 * M_PI) * (totalPercent - percent / 2);
    
    CGPoint center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    CGFloat radius = self.pieChartRadius - self.annularWidth / 2;
    
    CGFloat x = center.x + radius * cosf(angle);
    CGFloat y = center.y + radius * sinf(angle);
    
    CGPoint point = CGPointMake(x, y);
    return point;
}

@end
