//
//  YSNetworkManager.m
//  YSRun
//
//  Created by moshuqi on 15/10/22.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSNetworkManager.h"
#import "YSNetworkRequest.h"

@interface YSNetworkManager () <YSNetworkRequestDelegate>

@property (nonatomic, strong) YSNetworkRequest *networkRequest;

@end

@implementation YSNetworkManager

- (id)init
{
    self = [super init];
    if (self)
    {
        self.networkRequest = [YSNetworkRequest shareNetworkRequest];
        self.networkRequest.delegate = self;
    }
    
    return self;
}

#pragma mark - public method

- (void)acquireCaptchaWithPhoneNumber:(NSString *)phoneNumber
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        [self.networkRequest acquireCaptchaWithPhoneNumber:phoneNumber delegate:self];
    });
}

- (void)checkCaptcha:(NSString *)captcha phoneNumber:(NSString *)phoneNumber
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        [self.networkRequest checkCaptcha:captcha phoneNumber:phoneNumber delegate:self];
    });
}

- (void)loginWithAccount:(NSString *)account password:(NSString *)password
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        [self.networkRequest userLoginWithAccount:account password:password delegate:self];
    });
}

#pragma mark - private method

- (void)acquireCaptchaResult:(NSString *)result
{
    if ([self.delegate respondsToSelector:@selector(showAcquireCaptchaResultTip:)])
    {
        [self.delegate showAcquireCaptchaResultTip:result];
    }
}

- (void)checkCaptchaFailureResult:(NSString *)message
{
    if ([self.delegate respondsToSelector:@selector(checkCaptchaFailureWithMessage:)])
    {
        [self.delegate checkCaptchaFailureWithMessage:message];
    }
}

#pragma mark - YSNetworkRequestDelegate

// 获取验证码
- (void)acquireCaptchaSuccess
{
    NSString *tipText = @"验证码已发送至手机短信";
    [self acquireCaptchaResult:tipText];
}

- (void)acquireCaptchaFailure
{
    NSString *tipText = @"验证码请求失败";
    [self acquireCaptchaResult:tipText];
}

- (void)registerPhoneNumberHasExsist
{
    NSString *tipText = @"手机号已存在";
    [self acquireCaptchaResult:tipText];
}

// 判断验证码
- (void)captchaCorrect
{
    if ([self.delegate respondsToSelector:@selector(checkCaptchaSuccess)])
    {
        [self.delegate checkCaptchaSuccess];
    }
}

- (void)captchaWrong
{
    NSString *message = @"验证失败";
    [self checkCaptchaFailureResult:message];
}

- (void)captchaOvertime
{
    NSString *message = @"验证码超时";
    [self checkCaptchaFailureResult:message];
}

- (void)captchaInvalid
{
    NSString *message = @"验证码无效";
    [self checkCaptchaFailureResult:message];
}

// 用户注册
- (void)userRegisterSuccess
{
    
}

- (void)userRegisterFailure
{
    
}

- (void)userRegisterPhoneNumberCaptchaCorrect
{
    
}

// 用户登录
- (void)userLoginSuccessWithResponseUserModel:(YSUserModel *)userModel
{
    if ([self.delegate respondsToSelector:@selector(loginSuccessWithResponseUserModel:)])
    {
        [self.delegate loginSuccessWithResponseUserModel:userModel];
    }
}

- (void)userLoginFailure
{
    if ([self.delegate respondsToSelector:@selector(loginFailure)])
    {
        [self.delegate loginFailure];
    }
}

// 网络请求失败
- (void)networkRequestFailureWithError:(NSError *)error
{
    
}

@end
