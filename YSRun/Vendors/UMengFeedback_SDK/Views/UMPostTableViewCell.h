//
//  UMPostTableViewCell.h
//  Feedback
//
//  Created by amoblin on 14/9/10.
//  Copyright (c) 2014年 umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMPostTableViewCell : UITableViewCell

@property (strong, nonatomic) UIButton *playRecordButton;
@property (strong, nonatomic) UIButton *thumbImageButton;

- (void)configCell:(NSDictionary *)info;
- (void)setDuration:(NSNumber *)duration;
@end
