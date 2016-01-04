//
//  YSUserNoLoginView.h
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSUserSetCell.h"

@protocol YSUserNoLoginViewDelegate <NSObject>

@required
- (void)login;
- (void)userNoLoginViewDidSelectedType:(YSSettingsType)type;

@end

@interface YSUserNoLoginView : UIView

@property (nonatomic, assign) id<YSUserNoLoginViewDelegate> delegate;

@end
