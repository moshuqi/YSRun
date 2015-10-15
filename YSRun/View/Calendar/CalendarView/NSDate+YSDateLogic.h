//
//  NSDate+YSDateLogic.h
//  YSRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YSDateLogic)

- (NSInteger)yearValue;
- (NSInteger)monthValue;
- (NSInteger)dayValue;
- (NSInteger)weekdayValue;

- (NSDate *)beforeDays:(NSInteger)days;
- (NSDate *)afterDays:(NSInteger)days;

- (NSDate *)firstDayOfCurrentMonth;
- (NSDate *)lastDayOfCurrentMonth;
- (NSUInteger)numberOfDaysInCurrentMonth;

@end
