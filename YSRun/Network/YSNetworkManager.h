//
//  YSNetworkManager.h
//  YSRun
//
//  Created by moshuqi on 15/10/22.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YSUserModel;

@protocol YSNetworkManagerDelegate <NSObject>

@optional

- (void)showAcquireCaptchaResultTip:(NSString *)tip;

- (void)checkCaptchaSuccess;
- (void)checkCaptchaFailureWithMessage:(NSString *)message;

- (void)loginSuccessWithResponseUserModel:(YSUserModel *)userModel;
- (void)loginFailure;

@end

@interface YSNetworkManager : NSObject

@property (nonatomic, weak) id<YSNetworkManagerDelegate> delegate;

- (void)acquireCaptchaWithPhoneNumber:(NSString *)phoneNumber;
- (void)checkCaptcha:(NSString *)captcha phoneNumber:(NSString *)phoneNumber;
- (void)loginWithAccount:(NSString *)account password:(NSString *)password;

@end
