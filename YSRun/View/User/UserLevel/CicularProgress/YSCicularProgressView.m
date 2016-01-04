//
//  YSCicularProgressView.m
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSCicularProgressView.h"
#import "YSAppMacro.h"

@interface YSCicularProgressView ()

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat newProgerss;

@end

const CGFloat startAngle = M_PI_2 / 6;
const CGFloat angleDistance = M_PI_2 / 2;

const NSTimeInterval kTimeInterval = 0.6;   // 进度条的动画时间
const NSInteger kRedrawTimes = 30;          // 进度条动画过程中重绘的次数

@implementation YSCicularProgressView

- (id)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.lineWidth = lineWidth;
        self.backColor = RGBA(77, 77, 77, 0.6);
        self.progressColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    //draw background circle
    UIBezierPath *backCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2)
                                                              radius:(CGRectGetWidth(self.bounds) - self.lineWidth) / 2
                                                          startAngle:startAngle + angleDistance
                                                            endAngle:2 * M_PI + startAngle
                                                           clockwise:YES];
    [self.backColor setStroke];
    backCircle.lineWidth = self.lineWidth;
    backCircle.lineCapStyle = kCGLineCapRound;
    [backCircle stroke];
    
    if (self.progress)
    {
        //draw progress circle
        if (self.progress > 1.0)
        {
            self.progress = 1.0;
        }
        
        CGFloat totalAngle = 2 * M_PI - angleDistance;
        CGFloat currentAngle = totalAngle * self.progress;
        CGFloat start = startAngle - currentAngle;
        CGFloat end = startAngle;
        
        UIBezierPath *progressCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds) / 2,CGRectGetHeight(self.bounds) / 2)
                                                                      radius:(CGRectGetWidth(self.bounds) - self.lineWidth) / 2
                                                                  startAngle:start
                                                                    endAngle:end
                                                                   clockwise:YES];
        [self.progressColor setStroke];
        progressCircle.lineWidth = self.lineWidth;
        progressCircle.lineCapStyle = kCGLineCapRound;
        [progressCircle stroke];
    }
}

- (void)animationToProgress:(CGFloat)progress
{
    // 重绘数次来达到动画的效果
    self.newProgerss = progress;
    self.progress = 0.0;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(kTimeInterval / kRedrawTimes) target:self selector:@selector(updateProgressCircle) userInfo:nil repeats:YES];
}

- (void)updateProgressCircle
{
    if (self.progress >= self.newProgerss)
    {
        // 重绘一次
        [self setNeedsDisplay];
        [self.timer invalidate];
        return;
    }
    
    CGFloat d = self.newProgerss / kRedrawTimes;
    self.progress += d;
    [self setNeedsDisplay];
}

- (CGPoint)getGapPoint
{
    // 返回圆弧缺口段的中点
    
    CGFloat d = CGRectGetWidth(self.bounds);    // 进度视图必须为正方形
    CGFloat radius = (d - self.lineWidth) / 2;
    CGFloat angle = startAngle + angleDistance / 2;
    
    CGFloat x = d / 2 + radius * cosf(angle);
    CGFloat y = d / 2 + radius * sinf(angle);
    
    CGPoint point = CGPointMake(x, y);
    return point;
}

@end
