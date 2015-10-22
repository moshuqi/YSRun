//
//  YSNetworkRequest.h
//  YSRun
//
//  Created by moshuqi on 15/10/21.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YSUserModel;
@class YSUserRegisterInfoModel;
@class YSModifyPasswordInfoModel;
@class YSUserSetupInfoModel;
@class YSRunDataModel;
@class UIImage;

@protocol YSNetworkRequestDelegate <NSObject>

// 获取验证码
- (void)acquireCaptchaSuccess;
- (void)acquireCaptchaFailure;
- (void)registerPhoneNumberHasExsist;   // 号码已经存在

// 判断验证码
- (void)captchaCorrect;
- (void)captchaWrong;
- (void)captchaOvertime;    // 验证码30分钟超时

// 用户注册
- (void)userRegisterSuccess;
- (void)userRegisterFailure;
- (void)userRegisterPhoneNumberCaptchaCorrect;  // 手机号码未通过验证码验证

// 用户登录
- (void)userLoginSuccessWithResponseUserModel:(YSUserModel *)userModel;
- (void)userLoginFailure;

// 密码重置
// 修改密码
// 上传用户基本信息
// 获取用户基本信息
// 上传单次跑步详细信息
// 同步运动数据
// 上传头像


// 网络请求失败
- (void)networkRequestFailureWithError:(NSError *)error;

@end

@interface YSNetworkRequest : NSObject

+ (instancetype)shareNetworkRequest;

- (void)acquireCaptchaWithPhoneNumber:(NSString *)phoneNumber delegate:(id<YSNetworkRequestDelegate>)delegate;
- (void)checkCaptcha:(NSString *)captcha phoneNumber:(NSString *)phoneNumber delegate:(id<YSNetworkRequestDelegate>)delegate;
- (void)userLoginWithAccount:(NSString *)account password:(NSString *)password delegate:(id<YSNetworkRequestDelegate>)delegate;
- (void)userRegisterWithInfo:(YSUserRegisterInfoModel *)infoModel delegate:(id<YSNetworkRequestDelegate>)delegate;
- (void)resetPasswordWithAccount:(NSString *)account password:(NSString *)password delegate:(id<YSNetworkRequestDelegate>)delegate;
- (void)modiyPasswordWithInfo:(YSModifyPasswordInfoModel *)infoModel  delegate:(id<YSNetworkRequestDelegate>)delegate;
- (void)setUserWithInfo:(YSUserSetupInfoModel *)infoModel delegate:(id<YSNetworkRequestDelegate>)delegate;
- (void)getUserInfoWithUserID:(NSInteger)uid delegate:(id<YSNetworkRequestDelegate>)delegate;
- (void)uploadRunData:(YSRunDataModel *)runData delegate:(id<YSNetworkRequestDelegate>)delegate;
- (void)uploadHeadImage:(UIImage *)headImage account:(NSString *)account delegate:(id<YSNetworkRequestDelegate>)delegate;

@end
