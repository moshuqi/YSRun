//
//  YSCalendarDayItem.h
//  YSRun
//
//  Created by moshuqi on 15/11/2.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSCalendarDayItemDelegate <NSObject>

- (void)touchDayItemWithDay:(NSInteger)day;

@end

@class YSDayItemModel;

@interface YSCalendarDayItem : UIView

@property (nonatomic, weak) id<YSCalendarDayItemDelegate> delegate;

- (void)setupWithDayItemModel:(YSDayItemModel *)dayItemModel;

@end
