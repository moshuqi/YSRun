//
//  YSGraphCanvas.m
//  YSRun
//
//  Created by moshuqi on 15/12/9.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSGraphCanvas.h"
#import "YSStatisticsDefine.h"
#import "YSAppMacro.h"
#import "YSGraphData.h"
#import "YSGraphPoint.h"

typedef NS_ENUM(NSInteger, YSGraphInterceptionType)
{
    YSGraphInterceptionTypeTop = 1,
    YSGraphInterceptionTypeMiddle,
    YSGraphInterceptionTypeBottom
};

@interface YSGraphCanvas ()

@property (nonatomic, strong) YSGraphData *graphData;
@property (nonatomic, copy) NSArray *pointArray;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *lineColor;

@end

@implementation YSGraphCanvas

- (id)initWithFrame:(CGRect)frame graphData:(YSGraphData *)graphData
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.graphData = graphData;
    }
    
    return self;
}

//- (id)initWithFrame:(CGRect)frame pointArray:(NSArray *)pointArray
//{
//    self = [super initWithFrame:frame];
//    if (self)
//    {
//        self.pointArray = pointArray;
//    }
//    
//    return self;
//}

- (UIImage *)getGraphImageWithSize:(CGSize)size
{
    self.pointArray = [self getPoints];
    
    UIImage *topImage = [self getInterceptionPartWithType:YSGraphInterceptionTypeTop backgroundColor:AnaerobicExerciseColor lineColor:AnaerobicExerciseLineColor];
    UIImage *middleImage = [self getInterceptionPartWithType:YSGraphInterceptionTypeMiddle backgroundColor:EfficientReduceFatColor lineColor:EfficientReduceFatLineColor];
    UIImage *bottomImage = [self getInterceptionPartWithType:YSGraphInterceptionTypeBottom backgroundColor:JoggingColor lineColor:JoggingLineColor];
    
    CGFloat imageWidth = size.width;
    CGFloat imageHeight = size.height / 3;
    
    UIGraphicsBeginImageContextWithOptions(size,NO,1);
    
    CGRect topRect = CGRectMake(0, 0, imageWidth, imageHeight);
    [topImage drawInRect:topRect];
    
    CGRect middleRect = CGRectMake(0, imageHeight, imageWidth, imageHeight);
    [middleImage drawInRect:middleRect];
    
    CGRect bottomRect = CGRectMake(0, imageHeight * 2, imageWidth, imageHeight);
    [bottomImage drawInRect:bottomRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)getInterceptionPartWithType:(YSGraphInterceptionType)type backgroundColor:(UIColor *)backgroundColor lineColor:(UIColor *)lineColor
{
    self.backgroundColor = backgroundColor;
    self.lineColor = lineColor;
    
    // 重绘一遍
    [self setNeedsDisplay];
    
    CGRect interceptionRect = [self getInterceptionRectWithType:type];
    UIImage *image = [self getImageWithRect:interceptionRect];
    
    return image;
}

- (CGRect)getInterceptionRectWithType:(YSGraphInterceptionType)type
{
    // 获取需要截取的rect
    CGRect rect = CGRectZero;
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat originY = 0;
    if (type == YSGraphInterceptionTypeMiddle)
    {
        originY = height / 3;
    }
    else if (type == YSGraphInterceptionTypeBottom)
    {
        originY = height / 3 * 2;
    }
    
    rect = CGRectMake(0, originY, width, height / 3);
    return rect;
}

- (UIImage *)getImageWithRect:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 1);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    //UIImageWriteToSavedPhotosAlbum(img, self, nil, nil);
    UIGraphicsEndImageContext();
    
    CGImageRef imgRef = CGImageCreateWithImageInRect(img.CGImage, rect);
    UIImage *resultImg = [UIImage imageWithCGImage:imgRef];
    
    // 记住加上这个，否则会导致内存泄露
    CGImageRelease(imgRef);
    imgRef = nil;
    
    return resultImg;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    NSInteger count = [self.pointArray count];
    if (count < 3)
    {
        return;
    }
    
    [self drawBackgroundColor];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineWidth(context, 4.0);
    
    CGPoint point1 = [self.pointArray[0] CGPointValue];
    CGPoint point2 = [self.pointArray[1] CGPointValue];
    CGPoint midPoint1 = [self midPointWithPoint1:point1 point2:point2];
    
    // 绘制平滑曲线
    CGContextMoveToPoint(context, midPoint1.x, midPoint1.y);
    for (NSInteger i = 2; i < count; i++)
    {
        point1 = [self.pointArray[i - 1] CGPointValue];
        point2 = [self.pointArray[i] CGPointValue];
        
        CGPoint midPoint2 = [self midPointWithPoint1:point1 point2:point2];
        CGContextAddQuadCurveToPoint(context, point1.x, point1.y, midPoint2.x, midPoint2.y);
    }
    
    CGContextStrokePath(context);
}

- (void)drawBackgroundColor
{
    // 绘制背景的颜色
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, self.backgroundColor.CGColor);
    CGContextSetLineWidth(context, height);
    
    CGFloat originY = height / 2;
    CGPoint point = CGPointMake(0, originY);
    CGContextMoveToPoint(context, point.x, point.y);
    
    CGPoint toPoint = CGPointMake(width, originY);
    CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
    
    CGContextStrokePath(context);
}

- (CGPoint)midPointWithPoint1:(CGPoint)point1 point2:(CGPoint)point2
{
    CGPoint midPoint = CGPointMake((point1.x + point2.x) / 2, (point1.y + point2.y) / 2);
    return midPoint;
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

- (CGPoint)pointFromGraphPoint:(YSGraphPoint *)graphPoint
{
    // 将graphPoint转化为映射到坐标上的点
    CGFloat width = CGRectGetWidth(self.frame);
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
    CGFloat originX = width * scaleX;
    
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

@end
