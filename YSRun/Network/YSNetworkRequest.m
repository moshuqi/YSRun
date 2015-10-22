//
//  YSNetworkRequest.m
//  YSRun
//
//  Created by moshuqi on 15/10/21.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSNetworkRequest.h"
#import "AFNetworking.h"
#import "YSUtilsMacro.h"
#import "LFCGzipUtillity.h"
#import "YSUserModel.h"
#import "YSUserRegisterInfoModel.h"
#import "YSModifyPasswordInfoModel.h"
#import "YSUserSetupInfoModel.h"
#import "YSRunDataModel.h"

@interface YSNetworkRequest ()

@end

@implementation YSNetworkRequest

static YSNetworkRequest *_instance;
static const NSString *Host = @"http://mp.yspaobu.com/Api/webserver";

+ (id)allocWithZone:(struct _NSZone *)zone
{
    //调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)shareNetworkRequest
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YSNetworkRequest alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    
    return self;
}

- (void)test
{
    [self acquireCaptchaWithPhoneNumber:@"13192222130" delegate:nil];
}

#pragma mark - networking request

- (void)requestFailureWithError:(NSError *)error delegate:(id<YSNetworkRequestDelegate>)delegate
{
    // 网络请求失败
    [delegate networkRequestFailureWithError:error];
    
    YSLog(@"网络请求失败。");
}

- (void)acquireCaptchaWithPhoneNumber:(NSString *)phoneNumber
                             delegate:(id<YSNetworkRequestDelegate>)delegate
{
    // 获取验证码
    
    NSDictionary *dict = @{@"phone" : phoneNumber};
    NSMutableURLRequest *request = [self postRequestWithURL:[self acquireCaptchaUrl] dictionaryParameter:dict];
    
    AFHTTPRequestOperationManager *s_manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation = [s_manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
                                         {
                                             [self acquireCaptchaRequestSucessWithOperation:operation
                                                                             responseObject:responseObject
                                                                                   delegate:delegate];
                                         }
                                                                           failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                         {
                                             [self requestFailureWithError:error delegate:delegate];
                                         }];
    [s_manager.operationQueue addOperation:operation];
}

- (void)acquireCaptchaRequestSucessWithOperation:(AFHTTPRequestOperation *)operation
                           responseObject:(id)responseObject
                                 delegate:(id<YSNetworkRequestDelegate>)delegate
{
    // 网络请求成功
    if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
    {
        NSString *resultKey = @"r";
        NSString *messageKey = @"m";
        
        NSInteger result = [[responseObject valueForKey:resultKey] integerValue];
        NSString *message = [responseObject valueForKey:messageKey];
        
        switch (result)
        {
            case 1:
                [delegate acquireCaptchaSuccess];
                break;
                
            case -1:
                [delegate acquireCaptchaFailure];
                break;
                
            case 2:
                [delegate registerPhoneNumberHasExsist];
                break;
                
            default:
                break;
        }
        
        YSLog(@"%@",message);
    }
}

- (void)checkCaptcha:(NSString *)captcha phoneNumber:(NSString *)phoneNumber delegate:(id<YSNetworkRequestDelegate>)delegate
{
    // 检验验证码
    
    NSDictionary *dict = @{@"phone" : phoneNumber,
                           @"code" : captcha};
    NSMutableURLRequest *request = [self postRequestWithURL:[self checkCaptchaUrl] dictionaryParameter:dict];
    
    AFHTTPRequestOperationManager *s_manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation = [s_manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
                                         {
                                             [self checkCaptchaRequestSucessWithOperation:operation
                                                                           responseObject:responseObject
                                                                                 delegate:delegate];
                                         }
                                                                           failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                         {
                                             [self requestFailureWithError:error delegate:delegate];
                                         }];
    [s_manager.operationQueue addOperation:operation];
}

- (void)checkCaptchaRequestSucessWithOperation:(AFHTTPRequestOperation *)operation
                                  responseObject:(id)responseObject
                                        delegate:(id<YSNetworkRequestDelegate>)delegate
{
    if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
    {
        NSString *resultKey = @"r";
        NSString *messageKey = @"m";
        
        NSInteger result = [[responseObject valueForKey:resultKey] integerValue];
        NSString *message = [responseObject valueForKey:messageKey];
        
        switch (result)
        {
            case 0:
                [self.delegate captchaInvalid];
                break;
                
            case 1:
                [delegate captchaCorrect];
                break;
                
            case -1:
                [delegate captchaWrong];
                break;
                
            case 2:
                [delegate captchaOvertime];
                break;
                
            default:
                break;
        }
        
        YSLog(@"%@",message);
    }
}



- (void)userLoginWithAccount:(NSString *)account password:(NSString *)password delegate:(id<YSNetworkRequestDelegate>)delegate
{
    // 用户登录
    
    NSDictionary *dict = @{@"phone" : account,
                             @"pwd" : password};
    NSMutableURLRequest *request = [self postRequestWithURL:[self loginUrl] dictionaryParameter:dict];
    
    AFHTTPRequestOperationManager *s_manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation = [s_manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
                                         {
                                             [self userLoginRequestSucessWithOperation:operation
                                                                        responseObject:responseObject
                                                                              delegate:delegate];
                                         }
                                                                           failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                         {
                                             [self requestFailureWithError:error delegate:delegate];
                                         }];
    [s_manager.operationQueue addOperation:operation];
    
}

- (void)userLoginRequestSucessWithOperation:(AFHTTPRequestOperation *)operation
                                responseObject:(id)responseObject
                                      delegate:(id<YSNetworkRequestDelegate>)delegate
{
    if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
    {
        NSString *resultKey = @"r";
        NSString *messageKey = @"m";
        
        NSInteger result = [[responseObject valueForKey:resultKey] integerValue];
        NSString *message = [responseObject valueForKey:messageKey];
        
        switch (result)
        {
            case 1:
            {
                NSString *dataKey = @"data";
                NSDictionary *dict = [responseObject valueForKey:dataKey];
                YSUserModel *userModel = [self getUserModelWithDataDictionary:dict];
                
                [delegate userLoginSuccessWithResponseUserModel:userModel];
            }
                break;
                
                
            default:
                // 1为成功，其余情况均未登录失败
                [delegate userLoginFailure];
                break;
        }
        
        YSLog(@"%@",message);
    }

}

- (void)userRegisterWithInfo:(YSUserRegisterInfoModel *)infoModel delegate:(id<YSNetworkRequestDelegate>)delegate
{
    // 用户注册
    
    // mark 不压缩数据
    NSDictionary *dict = @{@"phone" : infoModel.phone,
                           @"pwd" : infoModel.pwd,
                           @"nickname" : infoModel.nickname};
    NSMutableURLRequest *request = [self postRequestWithURL:[self registerUrl] dictionaryParameter:dict];
    
    AFHTTPRequestOperationManager *s_manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation = [s_manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
                                         {
                                             [self userRegisterRequestSucessWithOperation:operation
                                                                           responseObject:responseObject
                                                                                 delegate:delegate];
                                         }
                                                                           failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                         {
                                             [self requestFailureWithError:error delegate:delegate];
                                         }];
    [s_manager.operationQueue addOperation:operation];
}

- (void)userRegisterRequestSucessWithOperation:(AFHTTPRequestOperation *)operation
                             responseObject:(id)responseObject
                                   delegate:(id<YSNetworkRequestDelegate>)delegate
{
    
}

- (void)resetPasswordWithAccount:(NSString *)account password:(NSString *)password delegate:(id<YSNetworkRequestDelegate>)delegate
{
    // 重置密码
    
    NSDictionary *dict = @{@"phone" : account,
                           @"pwd" : password};
    NSMutableURLRequest *request = [self postRequestWithURL:[self resetPasswordUrl] dictionaryParameter:dict];
    
    AFHTTPRequestOperationManager *s_manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation = [s_manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
                                         {
                                             [self resetPasswordRequestSucessWithOperation:operation
                                                                            responseObject:responseObject
                                                                                  delegate:delegate];
                                         }
                                                                           failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                         {
                                             [self requestFailureWithError:error delegate:delegate];
                                         }];
    [s_manager.operationQueue addOperation:operation];
}

- (void)resetPasswordRequestSucessWithOperation:(AFHTTPRequestOperation *)operation
                                responseObject:(id)responseObject
                                      delegate:(id<YSNetworkRequestDelegate>)delegate
{
    
}

- (void)modiyPasswordWithInfo:(YSModifyPasswordInfoModel *)infoModel  delegate:(id<YSNetworkRequestDelegate>)delegate
{
    // 修改密码
    
    NSDictionary *dict = @{@"phone" : infoModel.account,
                           @"old_pwd" : infoModel.oldPassword,
                           @"new_pwd" : infoModel.modifiedPassword};
    NSMutableURLRequest *request = [self postRequestWithURL:[self modifyPasswordUrl] dictionaryParameter:dict];
    
    AFHTTPRequestOperationManager *s_manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation = [s_manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
                                         {
                                             [self modiyPasswordRequestSucessWithOperation:operation
                                                                            responseObject:responseObject
                                                                                  delegate:delegate];
                                         }
                                                                           failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                         {
                                             [self requestFailureWithError:error delegate:delegate];
                                         }];
    [s_manager.operationQueue addOperation:operation];
}

- (void)modiyPasswordRequestSucessWithOperation:(AFHTTPRequestOperation *)operation
                                 responseObject:(id)responseObject
                                       delegate:(id<YSNetworkRequestDelegate>)delegate
{
    
}

- (void)setUserWithInfo:(YSUserSetupInfoModel *)infoModel delegate:(id<YSNetworkRequestDelegate>)delegate
{
    // 用户设置
    
    NSDictionary *dict = @{@"nickname" : infoModel.nickname,
                           @"sex" : infoModel.sex,
                           @"age" : infoModel.age,
                           @"birthday" : infoModel.birthday,
                           @"height" : infoModel.height};
    NSMutableURLRequest *request = [self postRequestWithURL:[self setUserUrl] dictionaryParameter:dict];
    
    AFHTTPRequestOperationManager *s_manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation = [s_manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
                                         {
                                             [self setUserRequestSucessWithOperation:operation
                                                                      responseObject:responseObject
                                                                            delegate:delegate];
                                         }
                                                                           failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                         {
                                             [self requestFailureWithError:error delegate:delegate];
                                         }];
    [s_manager.operationQueue addOperation:operation];
}

- (void)setUserRequestSucessWithOperation:(AFHTTPRequestOperation *)operation
                                 responseObject:(id)responseObject
                                       delegate:(id<YSNetworkRequestDelegate>)delegate
{
    
}

- (void)getUserInfoWithUserID:(NSInteger)uid delegate:(id<YSNetworkRequestDelegate>)delegate
{
    // 获取用户信息
    
    NSDictionary *dict = @{@"uid" : [NSNumber numberWithInteger:uid]};
    NSMutableURLRequest *request = [self postRequestWithURL:[self getUserInfoUrl] dictionaryParameter:dict];
    
    AFHTTPRequestOperationManager *s_manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation = [s_manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
                                         {
                                             [self getUserInfoRequestSucessWithOperation:operation
                                                                          responseObject:responseObject
                                                                                delegate:delegate];
                                         }
                                                                           failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                         {
                                             [self requestFailureWithError:error delegate:delegate];
                                         }];
    [s_manager.operationQueue addOperation:operation];
}

- (void)getUserInfoRequestSucessWithOperation:(AFHTTPRequestOperation *)operation
                           responseObject:(id)responseObject
                                 delegate:(id<YSNetworkRequestDelegate>)delegate
{
    
}


- (void)uploadRunData:(YSRunDataModel *)runData delegate:(id<YSNetworkRequestDelegate>)delegate
{
    // 上传单次跑步数据
    
    NSDictionary *dict = @{@"uid" : runData.uid,
                           @"pace" : runData.pace,
                           @"distance" : runData.distance,
                           @"usetime" : runData.usetime,
                           @"cost" : runData.cost,
                           @"star" : runData.star,
                           @"h_speed" : runData.h_speed,
                           @"l_speed" : runData.l_speed,
                           @"date" : runData.date,
                           @"bdate" : runData.bdate,
                           @"speed" : runData.speed,
                           @"detail" : runData.detail,
                           @"ctime" : runData.ctime,
                           @"utime" : runData.utime};
    NSMutableURLRequest *request = [self postRequestWithURL:[self uploadRunDataUrl] dictionaryParameter:dict];
    
    AFHTTPRequestOperationManager *s_manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation = [s_manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
                                         {
                                             [self uploadRunDataRequestSucessWithOperation:operation
                                                                            responseObject:responseObject
                                                                                  delegate:delegate];
                                         }
                                                                           failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                         {
                                             [self requestFailureWithError:error delegate:delegate];
                                         }];
    [s_manager.operationQueue addOperation:operation];
}

- (void)uploadRunDataRequestSucessWithOperation:(AFHTTPRequestOperation *)operation
                               responseObject:(id)responseObject
                                     delegate:(id<YSNetworkRequestDelegate>)delegate
{
    
}

- (void)uploadHeadImage:(UIImage *)headImage account:(NSString *)account delegate:(id<YSNetworkRequestDelegate>)delegate
{
    // 上传头像
}

- (void)uploadHeadImageRequestSucessWithOperation:(AFHTTPRequestOperation *)operation
                                 responseObject:(id)responseObject
                                       delegate:(id<YSNetworkRequestDelegate>)delegate
{
    
}


#pragma mark - private method

- (NSMutableURLRequest *)postRequestWithURL:(NSURL *)url dictionaryParameter:(NSDictionary *)dictionary
{
    // 网络请求都用post,dictionary转化成json，并压缩作为request的参数
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    NSData *zipData = [LFCGzipUtillity gzipData:data];
    [request setHTTPBody:zipData];
    [request setHTTPMethod:@"POST"];
    
    return request;
}

- (NSURL *)getUrlWithRequestName:(NSString *)name
{
    // 请求接口的url
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", Host, name];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    return url;
}

- (NSURL *)loginUrl
{
    NSString *name = @"/login";
    return [self getUrlWithRequestName:name];
}

- (NSURL *)acquireCaptchaUrl
{
    NSString *name = @"/preregister";
    return [self getUrlWithRequestName:name];
}

- (NSURL *)checkCaptchaUrl
{
    NSString *name = @"/validCode";
    return [self getUrlWithRequestName:name];
}

- (NSURL *)registerUrl
{
    NSString *name = @"/registerInfo";
    return [self getUrlWithRequestName:name];
}

- (NSURL *)resetPasswordUrl
{
    NSString *name = @"/resetpwd";
    return [self getUrlWithRequestName:name];
}

- (NSURL *)modifyPasswordUrl
{
    NSString *name = @"/modifypwd";
    return [self getUrlWithRequestName:name];
}

- (NSURL *)setUserUrl
{
    NSString *name = @"/setUser";
    return [self getUrlWithRequestName:name];
}

- (NSURL *)getUserInfoUrl
{
    NSString *name = @"/getUserInfo";
    return [self getUrlWithRequestName:name];
}

- (NSURL *)uploadRunDataUrl
{
    NSString *name = @"/uploadRunData";
    return [self getUrlWithRequestName:name];
}

- (NSURL *)synchronousRunDataUrl
{
    // 同步数据
    NSString *name = @"/getRunData";
    return [self getUrlWithRequestName:name];
}

- (NSURL *)uploadHeadImgUrl
{
    NSString *name = @"/uploadHeadImg";
    return [self getUrlWithRequestName:name];
}

- (YSUserModel *)getUserModelWithDataDictionary:(NSDictionary *)dataDict
{
    YSUserModel *userModel = [YSUserModel new];
    
    userModel.ID = [dataDict valueForKey:@"id"];
    userModel.utime = [dataDict valueForKey:@"utime"];
    userModel.phone = [dataDict valueForKey:@"phone"];
    userModel.uid = [dataDict valueForKey:@"uid"];
    userModel.sex = [dataDict valueForKey:@"sex"];
    userModel.age = [dataDict valueForKey:@"age"];
    userModel.headimg = [dataDict valueForKey:@"headimg"];
    userModel.birthday = [dataDict valueForKey:@"birthday"];
    userModel.ctime = [dataDict valueForKey:@"ctime"];
    userModel.height = [dataDict valueForKey:@"height"];
    userModel.pwd = [dataDict valueForKey:@"pwd"];
    userModel.nickname = [dataDict valueForKey:@"nickname"];
    userModel.status = [dataDict valueForKey:@"status"];
    
    return userModel;
}

@end
