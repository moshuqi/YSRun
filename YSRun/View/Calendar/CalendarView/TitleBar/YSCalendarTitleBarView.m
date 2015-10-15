//
//  YSCalendarTitleBarView.m
//  YSRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSCalendarTitleBarView.h"
#import "YSCalendarTitleDateView.h"
#import "NSDate+YSDateLogic.h"

@interface YSCalendarTitleBarView () <YSCalendarTitleDateViewDelegate>

@property (nonatomic, weak) IBOutlet YSCalendarTitleDateView *titleDateView;

@end

@implementation YSCalendarTitleBarView

- (void)awakeFromNib
{
    self.titleDateView.delegate = self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSCalendarTitleBarView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)setupWithDate:(NSDate *)date
{
    NSInteger year = [date yearValue];
    NSInteger month = [date monthValue];
    
    [self.titleDateView setLabelWithYear:year month:month];
}

#pragma mark - YSCalendarTitleDateViewDelegate

- (void)calendarTitleLeftButtonClicked
{
    [self.delegate titleBarLeftButtonClicked];
}

- (void)calendarTitleRightButtonClicked
{
    [self.delegate titleBarRightButtonClicked];
}

@end
