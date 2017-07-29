//
//  YSDataRecordModel.m
//  YSRun
//
//  Created by moshuqi on 15/11/25.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSDataRecordModel.h"

@implementation YSDataRecordModel

- (CGFloat)getPace
{
    // 配速
    NSInteger useTime = self.endTime - self.startTime;
    
    // 小于两分钟则不计算配速
    if (useTime < 120)
    {
        return 0;
    }
    
    CGFloat pace = (useTime / 60.0) / (self.distance / 1000);
    
    return pace;
}

- (CGFloat)getSpeed
{
    // 时速
    NSInteger useTime = self.endTime - self.startTime;
    CGFloat hour = useTime / 3600.0;
    
    CGFloat speed = self.distance / 1000 / hour;
    return speed;
}

@end
