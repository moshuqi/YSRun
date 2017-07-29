//
//  YSCalendarTitleDateView.m
//  YSRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSCalendarTitleDateView.h"
#import "YSAppMacro.h"

@interface YSCalendarTitleDateView ()

@property (nonatomic, weak) IBOutlet UILabel *label;

@end

@implementation YSCalendarTitleDateView

- (void)awakeFromNib
{
    self.label.adjustsFontSizeToFitWidth = YES;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSCalendarTitleDateView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        containerView.backgroundColor = GreenBackgroundColor;
        
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)setLabelWithYear:(NSInteger)year month:(NSInteger)month
{
    NSString *text = [NSString stringWithFormat:@"%@年%@月", @(year), @(month)];
    self.label.text = text;
}

- (void)setTitleLabelFontSize:(CGFloat)fontSize
{
    self.label.font = [UIFont systemFontOfSize:fontSize];
}

- (IBAction)leftButtonClicked:(id)sender
{
    [self.delegate calendarTitleLeftButtonClicked];
}

- (IBAction)rightButtonClicked:(id)sender
{
    [self.delegate calendarTitleRightButtonClicked];
}

@end
