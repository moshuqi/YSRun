//
//  YSCalendarWeekdayView.m
//  YSRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSCalendarWeekdayView.h"
#import "YSAppMacro.h"

@interface YSCalendarWeekdayView ()

@property (nonatomic, weak) IBOutlet UILabel *sunLabel;
@property (nonatomic, weak) IBOutlet UILabel *monLabel;
@property (nonatomic, weak) IBOutlet UILabel *wedLabel;
@property (nonatomic, weak) IBOutlet UILabel *thuLabel;
@property (nonatomic, weak) IBOutlet UILabel *friLabel;
@property (nonatomic, weak) IBOutlet UILabel *satLabel;
@property (nonatomic, weak) IBOutlet UILabel *tueLabel;

@end

@implementation YSCalendarWeekdayView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSCalendarWeekdayView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        containerView.backgroundColor = GreenBackgroundColor;
        
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)setLabelsFontSize:(CGFloat)fontSize
{
    self.sunLabel.font = [UIFont systemFontOfSize:fontSize];
    self.monLabel.font = [UIFont systemFontOfSize:fontSize];
    self.wedLabel.font = [UIFont systemFontOfSize:fontSize];
    self.thuLabel.font = [UIFont systemFontOfSize:fontSize];
    self.friLabel.font = [UIFont systemFontOfSize:fontSize];
    self.satLabel.font = [UIFont systemFontOfSize:fontSize];
    self.tueLabel.font = [UIFont systemFontOfSize:fontSize];
}

@end
