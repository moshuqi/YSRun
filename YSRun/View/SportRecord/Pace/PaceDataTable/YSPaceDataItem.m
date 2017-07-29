//
//  YSPaceDataItem.m
//  YSRun
//
//  Created by moshuqi on 16/1/27.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSPaceDataItem.h"
#import "YSBarProgressView.h"
#import "YSPaceSectionDataModel.h"
#import "YSDevice.h"
#import "YSAppMacro.h"

@interface YSPaceDataItem ()

@property (nonatomic, weak) IBOutlet UILabel *numberLabel;
@property (nonatomic, weak) IBOutlet UILabel *paceValueLabel;
@property (nonatomic, weak) IBOutlet YSBarProgressView *barProgress;

@property (nonatomic, strong) YSPaceSectionDataModel *sectionDataModel;

@end

@implementation YSPaceDataItem

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    
    return self;
}

- (void)awakeFromNib
{
    CGFloat height = CGRectGetHeight(self.barProgress.frame);
    self.barProgress.layer.cornerRadius = height / 2;
    self.barProgress.clipsToBounds = YES;
}

- (void)setupWithPaceSectionDataModel:(YSPaceSectionDataModel *)model
{
    self.sectionDataModel = model;
    
    [self setupLabels];
    
    [self.barProgress setupProgress:model.progress];
}

- (void)setupLabels
{
    // 设置标签的值
    NSString *numberText;
    if (self.sectionDataModel.isLastSection)
    {
        // 最后一段公里数显示两位小数
        numberText = [NSString stringWithFormat:@"%.2f", self.sectionDataModel.section];
    }
    else
    {
        numberText = [NSString stringWithFormat:@"%.0f", self.sectionDataModel.section];
    }
    
    self.numberLabel.text = numberText;
    self.paceValueLabel.text = [NSString stringWithFormat:@"%.2f", self.sectionDataModel.pace];
    
    self.numberLabel.font = [UIFont systemFontOfSize:[self labelFontSize]];
    self.paceValueLabel.font = [UIFont systemFontOfSize:[self labelFontSize]];
    
    self.numberLabel.textColor = [self textColor];
    self.paceValueLabel.textColor = [self textColor];
}

- (CGFloat)labelFontSize
{
    CGFloat fontSize = 12;
    if ([YSDevice isPhone6Plus])
    {
        fontSize = 16;
    }
    
    return fontSize;
}

- (UIColor *)textColor
{
    UIColor *color = RGB(81, 81, 81);
    return color;
}

@end
