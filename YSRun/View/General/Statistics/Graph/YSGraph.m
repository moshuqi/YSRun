//
//  YSGraph.m
//  PieChartDemo
//
//  Created by moshuqi on 15/11/12.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSGraph.h"
#import "YSGraphPoint.h"
#import "YSGraphData.h"
#import "YSAppMacro.h"

@interface YSGraph ()

@property (nonatomic, strong) YSGraphData *graphData;
@property (nonatomic, strong) UIColor *topColor;
@property (nonatomic, strong) UIColor *middleColor;
@property (nonatomic, strong) UIColor *bottomColor;

@end

@implementation YSGraph

// 曲线起点和终点距离左右两侧边缘的距离
const CGFloat kStartDistance = 10;
const CGFloat kEndDistance = 0;


- (void)setupWithGraphData:(YSGraphData *)graphData
{
    self.graphData = graphData;
}

- (void)setBackgroundWithTopColor:(UIColor *)topColor middleColor:(UIColor *)middleColor bottomColor:(UIColor *)bottomColor
{
    self.topColor = topColor;
    self.middleColor = topColor;
    self.bottomColor = bottomColor;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    if ([self.graphData dataCount] < 3)
    {
        return;
    }
    
    [self drawBackgroundColor];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, RGB(255, 245, 193).CGColor);
    CGContextSetLineWidth(context, 4.0);
    
    CGPoint point1 = [self pointFromGraphPoint:[self.graphData graphPointAtIndex:0]];
    CGPoint point2 = [self pointFromGraphPoint:[self.graphData graphPointAtIndex:1]];
    CGPoint midPoint1 = [self midPointWithPoint1:point1 point2:point2];
    
    // 绘制平滑曲线
    CGContextMoveToPoint(context, midPoint1.x, midPoint1.y);
    for (NSInteger i = 2; i < [self.graphData dataCount]; i++)
    {
        YSGraphPoint *graphPoint = [self.graphData graphPointAtIndex:i];
        point1 = [self pointFromGraphPoint:[self.graphData graphPointAtIndex:(i - 1)]];
        point2 = [self pointFromGraphPoint:graphPoint];
        
        CGPoint midPoint2 = [self midPointWithPoint1:point1 point2:point2];
        CGContextAddQuadCurveToPoint(context, point1.x, point1.y, midPoint2.x, midPoint2.y);
    }
    
    CGContextStrokePath(context);
}

- (void)drawBackgroundColor
{
    // 绘制背景的颜色，每种颜色高度相等。
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    NSInteger sectionCount = 3; // 背景有3种颜色
    CGFloat sectionHeight = height / sectionCount;
    
    NSArray *colorArray = @[[self.graphData getTopColor], [self.graphData getMiddleColor], [self.graphData getBottomColor]];
    for (NSInteger i = 0; i < sectionCount; i++)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetStrokeColorWithColor(context, ((UIColor *)colorArray[i]).CGColor);
        CGContextSetLineWidth(context, sectionHeight);
        
        CGFloat originY = sectionHeight * i + sectionHeight / 2;
        CGPoint point = CGPointMake(0, originY);
        CGContextMoveToPoint(context, point.x, point.y);
        
        CGPoint toPoint = CGPointMake(width, originY);
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
        
        CGContextStrokePath(context);
    }
}

- (CGPoint)midPointWithPoint1:(CGPoint)point1 point2:(CGPoint)point2
{
    CGPoint midPoint = CGPointMake((point1.x + point2.x) / 2, (point1.y + point2.y) / 2);
    return midPoint;
}

- (CGPoint)pointFromGraphPoint:(YSGraphPoint *)graphPoint
{
    // 将graphPoint转化为映射到坐标上的点
    CGFloat width = CGRectGetWidth(self.frame) - kStartDistance - kEndDistance;
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat abscissaMax = self.graphData.abscissaMax;
    CGFloat abscissaMin = self.graphData.abscissaMin;
    
    CGFloat ordinateMax = self.graphData.ordinateMax;
    CGFloat ordinateMin = self.graphData.ordinateMin;
    
    CGFloat middleSectionMax = self.graphData.middleSectionMax;
    CGFloat middleSectionMin = self.graphData.middleSectionMin;
    
    CGFloat dx = abscissaMax - abscissaMin;
    CGFloat x = graphPoint.abscissaValue - abscissaMin;
    CGFloat scaleX = x / dx;
    CGFloat originX = width * scaleX + kStartDistance;
    
    CGFloat originY;
    CGFloat sectionHeight = height / 3;
    if (graphPoint.ordinateValue < middleSectionMin)
    {
        // 在下方区域
        CGFloat dyBottom = middleSectionMin - ordinateMin;
        CGFloat y = graphPoint.ordinateValue - ordinateMin;
        CGFloat scaleY = y / dyBottom;
        
        originY = height - sectionHeight * scaleY;
    }
    else if ((graphPoint.ordinateValue >= middleSectionMin) &&
             (graphPoint.ordinateValue <= middleSectionMax))
    {
        // 在中间区域
        CGFloat dyMiddle = middleSectionMax - middleSectionMin;
        CGFloat y = graphPoint.ordinateValue - middleSectionMin;
        CGFloat scaleY = y / dyMiddle;
        
        originY = height - sectionHeight * scaleY - sectionHeight;
    }
    else
    {
        // 在上方区域
        CGFloat dyTop = ordinateMax - middleSectionMax;
        CGFloat y = graphPoint.ordinateValue - middleSectionMax;
        CGFloat scaleY = y / dyTop;
        
        originY = height - sectionHeight * scaleY - sectionHeight * 2;
    }
    
    CGPoint point = CGPointMake(originX, originY);
    
    return point;
}

- (NSArray *)getPoints
{
    // 获取对应实际坐标点的数组
    NSMutableArray *points = [NSMutableArray array];
    NSInteger count = [self.graphData dataCount];
    
    for (NSInteger i = 0; i < count; i++)
    {
        YSGraphPoint *graphPoint = [self.graphData graphPointAtIndex:i];
        CGPoint point = [self pointFromGraphPoint:graphPoint];
        
        [points addObject:[NSValue valueWithCGPoint:point]];
    }
    
    return points;
}


@end
