//
//  YSHeartRateDataView.h
//  YSRun
//
//  Created by moshuqi on 16/1/25.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSDataRecordModel;

@interface YSHeartRateDataView : UIView

- (void)setupWithDataRecordModel:(YSDataRecordModel *)dataRecordModel;
- (void)showPercentValue;

@end
