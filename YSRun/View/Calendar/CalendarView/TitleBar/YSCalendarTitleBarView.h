//
//  YSCalendarTitleBarView.h
//  YSRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSCalendarTitleBarViewDelegate <NSObject>

@required
- (void)titleBarLeftButtonClicked;
- (void)titleBarRightButtonClicked;

@end

@interface YSCalendarTitleBarView : UIView

@property (nonatomic, weak) id<YSCalendarTitleBarViewDelegate> delegate;

- (void)setupWithDate:(NSDate *)date;

@end
