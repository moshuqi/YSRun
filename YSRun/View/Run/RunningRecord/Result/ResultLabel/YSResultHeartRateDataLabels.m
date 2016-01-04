//
//  YSResultHeartRateDataLabels.m
//  YSRun
//
//  Created by moshuqi on 15/11/23.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSResultHeartRateDataLabels.h"
#import "YSDevice.h"

@interface YSResultHeartRateDataLabels ()

@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *calorieLabel;
@property (nonatomic, weak) IBOutlet UILabel *heartRateLabel;

@property (nonatomic, weak) IBOutlet UIImageView *arrow;

@end

@implementation YSResultHeartRateDataLabels

//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super initWithCoder:aDecoder])
//    {
//        UIView *containerView = [[[UINib nibWithNibName:@"YSResultHeartRateDataLabels" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
//        
//        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//        containerView.frame = newFrame;
//        containerView.backgroundColor = [UIColor clearColor];
//        
//        [self addSubview:containerView];
//        
//        self.backgroundColor = [UIColor clearColor];
//    }
//    
//    return self;
//}

- (void)awakeFromNib
{
    self.arrow.image = [UIImage imageNamed:@"detail_arrow"];
    
    [self addGesture];
}

- (void)addGesture
{
    // 添加手势响应，点击时跳转到详细界面
    self.heartRateLabel.userInteractionEnabled = YES;
    self.arrow.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.heartRateLabel addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.arrow addGestureRecognizer:tap2];
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    [self.delegate heartRateDataLabelsTapDetail];
}

- (void)setDistance:(CGFloat)distance time:(NSString *)time calorie:(CGFloat)calorie heartRateProportion:(CGFloat)proportion
{
    [self setLabel:self.distanceLabel
       textContent:[NSString stringWithFormat:@"%.2f", distance]
            suffix:[self distanceSuffix]];
    
    [self setLabel:self.timeLabel
       textContent:[NSString stringWithFormat:@"%@", time]
            suffix:[self timeSuffix]];
    
    [self setLabel:self.calorieLabel
       textContent:[NSString stringWithFormat:@"%@", @((NSInteger)calorie)]
            suffix:[self calorieSuffix]];
    
    NSInteger p = (NSInteger)(proportion * 100);
    [self setLabel:self.heartRateLabel
       textContent:[NSString stringWithFormat:@"%@%%", @(p)]
            suffix:[self heartRateSuffix]];
}

- (void)setLabel:(UILabel *)label textContent:(NSString *)content suffix:(NSString *)suffix
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", content, suffix]];
    
    NSInteger length = [str length];
    NSInteger suffixLength = [suffix length];
    
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:[self contentFontSize]] range:NSMakeRange(0, length - suffixLength)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:[self suffixFontSize]] range:NSMakeRange(length - suffixLength, suffixLength)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,length)];
    
    label.attributedText = str;
    label.adjustsFontSizeToFitWidth = YES;
}

- (CGFloat)contentFontSize
{
    CGFloat fontSize = 16;
    if ([YSDevice isPhone6Plus])
    {
        fontSize = 18;
    }
    return fontSize;
}

- (CGFloat)suffixFontSize
{
    CGFloat fontSize = 10;
    if ([YSDevice isPhone6Plus])
    {
        fontSize = 12;
    }
    return fontSize;
}

- (NSString *)distanceSuffix
{
    return @"公里";
}

- (NSString *)timeSuffix
{
    return @"时长";
}

- (NSString *)calorieSuffix
{
    return @"大卡";
}

- (NSString *)heartRateSuffix
{
    return @"心率达标";
}

@end
