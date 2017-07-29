//
//  YSDataRecordLabelsView.m
//  YSRun
//
//  Created by moshuqi on 15/11/13.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSDataRecordLabelsView.h"

@interface YSDataRecordLabelsView ()

@property (nonatomic, weak) IBOutlet UILabel *countLabel;
@property (nonatomic, weak) IBOutlet UILabel *countSubscriptLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeSubscriptLabel;
@property (nonatomic, weak) IBOutlet UILabel *heartRateLabel;
@property (nonatomic, weak) IBOutlet UILabel *heartRateSubscriptLabel;

@end

@implementation YSDataRecordLabelsView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSDataRecordLabelsView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        containerView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self setLabelColor:[UIColor whiteColor]];
    [self setSubscriptLabelFontSize:10];
    [self setLabelFontSize:32];
}

- (void)setSubscriptLabelFontSize:(CGFloat)size
{
    self.countSubscriptLabel.font = [UIFont systemFontOfSize:size];
    self.timeSubscriptLabel.font = [UIFont systemFontOfSize:size];
    self.heartRateSubscriptLabel.font = [UIFont systemFontOfSize:size];
}

- (void)setLabelFontSize:(CGFloat)size
{
//    self.countLabel.font = [UIFont systemFontOfSize:size];
//    self.timeLabel.font = [UIFont systemFontOfSize:size];
//    self.heartRateLabel.font = [UIFont systemFontOfSize:size];
    
    self.countLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:size];
    self.timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:size];
    self.heartRateLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:size];
}

- (void)setLabelColor:(UIColor *)color
{
    self.countLabel.textColor = color;
    self.timeLabel.textColor = color;
    self.heartRateLabel.textColor = color;
    self.countSubscriptLabel.textColor = color;
    self.timeSubscriptLabel.textColor = color;
    self.heartRateSubscriptLabel.textColor = color;
}

- (void)setCountLabelWithText:(NSString *)text
{
    self.countLabel.text = text;
}

- (void)setTimeLabelWithText:(NSString *)text
{
    self.timeLabel.text = text;
}

- (void)setHeartRateLabelWithText:(NSString *)text
{
    self.heartRateLabel.text = text;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
