//
//  YSLoginViewController.h
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSLoginViewController;
@class YSUserModel;

@protocol YSLoginViewControllerDelegate <NSObject>

- (void)loginViewController:(YSLoginViewController *)loginViewController loginFinishWithUserModel:(YSUserModel *)userModel;

@end

@interface YSLoginViewController : UIViewController

@property (nonatomic, weak) id<YSLoginViewControllerDelegate> delegate;

@end
