//
//  YSCalendarRecordView.m
//  YSRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSCalendarRecordView.h"
#import "YSCalendarTitleBarView.h"
#import "NSDate+YSDateLogic.h"
#import "YSAppMacro.h"
#import "YSCalendar.h"
#import "YSDevice.h"

#define CalendarReuseIdentifier @"CalendarReuseIdentifier"

@interface YSCalendarRecordView () <YSCalendarTitleBarViewDelegate, YSCalendarDelegate>

@property (nonatomic, weak) IBOutlet YSCalendarTitleBarView *titleBarView;
@property (nonatomic, weak) IBOutlet YSCalendar *calendar;

@property (nonatomic, strong) NSDate *currentDate;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *titleBarHeightContraint;

@end

const CGFloat kMinimumInteritemSpacing = 0;
const CGFloat kMinimumLineSpacing = 1;

@implementation YSCalendarRecordView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleBarView.delegate = self;
    
    self.calendar.delegate = self;
    [self.titleBarView setupWithDate:[NSDate date]];
    
    if ([YSDevice isPhone6Plus])
    {
        // 6p尺寸适配
        self.titleBarHeightContraint.constant = 68;
        [self.titleBarView setTitleFontSize:24 weekdayFontSize:15];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSCalendarRecordView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        containerView.backgroundColor = GreenBackgroundColor;
        
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)resetCalendarFrame
{
    [self.calendar resetSubviewFrame];
//    [self bringSubviewToFront:self.calendar];
}

- (void)toLastMonth
{
    // 日历跳到上一个月
    
    [self.calendar slideToLastMonth];
}

- (void)toNextMonth
{
    // 日历跳到下一个月
    
    [self.calendar slideToNextMonth];
}

- (void)resetCalendarWithDate:(NSDate *)date
{
    self.currentDate = date;
    
    [self.calendar resetCalanderWithDate:date];
    [self.titleBarView setupWithDate:date];
}

#pragma mark - YSCalendarTitleBarViewDelegate

- (void)titleBarLeftButtonClicked
{
    [self toLastMonth];
}

- (void)titleBarRightButtonClicked
{
    [self toNextMonth];
}

#pragma mark - YSCalendarDelegate

- (void)calendarSlideFinishWithDisplayDate:(NSDate *)displayDate
{
    [self.titleBarView setupWithDate:displayDate];
}

- (void)calendarDidSelectedDate:(NSDate *)date
{
    [self.delegate calendarRecordDidSelectedDate:date];
}

@end
