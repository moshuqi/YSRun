//
//  YSRunningModeDataView.m
//  YSRun
//
//  Created by moshuqi on 16/2/22.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSRunningModeDataView.h"
#import "YSDevice.h"

@interface YSRunningModeDataView ()

@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *paceLabel;
@property (nonatomic, weak) IBOutlet UILabel *heartRateLabel;

@end

@implementation YSRunningModeDataView

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    
    // 标签初始默认值
    [self setDistance:0.0];
    [self setPace:0.0];
    [self setHeartRate:0];
    
    self.distanceLabel.adjustsFontSizeToFitWidth = YES;
    self.paceLabel.adjustsFontSizeToFitWidth = YES;
    self.heartRateLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setDistance:(CGFloat)distance
{
    NSString *distanceStr = [NSString stringWithFormat:@"%.2f", distance];
    [self setupLabel:self.distanceLabel prefixStr:distanceStr prefixFontSize:[self prefixFontSize] suffixStr:[self distanceSuffixString] suffixFontSize:[self suffixFontSize]];
}

- (void)setPace:(CGFloat)pace
{
    NSString *paceStr = [NSString stringWithFormat:@"%.2f", pace];
    [self setupLabel:self.paceLabel prefixStr:paceStr prefixFontSize:[self prefixFontSize] suffixStr:[self paceSuffixString] suffixFontSize:[self suffixFontSize]];
}

- (void)setHeartRate:(NSInteger)heartRate
{
    // 心率数据为后台子线程监听，设置时需在主线程进行
    dispatch_async(dispatch_get_main_queue(), ^(){
        NSString *heartRateStr = (heartRate > 0) ? [NSString stringWithFormat:@"%@", @(heartRate)] : @"  -";
        [self setupLabel:self.heartRateLabel prefixStr:heartRateStr prefixFontSize:[self prefixFontSize] suffixStr:[self heartRateSuffixString] suffixFontSize:[self suffixFontSize]];
    });
}

- (void)setupLabel:(UILabel *)label prefixStr:(NSString *)prefixStr prefixFontSize:(CGFloat)prefixFontSize suffixStr:(NSString *)suffixStr suffixFontSize:(CGFloat)suffixFontSize
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", prefixStr, suffixStr]];
    
    NSInteger prefixLength = [prefixStr length];
    NSInteger length = [attributedText length];
    
    [attributedText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:prefixFontSize] range:NSMakeRange(0, prefixLength)];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:suffixFontSize] range:NSMakeRange(prefixLength, length - prefixLength)];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[self labelColor] range:NSMakeRange(0, length)];
    
    label.attributedText = attributedText;
}

- (UIColor *)labelColor
{
    return [UIColor whiteColor];
}

- (NSString *)distanceSuffixString
{
    NSString *str = @"  公里";
    return str;
}

- (NSString *)paceSuffixString
{
    NSString *str = @"  配速(分/公里)";
    return str;
}

- (NSString *)heartRateSuffixString
{
    NSString *str = @"   心率";
    return str;
}

- (CGFloat)prefixFontSize
{
    CGFloat fontSize = 28;
    if ([YSDevice isPhone6Plus])
    {
        fontSize = 40;
    }
    
    return fontSize;
}

- (CGFloat)suffixFontSize
{
    CGFloat fontSize = 12;
    if ([YSDevice isPhone6Plus])
    {
        fontSize = 16;
    }
    
    return fontSize;
}

@end
