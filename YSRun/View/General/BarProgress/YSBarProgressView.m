//
//  YSBarProgressView.m
//  YSRun
//
//  Created by moshuqi on 16/1/27.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSBarProgressView.h"
#import "YSAppMacro.h"
#import <UIKit/UIKit.h>

@interface YSBarProgressView ()

@property (nonatomic, strong) UIColor *barColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) CGFloat progress;

@end

@implementation YSBarProgressView

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setDefaultColor];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setDefaultColor];
    }
    
    return self;
}

- (void)setDefaultColor
{
    self.barColor = [self defaultBarColor];
    self.backgroundColor = [self defaultBackgroundColor];
}

- (UIColor *)defaultBarColor
{
    return RGB(163, 239, 76);
}

- (UIColor *)defaultBackgroundColor
{
    return RGB(155, 149, 149);
}

- (void)setupProgress:(CGFloat)progress
{
    self.progress = progress;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGPoint fromPoint = CGPointMake(0, height / 2);
    CGPoint toPoint = CGPointMake(width, height / 2);
    
    // 先画背景
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, height);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGContextMoveToPoint(context, fromPoint.x, fromPoint.y);
    CGContextSetStrokeColorWithColor(context, self.backgroundColor.CGColor);
    
    CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
    CGContextStrokePath(context);
    
    // 画进度条
    if (self.progress > 0)
    {
        CGPoint progressToPoint = CGPointMake(width * self.progress, height / 2);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, height);
        CGContextSetLineCap(context, kCGLineCapRound);
        
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y);
        CGContextSetStrokeColorWithColor(context, self.barColor.CGColor);
        
        CGContextAddLineToPoint(context, progressToPoint.x, progressToPoint.y);
        CGContextStrokePath(context);
    }
}

@end
