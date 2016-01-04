//
//  YSUserSettingView.h
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSUserSetCell.h"

@protocol YSUserSettingViewDelegate <NSObject>

@required
- (void)modifyNickame:(NSString *)nickname;
- (void)userSettingViewDidSelectedType:(YSSettingsType)type;

@end

@interface YSUserSettingView : UIView

@property (nonatomic, weak) id<YSUserSettingViewDelegate> delegate;

- (void)reloadTableView;

@end
