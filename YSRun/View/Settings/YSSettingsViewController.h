//
//  YSSettingsViewController.h
//  YSRun
//
//  Created by moshuqi on 15/12/7.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSSettingsViewControllerDelegate <NSObject>

@required
- (void)settingsViewDidSelectedLogout;

@end

@interface YSSettingsViewController : UIViewController

@property (nonatomic, weak) id<YSSettingsViewControllerDelegate> delegate;

@end
