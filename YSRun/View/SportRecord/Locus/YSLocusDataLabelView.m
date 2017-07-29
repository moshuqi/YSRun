//
//  YSLocusDataLabelView.m
//  YSRun
//
//  Created by moshuqi on 16/1/25.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSLocusDataLabelView.h"
#import "YSTimeFunc.h"
#import "YSAppMacro.h"

@interface YSLocusDataLabelView ()

@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@end

@implementation YSLocusDataLabelView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSLocusDataLabelView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        containerView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.distanceLabel.adjustsFontSizeToFitWidth = YES;
    self.timeLabel.adjustsFontSizeToFitWidth = YES;
    
    // 背景灰色透明色
    self.backgroundColor = RGBA(98, 98, 98, 0.68);
}

- (void)setupWithDistance:(CGFloat)distance useTime:(NSInteger)useTime
{
    // 根据数据设置标签
    
    // 设置公里标签
    NSString *suffixStr = @"公里";
    NSString *distanceStr = [NSString stringWithFormat:@"%.2f", distance];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", distanceStr, suffixStr]];
    
    UIFont *bigFont = [UIFont systemFontOfSize:33];
    UIFont *normalFont = [UIFont systemFontOfSize:20];
    
    NSInteger length = [str length];
    NSInteger suffixLength = [suffixStr length];
    
    [str addAttribute:NSFontAttributeName value:bigFont range:NSMakeRange(0, length - suffixLength)];
    [str addAttribute:NSFontAttributeName value:normalFont range:NSMakeRange(length - suffixLength, suffixLength)];
    
    self.distanceLabel.attributedText = str;
    
    // 设置时间标签
    NSString *timeStr = [YSTimeFunc timeStrFromUseTime:useTime];
    self.timeLabel.text = timeStr;
    self.timeLabel.font = [UIFont systemFontOfSize:23];
    
}

@end
