//
//  YSBLEHeartRateCountingView.m
//  YSRun
//
//  Created by moshuqi on 15/11/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSBLEHeartRateCountingView.h"
#import "YSBurningMarkView.h"
#import "YSAppMacro.h"

@interface YSBLEHeartRateCountingView ()

@property (nonatomic, weak) IBOutlet YSBurningMarkView *burningMarkView;
@property (nonatomic, strong) UIImageView *heartIcon;

@property (nonatomic, assign) CGFloat currentHeartRate;
@property (nonatomic, strong) UIView *line;

@end

const CGFloat kBuringMinValue = 140;
const CGFloat kBuringMaxValue = 160;
const CGFloat kHeartRateMaxValue = 220;

@implementation YSBLEHeartRateCountingView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.currentHeartRate = 0;
    
    UIImage *heartImage = [UIImage imageNamed:@"heart_icon"];
    self.heartIcon = [[UIImageView alloc] initWithImage:heartImage];
    [self addSubview:self.heartIcon];
    
    self.line = [UIView new];
    self.line.backgroundColor = RGB(255, 162, 143);
    [self addSubview:self.line];
    
    self.backgroundColor = RGB(89, 168, 137);
}

- (void)updateWithHeartRate:(CGFloat)heartRate
{
    self.currentHeartRate = heartRate;
    
    CGPoint center = [self getHeartIconCenterWithHeartRate:heartRate];
    self.heartIcon.center = center;
    
    CGFloat lineHeight = 2;
    CGRect lineFrame = CGRectMake(0, center.y - (lineHeight / 2), center.x, lineHeight);
    self.line.frame = lineFrame;
    
//    [self setNeedsDisplay];
}

- (CGPoint)getHeartIconCenterWithHeartRate:(CGFloat)heartRate
{
    CGFloat d = 10;     // 和上边缘间距
    CGFloat iconWidth = CGRectGetWidth(self.heartIcon.frame);
    CGFloat iconHeight = CGRectGetHeight(self.heartIcon.frame);
    
    CGFloat x = [self getOriginXByHeartRate:heartRate];
    if (x < iconWidth / 2)
    {
        x = iconWidth / 2;
    }
    else if (x > (CGRectGetWidth(self.frame) - iconWidth / 2))
    {
        x = CGRectGetWidth(self.frame) - iconWidth / 2;
    }
    
    CGPoint center = CGPointMake(x, d + iconHeight / 2);
    return center;
}


- (CGFloat)getOriginXByHeartRate:(CGFloat)heartRate
{
    CGFloat l = 0;  // 当前所在区间的总长度
    CGFloat scale = 0;
    CGFloat distance = 0;   // 累加距离
    
    if (heartRate < kBuringMinValue)
    {
        l = self.burningMarkView.frame.origin.x;
        scale = heartRate / kBuringMinValue;
    }
    else if (heartRate > kBuringMaxValue)
    {
        l = CGRectGetWidth(self.frame) - (self.burningMarkView.frame.origin.x + self.burningMarkView.frame.size.width);
        scale = (heartRate - kBuringMaxValue) / (kHeartRateMaxValue - kBuringMaxValue);
        distance = self.burningMarkView.frame.origin.x + self.burningMarkView.frame.size.width;
    }
    else
    {
        // 在燃脂区间内
        l = self.burningMarkView.frame.size.width;
        scale = (heartRate - kBuringMinValue) / (kBuringMaxValue - kBuringMinValue);
        distance = self.burningMarkView.frame.origin.x;
    }
    
    CGFloat x = distance + l * scale;
    return x;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    
//    CGPoint center = [self getHeartIconCenterWithHeartRate:self.currentHeartRate];
//    CGPoint startPoint = CGPointMake(0, center.y);
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 2);
//    
//    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
//    CGContextAddLineToPoint(context, center.x, center.y);
//    
//    UIColor *color = RGB(255, 162, 143);
//    CGContextSetStrokeColorWithColor(context, color.CGColor);
//    
//    CGContextStrokePath(context);
//}


@end
