//
//  YSPopView.m
//  YSRun
//
//  Created by moshuqi on 16/2/24.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSPopView.h"
#import "YSAppMacro.h"

@interface YSPopView ()

@property (nonatomic, assign) CGPoint arrowPoint;

@property (nonatomic, strong) UIView *tapView;  // 遮住整个界面的带手势的视图，点击之后弹窗消失
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, assign) CGFloat arrowHeight;

@end

@implementation YSPopView

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    
    self.arrowPoint = CGPointZero;
    self.fillColor = [UIColor whiteColor];
    self.arrowHeight = 5;
}

- (void)drawRect:(CGRect)rect
{
    // 绘制带箭头的弹框，只考虑箭头朝上的情况
    
    if (CGPointEqualToPoint(self.arrowPoint, CGPointZero))
    {
        return;
    }
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat spacing = 10; // 绘制的线框与视图左右下边缘的间距
    CGFloat arrowHeight = self.arrowHeight;   // 箭头的高
    CGFloat arrowBase = 10;     // 箭头的底边长度
    CGFloat cornerRadius = 10;   // 线框圆角
    
    UIColor *color = self.fillColor;  // 弹窗的背景颜色
    
    // 线框的四个顶点坐标
    CGPoint topLeft = CGPointMake(spacing, arrowHeight);
    CGPoint topRight = CGPointMake(width - spacing, arrowHeight);
    CGPoint bottomLeft = CGPointMake(spacing, height - spacing);
    CGPoint bottomRight = CGPointMake(width - spacing, height - spacing);
    
    // 箭头底边两点坐标
    CGPoint arrowleft = CGPointMake(self.arrowPoint.x - arrowBase / 2, arrowHeight);
    CGPoint arrowRight = CGPointMake(self.arrowPoint.x + arrowBase / 2, arrowHeight);
    
    // 绘制边框路径
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 1);
    
    // 左上角圆角
    CGPoint topLeftStart = CGPointMake(topLeft.x, topLeft.y + cornerRadius);
    CGPoint topLeftEnd = CGPointMake(topLeft.x + cornerRadius, topLeft.y);
    
    CGContextMoveToPoint(context, topLeftStart.x, topLeftStart.y);
    CGContextAddQuadCurveToPoint(context, topLeft.x, topLeft.y, topLeftEnd.x, topLeftEnd.y);
    
    // 上边线、箭头、右上角圆角
    CGPoint topRightStart = CGPointMake(topRight.x - cornerRadius, topRight.y);
    CGPoint topRightEnd = CGPointMake(topRight.x, topRight.y + cornerRadius);
    
    CGContextAddLineToPoint(context, arrowleft.x, arrowleft.y);
    CGContextAddLineToPoint(context, self.arrowPoint.x, self.arrowPoint.y);
    CGContextAddLineToPoint(context, arrowRight.x, arrowRight.y);
    
    CGContextAddLineToPoint(context, topRightStart.x, topRightStart.y);
    CGContextAddQuadCurveToPoint(context, topRight.x, topRight.y, topRightEnd.x, topRightEnd.y);
    
    // 右边线、右下角圆角
    CGPoint bottomRightStart = CGPointMake(bottomRight.x, bottomRight.y - cornerRadius);
    CGPoint bottomRightEnd = CGPointMake(bottomRight.x - cornerRadius, bottomRight.y);
    
    CGContextAddLineToPoint(context, bottomRightStart.x, bottomRightStart.y);
    CGContextAddQuadCurveToPoint(context, bottomRight.x, bottomRight.y, bottomRightEnd.x, bottomRightEnd.y);
    
    // 下边线、左下角圆角
    CGPoint bottomLeftStart = CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y);
    CGPoint bottomLeftEnd = CGPointMake(bottomLeft.x, bottomLeft.y - cornerRadius);
    
    CGContextAddLineToPoint(context, bottomLeftStart.x, bottomLeftStart.y);
    CGContextAddQuadCurveToPoint(context, bottomLeft.x, bottomLeft.y, bottomLeftEnd.x, bottomLeftEnd.y);
    
    CGContextClosePath(context);

    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
    
    CGContextStrokePath(context);
}

- (void)showPopViewWithFrame:(CGRect)frame fromView:(UIView *)fromView atPoint:(CGPoint)point
{
    self.frame = frame;
    self.arrowPoint = point;
    
    [fromView addSubview:self];
    [self setNeedsDisplay];
    
    [self addTapView];
}

- (void)addContentView:(UIView *)contentView
{
    // 添加弹窗中间显示的内容视图
    CGRect frame = CGRectMake((CGRectGetWidth(self.frame) - CGRectGetWidth(contentView.frame)) / 2,
                               (CGRectGetHeight(self.frame) - CGRectGetHeight(contentView.frame)) / 2,
                              CGRectGetWidth(contentView.frame), CGRectGetHeight(contentView.frame));
    contentView.frame = frame;
    [self addSubview:contentView];
}

- (void)addTapView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.tapView = [[UIView alloc] initWithFrame:window.bounds];
    [window addSubview:self.tapView];
    
    self.tapView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.tapView addGestureRecognizer:tapGesture];
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    [self.tapView removeFromSuperview];
    self.tapView = nil;
    
    [self removeFromSuperview];
}

- (void)setColor:(UIColor *)color
{
    self.fillColor = color;
}

- (void)setArrowHeight:(CGFloat)arrowHeight
{
    _arrowHeight = arrowHeight;
}

@end
