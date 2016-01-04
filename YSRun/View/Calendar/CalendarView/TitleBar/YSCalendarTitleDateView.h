//
//  YSCalendarTitleDateView.h
//  YSRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSCalendarTitleDateViewDelegate <NSObject>

@required
- (void)calendarTitleLeftButtonClicked;
- (void)calendarTitleRightButtonClicked;

@end

@interface YSCalendarTitleDateView : UIView

@property (nonatomic, weak) id<YSCalendarTitleDateViewDelegate> delegate;

- (void)setLabelWithYear:(NSInteger)year month:(NSInteger)month;
- (void)setTitleLabelFontSize:(CGFloat)fontSize;

@end
