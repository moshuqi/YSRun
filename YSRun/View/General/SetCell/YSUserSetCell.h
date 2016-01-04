//
//  YSUserSetCell.h
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSSettingsTypeDefine.h"

//typedef NS_ENUM(NSInteger, YSUserSetCellType)
//{
//    YSUserSetCellTypeNickname = 0,
//    YSUserSetCellTypeModifyPassword,
//    YSUserSetCellTypeMeasure,
//    YSUserSetCellTypeLogout,
//    YSUserSetCellTypeFeedback,
//    YSUserSetCellTypeHeartRateSwitch
//};

@protocol YSUserSetCellDelegate <NSObject>

@optional
- (void)textFieldTextChange:(NSString *)text;
- (void)switchStateChanged:(UISwitch *)switchControl;

@end

@interface YSUserSetCell : UITableViewCell

//@property (nonatomic, assign) YSSettingsType type;
@property (nonatomic, weak) id<YSUserSetCellDelegate> delegate;

//- (void)setupWithType:(YSSettingsType)type;

- (void)setupCellWithLeftText:(NSString *)leftText
                   centerText:(NSString *)centerText
                    rightText:(NSString *)rightText
                textFieldText:(NSString *)fieldText
                switchVisible:(BOOL)switchVisible;
- (void)setSwitchOn:(BOOL)isOn;

@end
