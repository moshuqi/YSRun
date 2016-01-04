//
//  YSContentTable.h
//  YSRun
//
//  Created by moshuqi on 15/11/24.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSDataRecordModel;

@protocol YSContentTableDelegate <NSObject>

@optional
- (void)showHeartRateRecordWithDataModel:(YSDataRecordModel *)dataModel;

@end

@interface YSContentTable : UIView

@property (nonatomic, weak) id<YSContentTableDelegate> delegate;

- (void)resetTableWithRecordDataArray:(NSArray *)recordDataArray;

@end
