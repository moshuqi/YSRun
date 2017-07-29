//
//  YSResultRecordView.h
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSRunInfoModel;

@protocol YSResultRecordViewDelegate <NSObject>

@required
- (void)showRunDataDetail;
- (void)showHeartRateDataDetail;
- (void)resultRecordViewBack;

@end

@interface YSResultRecordView : UIView

@property (nonatomic, weak) id<YSResultRecordViewDelegate> delegate;

- (void)setupRecordWith:(YSRunInfoModel *)runInfoModel;

@end
