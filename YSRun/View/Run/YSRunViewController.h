//
//  YSRunViewController.h
//  YSRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSRunViewControllerDelegate <NSObject>

@required
- (void)runViewUserStateChanged;    // 用户登录或退出
- (void)runningFinish;              // 跑步完成

@end

@interface YSRunViewController : UIViewController

@property (nonatomic, weak) id<YSRunViewControllerDelegate> delegate;

@end
