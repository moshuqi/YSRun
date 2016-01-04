//
//  YSCalendarRecordView.h
//  YSRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSCalendarRecordViewDelegate <NSObject>

@required
- (void)calendarRecordDidSelectedDate:(NSDate *)date;

@end

@interface YSCalendarRecordView : UIView

@property (nonatomic, weak) id<YSCalendarRecordViewDelegate> delegate;

- (void)resetCalendarWithDate:(NSDate *)date;
- (void)resetCalendarFrame;

@end
