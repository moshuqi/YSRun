//
//  YSNetworkManager.m
//  YSRun
//
//  Created by moshuqi on 15/10/22.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSNetworkManager.h"
#import "YSNetworkRequest.h"
#import "YSUploadRunDataRequestModel.h"
#import "YSRunDatabaseModel.h"
#import "YSModifyPasswordRequestModel.h"
#import "YSSetUserRequestModel.h"
#import "YSThirdPartLoginResponseModel.h"

#import "YSLoadingHUD.h"
#import "YSTipLabelHUD.h"

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

- (void)getRunDataWithUid:(NSString *)uid lastTime:(NSInteger)lastTime
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        [self.networkRequest getRunDataWithUid:uid lastTime:lastTime delegate:self];
    });
}

- (void)uploadRunData:(YSRunDatabaseModel *)runDatabaseModel
{
    YSUploadRunDataRequestModel *requestModel = [self uploadRunDataRequestFromRunDatabaseModel:runDatabaseModel];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        [self.networkRequest uploadRunData:requestModel delegate:self];
    });
}

- (void)userRegister:(YSRegisterInfoRequestModel *)registerInfo
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        [self.networkRequest userRegisterWithRequestModel:registerInfo delegate:self];
    });
}

- (void)uploadHeadImage:(UIImage *)image uid:(NSString *)uid
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        [self.networkRequest uploadHeadImage:image uid:uid delegate:self];
    });
}

- (void)resetPasswordCaptchaWithPhoneNumber:(NSString *)phoneNumber
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        [self.networkRequest resetPasswordCaptchaWithPhoneNumber:phoneNumber delegate:self];
    });
}

- (void)resetPassword:(NSString *)password phoneNumber:(NSString *)phoneNumber
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        [self.networkRequest resetPasswordWithAccount:phoneNumber password:password delegate:self];
    });
}

- (void)modifyPasswordWithPhoneNumber:(NSString *)phoneNumber oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        YSModifyPasswordRequestModel *modiyPasswordModel = [YSModifyPasswordRequestModel new];
        modiyPasswordModel.phone = phoneNumber;
        modiyPasswordModel.oldPassword = oldPassword;
        modiyPasswordModel.modifiedPassword = newPassword;
        
        [self.networkRequest modiyPasswordWithRequestModel:modiyPasswordModel delegate:self];
    });
}

- (void)getUserInfoWithUid:(NSString *)uid
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        [self.networkRequest getUserInfoWithUserID:uid delegate:self];
    });
}

- (void)setUserWithRequestModel:(YSSetUserRequestModel *)setUserRequestModel
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        [self.networkRequest setUserWithRequestModel:setUserRequestModel delegate:self];
    });
}

- (void)thirdPartLoginWithThirdPartLoginResponseModel:(YSThirdPartLoginResponseModel *)model
{
    // 第三方登录，将对应字段向服务器进行请求
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        [self.networkRequest thirdPartLoginWithModel:model delegate:self];
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
    if ([self.delegate respondsToSelector:@selector(acquireCaptchaSuccess)])
    {
        [self.delegate acquireCaptchaSuccess];
    }
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
- (void)captchaCorrectWithPhoneNumber:(NSString *)phoneNumber
{
    if ([self.delegate respondsToSelector:@selector(checkCaptchaSuccessWithPhoneNumber:)])
    {
        [self.delegate checkCaptchaSuccessWithPhoneNumber:phoneNumber];
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
- (void)userRegisterSuccessWithUid:(NSString *)uid
{
    // 用户注册成功之后返回uid，此时拿uid再向服务器请求用户数据.
    if ([self.delegate respondsToSelector:@selector(registerSuccessWithUid:)])
    {
        [self.delegate registerSuccessWithUid:uid];
    }
}

- (void)userRegisterFailureWithMessage:(NSString *)message
{
    if ([self.delegate respondsToSelector:@selector(registerFailureWithMessage:)])
    {
        [self.delegate registerFailureWithMessage:message];
    }
}

- (void)userRegisterPhoneNumberCaptchaCorrect
{
    
}

// 用户登录
- (void)userLoginSuccessWithUserInfoResponseModel:(YSUserInfoResponseModel *)userModel
{
    if ([self.delegate respondsToSelector:@selector(loginSuccessWithUserInfoResponseModel:)])
    {
        [self.delegate loginSuccessWithUserInfoResponseModel:userModel];
    }
}

- (void)userLoginFailure
{
    if ([self.delegate respondsToSelector:@selector(loginFailure)])
    {
        [self.delegate loginFailure];
    }
}

// 重置密码前的验证码
- (void)acquireResetPasswordCaptchaSuccess
{
    if ([self.delegate respondsToSelector:@selector(acquireResetPasswordCaptchaSuccess)])
    {
        [self.delegate acquireResetPasswordCaptchaSuccess];
    }
}

- (void)acquireResetPasswordCaptchaFailureWithMessage:(NSString *)message
{
    if ([self.delegate respondsToSelector:@selector(acquireResetPasswordCaptchaFailureWithMessage:)])
    {
        [self.delegate acquireResetPasswordCaptchaFailureWithMessage:message];
    }
}

// 密码重置
- (void)userResetPasswordSuccess
{
    if ([self.delegate respondsToSelector:@selector(resetPasswordSuccess)])
    {
        [self.delegate resetPasswordSuccess];
    }
}

- (void)userResetPasswordFailureWithMessage:(NSString *)message
{
    if ([self.delegate respondsToSelector:@selector(resetPasswordFailureWithMessage:)])
    {
        [self.delegate resetPasswordFailureWithMessage:message];
    }
}

// 修改密码
- (void)userModifyPasswordSuccess
{
    if ([self.delegate respondsToSelector:@selector(modifyPasswordSuccess)])
    {
        [self.delegate modifyPasswordSuccess];
    }
}

- (void)userModifyPasswordFailureWithMessage:(NSString *)message
{
    if ([self.delegate respondsToSelector:@selector(modifyPasswordFailureWithMessage:)])
    {
        [self.delegate modifyPasswordFailureWithMessage:message];
    }
}

// 设置用户基本信息
- (void)userSetInfoSuccess
{
    if ([self.delegate respondsToSelector:@selector(setInfoSuccess)])
    {
        [self.delegate setInfoSuccess];
    }
}

- (void)userSetInfoFailureWithMessage:(NSString *)message
{
    if ([self.delegate respondsToSelector:@selector(setInfoFailureWithMessage:)])
    {
        [self.delegate setInfoFailureWithMessage:message];
    }
}

// 获取用户基本信息
- (void)requestUserInfoSuccessWithModel:(YSUserDatabaseModel *)model
{
    if ([self.delegate respondsToSelector:@selector(getUserInfoSuccessWithModel:)])
    {
        [self.delegate getUserInfoSuccessWithModel:model];
    }
}

- (void)requestUserInfoFailureWithMessage:(NSString *)message
{
    if ([self.delegate respondsToSelector:@selector(getUserInfoFailureWithMessage:)])
    {
        [self.delegate getUserInfoFailureWithMessage:message];
    }
}

// 上传跑步数据

- (void)uploadUserRunDataSuccessWithlocalRowid:(NSInteger)rowid lasttime:(NSString *)lasttime
{
    if ([self.delegate respondsToSelector:@selector(uploadRunDataSuccessWithRowid:lasttime:)])
    {
        [self.delegate uploadRunDataSuccessWithRowid:rowid lasttime:lasttime];
    }
}

- (void)uploadUserRunDataFailureWithMessage:(NSString *)message
{
    if ([self.delegate respondsToSelector:@selector(uploadRunDataFailureWithMessage:)])
    {
        [self.delegate uploadRunDataFailureWithMessage:message];
    }
}

// 获取服务端跑步数据
- (void)synchronizeLocalRunData:(NSArray *)runDataArray lastTime:(NSInteger)lastTime
{
    if ([self.delegate respondsToSelector:@selector(databaseSynchronizeRunDatas:lastTime:)])
    {
        [self.delegate databaseSynchronizeRunDatas:runDataArray lastTime:lastTime];
    }
}

- (void)notRequiredSynchronized
{
    
}

- (void)getRunDataEmpty
{
    if ([self.delegate respondsToSelector:@selector(runDataEmptyInServer)])
    {
        [self.delegate runDataEmptyInServer];
    }
}

// 上传头像
- (void)userUploadHeadImageSuccessWithPath:(NSString *)imagePath
{
    if ([self.delegate respondsToSelector:@selector(uploadHeadImageSuccessWithPath:)])
    {
        [self.delegate uploadHeadImageSuccessWithPath:imagePath];
    }
}

- (void)userUploadHeadImageFailureWithMessage:(NSString *)message
{
    if ([self.delegate respondsToSelector:@selector(uploadHeadImageFailureWithMessage:)])
    {
        [self.delegate uploadHeadImageFailureWithMessage:message];
    }
}

// 网络请求失败
- (void)networkRequestFailureWithError:(NSError *)error
{
    // 网络请求失败，一般出现在断网的情况下
    [[YSLoadingHUD shareLoadingHUD] dismiss];
    [[YSTipLabelHUD shareTipLabelHUD] showTipWithText:@"网络请求超时，请检查网络连接状况"];
}

#pragma mark - private

- (YSUploadRunDataRequestModel *)uploadRunDataRequestFromRunDatabaseModel:(YSRunDatabaseModel *)runDatabaseModel
{
    YSUploadRunDataRequestModel *requestModel = [YSUploadRunDataRequestModel new];
    
    requestModel.rowid = runDatabaseModel.rowid;
    requestModel.uid = runDatabaseModel.uid;
    requestModel.pace = runDatabaseModel.pace;
    requestModel.distance = runDatabaseModel.distance;
    requestModel.usetime = runDatabaseModel.usetime;
    requestModel.cost = runDatabaseModel.cost;
    requestModel.star = runDatabaseModel.star;
    requestModel.h_speed = runDatabaseModel.hSpeed;
    requestModel.l_speed = runDatabaseModel.lSpeed;
    requestModel.date = runDatabaseModel.date;
    requestModel.edate = runDatabaseModel.edate;
    requestModel.bdate = runDatabaseModel.bdate;
    requestModel.speed = runDatabaseModel.speed;
    
    requestModel.locationDataString = runDatabaseModel.locationDataString;
    requestModel.heartRateDataString = runDatabaseModel.heartRateDataString;
    
    return requestModel;
}

@end
