//
//  YSCalendar.h
//  YSRun
//
//  Created by moshuqi on 15/11/2.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSCalendarDelegate <NSObject>

@required
- (void)calendarDidSelectedDate:(NSDate *)date;

@optional
- (void)calendarSlideFinishWithDisplayDate:(NSDate *)displayDate;


@end

@interface YSCalendar : UIView

@property (nonatomic, weak) id<YSCalendarDelegate> delegate;

- (void)resetCalanderWithDate:(NSDate *)date;
- (void)resetSubviewFrame;

- (void)slideToLastMonth;
- (void)slideToNextMonth;


@end
