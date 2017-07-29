//
//  YSResultRunDataLabels.m
//  YSRun
//
//  Created by moshuqi on 15/12/11.
//  Copyright © 2015年 msq. All rights reserved.
//

// 跑步完成后记录不包括心率的数据

#import "YSResultRunDataLabels.h"
#import "YSDevice.h"

@interface YSResultRunDataLabels ()

@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *calorieLabel;

@property (nonatomic, weak) IBOutlet UIImageView *arrow;

@end

@implementation YSResultRunDataLabels

//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super initWithCoder:aDecoder])
//    {
//        UIView *containerView = [[[UINib nibWithNibName:@"YSResultRunDataLabels" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
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
    [super awakeFromNib];
    
    self.arrow.image = [UIImage imageNamed:@"detail_arrow"];
    [self addGesture];
}

- (void)addGesture
{
    // 添加手势响应，点击时跳转到详细界面
    self.calorieLabel.userInteractionEnabled = YES;
    self.arrow.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.calorieLabel addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.arrow addGestureRecognizer:tap2];
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    [self.delegate runDataLabelsTapDetail];
}

- (void)setDistance:(CGFloat)distance time:(NSString *)time calorie:(CGFloat)calorie
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

@end
