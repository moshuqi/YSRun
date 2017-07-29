//
//  YSCalendarDayCell.m
//  YSRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSCalendarDayCell.h"

@interface YSCalendarDayCell ()

@property (nonatomic, weak) IBOutlet UILabel *dayLabel;
@property (nonatomic, strong) UIView *starView;
@property (nonatomic, assign) NSInteger starNumber;

@end

const CGFloat kStarViewHeight = 20;

@implementation YSCalendarDayCell

- (void)awakeFromNib
{
    [self initStarView];
}

- (void)initStarView
{
    if (!self.starView)
    {
        CGFloat width = CGRectGetWidth(self.contentView.bounds);
        CGFloat height = CGRectGetHeight(self.contentView.bounds);
        CGRect starViewFrame = CGRectMake(0, height - kStarViewHeight, width, height);
        
        self.starView = [[UIView alloc] initWithFrame:starViewFrame];
        [self.contentView addSubview:self.starView];
        
        self.starNumber = 0;
    }
}

- (void)setupCellWithModel:(YSDayCellModel *)model
{
    self.dayLabel.text = [NSString stringWithFormat:@"%@", @(model.day)];
    self.dayLabel.textColor = model.textColor;
    
    [self resetStarViewWithNumber:model.starNumber];
}

- (void)resetStarViewWithNumber:(NSInteger)number
{
    if (self.starNumber == number)
    {
        return;
    }
    
    self.starNumber = number;
    for (UIView *view in [self.starView subviews])
    {
        [view removeFromSuperview];
    }
    
    CGFloat starViewWidth = number * kStarViewHeight;
    CGFloat width = CGRectGetWidth(self.contentView.bounds);
    
    CGRect frame = CGRectMake((width - starViewWidth) / 2, self.starView.frame.origin.y, starViewWidth, kStarViewHeight);
    self.starView.frame = frame;
    
    for (NSInteger i = 0; i < number; i++)
    {
        UIImageView *starIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star.png"]];
        CGRect iconFrame = CGRectMake(i * kStarViewHeight, 0, kStarViewHeight, kStarViewHeight);
        starIcon.frame = iconFrame;
        
        [self.starView addSubview:starIcon];
    }
}

@end
