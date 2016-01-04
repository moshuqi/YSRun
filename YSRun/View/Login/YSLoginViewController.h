//
//  YSLoginViewController.h
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSLoginViewController;
@class YSUserInfoResponseModel;
@class YSUserDatabaseModel;

@protocol YSLoginViewControllerDelegate <NSObject>

@required
- (void)loginViewController:(YSLoginViewController *)loginViewController loginFinishWithUserInfoResponseModel:(YSUserInfoResponseModel *)userInfoResponseModel;
- (void)loginViewController:(YSLoginViewController *)loginViewController registerFinishWithResponseUserInfo:(YSUserDatabaseModel *)userInfo;

@end

@interface YSLoginViewController : UIViewController

@property (nonatomic, weak) id<YSLoginViewControllerDelegate> delegate;

@end
