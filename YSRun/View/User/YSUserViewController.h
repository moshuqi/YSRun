//
//  YSUserViewController.h
//  YSRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSUserViewControllerDelegate <NSObject>

@required
- (void)userViewUserStateChanged;   // 用户登录或者注销

@end

@interface YSUserViewController : UIViewController

@property (nonatomic, weak) id<YSUserViewControllerDelegate> delegate;

@end
