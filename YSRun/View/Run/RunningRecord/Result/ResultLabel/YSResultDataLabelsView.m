//
//  YSResultDataLabelsView.m
//  YSRun
//
//  Created by moshuqi on 16/2/23.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSResultDataLabelsView.h"
#import "YSMarkLabel.h"
#import "YSDevice.h"

@interface YSResultDataLabelsView ()

@property (nonatomic, weak) IBOutlet YSMarkLabel *distanceMarkLabel;
@property (nonatomic, weak) IBOutlet YSMarkLabel *timeMarkLabel;
@property (nonatomic, weak) IBOutlet YSMarkLabel *calorieMarkLabel;

@property (nonatomic, weak) IBOutlet UILabel *standardRateLabel;

@end

@implementation YSResultDataLabelsView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSResultDataLabelsView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        containerView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:containerView];
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupMarkLabel];
}

- (void)setupMarkLabel
{
    // 初始化设置标签的默认值
    CGFloat contentFontSize = 28;
    CGFloat markFontSize = 12;
    if ([YSDevice isPhone6Plus])
    {
        contentFontSize = 36;
        markFontSize = 12;
    }
    
    [self.distanceMarkLabel setContentBoldWithFontSize:contentFontSize];
    [self.timeMarkLabel setContentBoldWithFontSize:contentFontSize];
    [self.calorieMarkLabel setContentBoldWithFontSize:contentFontSize];
    
    [self.distanceMarkLabel setMarkFontSize:markFontSize];
    [self.timeMarkLabel setMarkFontSize:markFontSize];
    [self.calorieMarkLabel setMarkFontSize:markFontSize];
    
    [self.distanceMarkLabel setTextColor:[self textColor]];
    [self.timeMarkLabel setTextColor:[self textColor]];
    [self.calorieMarkLabel setTextColor:[self textColor]];
    
    [self.distanceMarkLabel setContentText:@"0.00"];
    [self.timeMarkLabel setContentText:@"00:00:00"];
    [self.calorieMarkLabel setContentText:@"0"];
    
    [self.distanceMarkLabel setMarkText:@"公里"];
    [self.timeMarkLabel setMarkText:@""];
    [self.calorieMarkLabel setMarkText:@"卡"];
    
    [self setStandarRate:0];
}

- (void)setupWithDistance:(NSString *)distance
                     time:(NSString *)time
                  calorie:(NSString *)calorie
{
    [self.distanceMarkLabel setContentText:distance];
    [self.timeMarkLabel setContentText:time];
    [self.calorieMarkLabel setContentText:calorie];
}

- (void)setStandarRate:(CGFloat)rate
{
    NSString *prefixStr;
    if (rate <= 0 || rate > 1)
    {
        // 直接显示“0%”
        prefixStr = @"0%";
    }
    else
    {
        NSInteger p = (NSInteger)(rate * 100);
        prefixStr = [NSString stringWithFormat:@"%@%%", @(p)];
    }
    
    NSString *suffixStr = @"的心率达标";
    
    CGFloat prefixFontSize = 24;
    CGFloat suffixFontSize = 12;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", prefixStr, suffixStr]];
    
    [attributedText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:prefixFontSize] range:NSMakeRange(0, [prefixStr length])];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:suffixFontSize] range:NSMakeRange([prefixStr length], [suffixStr length])];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[self textColor] range:NSMakeRange(0, [attributedText length])];
    
    self.standardRateLabel.attributedText = attributedText;
}

- (UIColor *)textColor
{
    return [UIColor whiteColor];
}

@end
