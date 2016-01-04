//
//  YSRunDataRecordCell.h
//  YSRun
//
//  Created by moshuqi on 15/11/24.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSRunDataRecordCellDelegate <NSObject>

@optional
- (void)showContentHelpFromPoint:(CGPoint)point;

@end

@class YSDataRecordModel;

@interface YSRunDataRecordCell : UITableViewCell

@property (nonatomic, weak) id<YSRunDataRecordCellDelegate> delegate;

- (void)setHelpTitleHidden:(BOOL)isHidden;
- (void)resetCellWithModel:(YSDataRecordModel *)model;

@end
