//
//  UMChatTableViewCell.h
//  Feedback
//
//  Created by amoblin on 14/7/31.
//  Copyright (c) 2014年 umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMChatTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *messageBackgroundView;

- (void)configCell:(NSDictionary *)info;

@property (nonatomic) BOOL isRightAlign;
@end
