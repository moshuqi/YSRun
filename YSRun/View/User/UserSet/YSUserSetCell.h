//
//  YSUserSetCell.h
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YSUserSetCellType)
{
    YSUserSetCellTypeNickname = 0,
    YSUserSetCellTypeModifyPassword,
    YSUserSetCellTypeMeasure,
    YSUserSetCellTypeLogout
};

@interface YSUserSetCell : UITableViewCell

@property (nonatomic, assign) YSUserSetCellType type;

- (void)setupWithType:(YSUserSetCellType)type;

@end
