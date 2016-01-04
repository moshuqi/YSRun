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
#import "YSUserInfoResponseModel.h"
#import "YSRegisterInfoRequestModel.h"
#import "YSModifyPasswordRequestModel.h"
#import "YSSetUserRequestModel.h"
#import "YSUploadRunDataRequestModel.h"
#import "YSRunDatabaseModel.h"
#import "YSUserDatabaseModel.h"
#import "YSThirdPartLoginResponseModel.h"

@interface YSNetworkRequest ()

@end

@implementation YSNetworkRequest

static YSNetworkRequest *_instance;
static const NSString *Host = @"http://mp.yspaobu.com/Api/webserver";

static const NSTimeInterval kTimeInterval = 5;

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
                                                     delegate:delegate
                                                  phoneNumber:phoneNumber];
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
                                   phoneNumber:(NSString *)phoneNumber
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
                [delegate captchaCorrectWithPhoneNumber:phoneNumber];
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
                YSUserInfoResponseModel *userInfoResponseModel = [self userInfoResponseModelFromDataDictionary:dict];
                
                [delegate userLoginSuccessWithUserInfoResponseModel:userInfoResponseModel];
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

- (void)userRegisterWithRequestModel:(YSRegisterInfoRequestModel *)requestModel delegate:(id<YSNetworkRequestDelegate>)delegate
{
    // 用户注册
    
    NSDictionary *dict = @{@"phone" : requestModel.phone,
                           @"pwd" : requestModel.pwd,
                           @"nickname" : requestModel.nickname};
    
    AFHTTPRequestOperationManager *s_manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [[self registerUrl] absoluteString];
    
    [s_manager POST:url parameters:dict constructingBodyWithBlock:^(id <AFMultipartFormData> formData)
    {
        if (requestModel.photoData)
        {
            [formData appendPartWithFileData:requestModel.photoData name:@"picFile" fileName:@"picFile.jpg" mimeType:@"image/png"];
        }
    }
            success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [self userRegisterRequestSucessWithOperation:operation
                                      responseObject:responseObject
                                            delegate:delegate];
    }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [self requestFailureWithError:error delegate:delegate];
    }];
}

- (void)userRegisterRequestSucessWithOperation:(AFHTTPRequestOperation *)operation
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
                NSString *uid = [responseObject valueForKey:@"uid"];
                [self.delegate userRegisterSuccessWithUid:uid];
            }
                break;
                
            default:
            {
                [self.delegate userRegisterFailureWithMessage:@"用户注册失败"];
            }
                break;
        }
        
        YSLog(@"%@", message);
    }
}

- (void)resetPasswordCaptchaWithPhoneNumber:(NSString *)phoneNumber delegate:(id<YSNetworkRequestDelegate>)delegate
{
    NSDictionary *dict = @{@"phone" : phoneNumber};
    NSMutableURLRequest *request = [self postRequestWithURL:[self resetPasswordCaptchaUrl] dictionaryParameter:dict];
    
    AFHTTPRequestOperationManager *s_manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation = [s_manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 [self resetPasswordCaptchaRequestSucessWithOperation:operation
                                                 responseObject:responseObject
                                                       delegate:delegate];
             }
                                               failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 [self requestFailureWithError:error delegate:delegate];
             }];
    [s_manager.operationQueue addOperation:operation];
}

- (void)resetPasswordCaptchaRequestSucessWithOperation:(AFHTTPRequestOperation *)operation
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
                [self.delegate acquireResetPasswordCaptchaSuccess];
                break;
                
            default:
                [self.delegate acquireResetPasswordCaptchaFailureWithMessage:@"验证码获取失败"];
                break;
        }
        
        YSLog(@"%@", message);
    }
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
    if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
    {
        NSString *resultKey = @"r";
        NSString *messageKey = @"m";
        
        NSInteger result = [[responseObject valueForKey:resultKey] integerValue];
        NSString *message = [responseObject valueForKey:messageKey];
        
        switch (result)
        {
            case 1:
                [self.delegate userResetPasswordSuccess];
                break;
                
            case -1:
                [self.delegate userResetPasswordFailureWithMessage:@"重置密码失败"];
                break;
                
            case 2:
                [self.delegate userResetPasswordFailureWithMessage:@"手机号码无效"];
                break;
                
            default:
                break;
        }
        
        YSLog(@"%@", message);
    }

}

- (void)modiyPasswordWithRequestModel:(YSModifyPasswordRequestModel *)requestModel  delegate:(id<YSNetworkRequestDelegate>)delegate
{
    // 修改密码
    
    NSDictionary *dict = @{@"phone" : requestModel.phone,
                           @"old_pwd" : requestModel.oldPassword,
                           @"new_pwd" : requestModel.modifiedPassword};
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
    if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
    {
        NSString *resultKey = @"r";
        NSString *messageKey = @"m";
        
        NSInteger result = [[responseObject valueForKey:resultKey] integerValue];
        NSString *message = [responseObject valueForKey:messageKey];
        
        switch (result)
        {
            case 1:
                [self.delegate userModifyPasswordSuccess];
                break;
                
            default:
                [self.delegate userModifyPasswordFailureWithMessage:@"修改密码失败"];
                break;
        }
        
        YSLog(@"%@", message);
    }
}

- (void)setUserWithRequestModel:(YSSetUserRequestModel *)requestModel delegate:(id<YSNetworkRequestDelegate>)delegate
{
    // 用户设置
    
    NSString *uid = requestModel.uid;
    NSString *nickname = (requestModel.nickname == nil) ? (NSString *)[NSNull null] : requestModel.nickname;
    
    // 暂时只有设置昵称
    NSDictionary *dict = @{@"uid" : uid,
                           @"nickname" : nickname};
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
    if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
    {
        NSString *resultKey = @"r";
        NSString *messageKey = @"m";
        
        NSInteger result = [[responseObject valueForKey:resultKey] integerValue];
        NSString *message = [responseObject valueForKey:messageKey];
        
        switch (result)
        {
            case 1:
                [self.delegate userSetInfoSuccess];
                break;
                
            default:
                [self.delegate userSetInfoFailureWithMessage:@"用户信息设置失败"];
                break;
        }
        
        YSLog(@"%@", message);
    }
}

- (void)getUserInfoWithUserID:(NSString *)uid delegate:(id<YSNetworkRequestDelegate>)delegate
{
    // 获取用户信息
    
    NSDictionary *dict = @{@"uid" : uid};
    NSMutableURLRequest *request = [self postRequestWithURL:[self getUserInfoUrl] dictionaryParameter:dict];
    
    AFHTTPRequestOperationManager *s_manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation = [s_manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 [self getUserInfoRequestSucessWithOperation:operation
                                              responseObject:responseObject
                                                    delegate:delegate
                                                         uid:uid];
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
                                          uid:(NSString *)uid
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
                NSDictionary *dict = [responseObject valueForKey:@"data"];
                NSString *lastTime = [responseObject valueForKey:@"lasttime"];
                
                YSUserDatabaseModel *userDatabaseModel = [self userDatabaseModelFromDictionary:dict uid:uid lastTime:lastTime];
                
                [self.delegate requestUserInfoSuccessWithModel:userDatabaseModel];
            }
                
                break;
                
            default:
                [self.delegate requestUserInfoFailureWithMessage:@"请求用户信息失败"];
                break;
        }
        
        YSLog(@"%@", message);
    }
}

- (void)getRunDataWithUid:(NSString *)uid lastTime:(NSInteger)lastTime delegate:(id<YSNetworkRequestDelegate>)delegate
{
    NSDictionary *dict = @{@"uid" : uid,
                           @"lasttime" : [NSNumber numberWithInteger:lastTime]};
    NSMutableURLRequest *request = [self postRequestWithURL:[self getRunDataUrl] dictionaryParameter:dict];
    
    AFHTTPRequestOperationManager *s_manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation = [s_manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [self getRunDataRequestSucessWithOperation:operation
                                          responseObject:responseObject
                                                delegate:delegate
                                                     uid:uid];
         }
                                           failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [self requestFailureWithError:error delegate:delegate];
         }];
    [s_manager.operationQueue addOperation:operation];
}

- (void)getRunDataRequestSucessWithOperation:(AFHTTPRequestOperation *)operation
                               responseObject:(id)responseObject
                                     delegate:(id<YSNetworkRequestDelegate>)delegate
                                         uid:(NSString *)uid
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
                // 服务端存在跑步数据
                NSArray *datas = [responseObject valueForKey:@"data"];
                NSMutableArray *runDataArray = [NSMutableArray array];
                
                NSString *lastTimeStr = [responseObject valueForKey:@"lasttime"];
                NSInteger lastTime = [lastTimeStr integerValue];
                
                for (NSInteger i = 0; i < [datas count]; i++)
                {
                    NSDictionary *dict = datas[i];
                    YSRunDatabaseModel *model = [self runDatabaseModelFromDataDictionary:dict uid:uid];
                    
                    [runDataArray addObject:model];
                }
                
                [self.delegate synchronizeLocalRunData:runDataArray lastTime:lastTime];
            }
                break;
                
            case -2:
            {
                // 服务端不存在lasttime之后需要同步的数据
                [self.delegate notRequiredSynchronized];
            }
                break;
                
            case -3:
            {
                // 该uid在服务器上的跑步数据为空
                [self.delegate getRunDataEmpty];
            }
                break;
                
            default:
                break;
        }
        
        YSLog(@"%@",message);
    }
}


- (void)uploadRunData:(YSUploadRunDataRequestModel *)runData delegate:(id<YSNetworkRequestDelegate>)delegate
{
    // 上传单次跑步数据
    
    NSString *uid = (runData.uid != nil) ? runData.uid : (NSString *)[NSNull null];
    NSNumber *pace = [NSNumber numberWithFloat:runData.pace];
    NSNumber *distance = [NSNumber numberWithFloat:runData.distance];
    NSNumber *usetime = [NSNumber numberWithInteger:runData.usetime];
    NSNumber *cost = [NSNumber numberWithInteger:runData.cost];
    NSNumber *star = [NSNumber numberWithInteger:runData.star];
    NSNumber *h_speed = [NSNumber numberWithFloat:runData.h_speed];
    NSNumber *l_speed = [NSNumber numberWithFloat:runData.l_speed];
    NSString *date = (runData.date != nil) ? runData.date : (NSString *)[NSNull null];
    NSNumber *bdate = [NSNumber numberWithInteger:runData.bdate];
    
    // Android那边的是毫秒。。服务器处理的时候除了个1000，所以。。否则date字段会为1970..
    NSNumber *edate = [NSNumber numberWithInteger:runData.edate * 1000];
    NSNumber *speed = [NSNumber numberWithFloat:runData.speed];
    
    // 这2个字段暂时没有数据。
    NSString *ctime = (NSString *)[NSNull null];
    NSString *utime = (NSString *)[NSNull null];
    
    NSString *location = (runData.locationDataString != nil) ? runData.locationDataString : (NSString *)[NSNull null];
    NSString *heartdata = (runData.heartRateDataString != nil) ? runData.heartRateDataString : (NSString *)[NSNull null];
    
    NSDictionary *dict = @{@"uid" : uid,
                           @"pace" : pace,
                           @"distance" : distance,
                           @"usetime" : usetime,
                           @"cost" : cost,
                           @"star" : star,
                           @"h_speed" : h_speed,
                           @"l_speed" : l_speed,
                           @"date" : date,
                           @"bdate" : bdate,
                           @"edate" : edate,
                           @"speed" : speed,
                           @"ctime" : ctime,
                           @"utime" : utime,
                           @"location" : location,
                           @"heartdata" : heartdata};
    
    NSMutableURLRequest *request = [self postRequestWithURL:[self uploadRunDataUrl] dictionaryParameter:dict];
    
    AFHTTPRequestOperationManager *s_manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation = [s_manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 [self uploadRunDataRequestSucessWithOperation:operation
                                                responseObject:responseObject
                                                      delegate:delegate
                                                  runDataRowid:runData.rowid];
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
                                   runDataRowid:(NSInteger)rowid
{
    if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
    {
        NSString *resultKey = @"r";
        NSString *messageKey = @"m";
        NSString *lasttimeKey = @"lasttime";
        
        NSInteger result = [[responseObject valueForKey:resultKey] integerValue];
        NSString *message = [responseObject valueForKey:messageKey];
        NSString *lasttime = [responseObject valueForKey:lasttimeKey];
        
        switch (result)
        {
            case 1:
                [self.delegate uploadUserRunDataSuccessWithlocalRowid:rowid lasttime:lasttime];
                break;
                
            default:
                [self.delegate uploadUserRunDataFailureWithMessage:@"上传跑步数据失败"];
                break;
        }
        
        YSLog(@"%@", message);
    }
}

- (void)uploadHeadImage:(UIImage *)headImage uid:(NSString *)uid delegate:(id<YSNetworkRequestDelegate>)delegate
{
    // 上传头像
    
    NSDictionary *dict = @{@"uid" : uid};
    
    AFHTTPRequestOperationManager *s_manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [[self uploadHeadImgUrl] absoluteString];
    
    NSData *imageData = UIImageJPEGRepresentation(headImage, 1.0);
    
    [s_manager POST:url parameters:dict constructingBodyWithBlock:^(id <AFMultipartFormData> formData)
     {
         [formData appendPartWithFileData:imageData name:@"picFile" fileName:@"picFile.jpg" mimeType:@"image/png"];
     }
            success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self uploadHeadImageRequestSucessWithOperation:operation
                                       responseObject:responseObject
                                             delegate:delegate];
     }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self requestFailureWithError:error delegate:delegate];
     }];
}

- (void)uploadHeadImageRequestSucessWithOperation:(AFHTTPRequestOperation *)operation
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
                NSString *path = [responseObject valueForKey:@"path"];
                NSString *prefix = @"http://mp.yspaobu.com";
                
                NSString *headImagePath = [NSString stringWithFormat:@"%@%@", prefix, path];
                [self.delegate userUploadHeadImageSuccessWithPath:headImagePath];
                
            }
                break;
                
            default:
                [self.delegate userUploadHeadImageFailureWithMessage:@"上传头像失败"];
                break;
        }
        
        YSLog(@"%@", message);
    }
}

// 第三方登录

- (void)thirdPartLoginWithModel:(YSThirdPartLoginResponseModel *)model delegate:(id<YSNetworkRequestDelegate>)delegate
{
    // iOS的SDK请求能直接获取到用户的数据，此时不需要再通过服务器向第三方服务器请求用户数据，所以只需将对应字段向服务器再做一次请求，之后的流程和登录一致
    NSDictionary *dict = [self requestDictFromThirdPartLoginModel:model];
    NSMutableURLRequest *request = [self postRequestWithURL:[self thirdPartLoginUrl] dictionaryParameter:dict];
    
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

#pragma mark - private method

- (NSMutableURLRequest *)postRequestWithURL:(NSURL *)url dictionaryParameter:(NSDictionary *)dictionary
{
    // 网络请求都用post,dictionary转化成json，并压缩作为request的参数
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    NSData *zipData = [LFCGzipUtillity gzipData:data];
    [request setHTTPBody:zipData];
    [request setHTTPMethod:@"POST"];
    
    request.timeoutInterval = kTimeInterval;
    
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

- (NSURL *)resetPasswordCaptchaUrl
{
    NSString *name = @"/preresetpwd";
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

- (NSURL *)getRunDataUrl
{
    NSString *name = @"/getRunData";
    return [self getUrlWithRequestName:name];
}

- (NSURL *)uploadHeadImgUrl
{
    NSString *name = @"/uploadHeadImg";
    return [self getUrlWithRequestName:name];
}

- (NSURL *)qqLoginUrl
{
    NSString *name = @"/qqlogin";
    return [self getUrlWithRequestName:name];
}

- (NSURL *)wechatLoginUrl
{
    NSString *name = @"/wxlogin";
    return [self getUrlWithRequestName:name];
}

- (NSURL *)weiboLoginUrl
{
    NSString *name = @"/wblogin";
    return [self getUrlWithRequestName:name];
}

- (NSURL *)thirdPartLoginUrl
{
    // 统一用微博的接口方式
    NSString *name = @"/wblogin";
    return [self getUrlWithRequestName:name];
}

- (YSUserInfoResponseModel *)userInfoResponseModelFromDataDictionary:(NSDictionary *)dataDict
{
    YSUserInfoResponseModel *userInfoResponseModel = [YSUserInfoResponseModel new];
    
    userInfoResponseModel.ID = [dataDict valueForKey:@"id"];
    userInfoResponseModel.utime = [dataDict valueForKey:@"utime"];
    userInfoResponseModel.phone = [dataDict valueForKey:@"phone"];
    userInfoResponseModel.uid = [dataDict valueForKey:@"uid"];
    userInfoResponseModel.sex = [dataDict valueForKey:@"sex"];
    userInfoResponseModel.age = [dataDict valueForKey:@"age"];
    userInfoResponseModel.headimg = [dataDict valueForKey:@"headimg"];
    userInfoResponseModel.birthday = [dataDict valueForKey:@"birthday"];
    userInfoResponseModel.ctime = [dataDict valueForKey:@"ctime"];
    userInfoResponseModel.height = [dataDict valueForKey:@"height"];
    userInfoResponseModel.pwd = [dataDict valueForKey:@"pwd"];
    userInfoResponseModel.nickname = [dataDict valueForKey:@"nickname"];
    userInfoResponseModel.status = [dataDict valueForKey:@"status"];
    
    return userInfoResponseModel;
}

- (YSRunDatabaseModel *)runDatabaseModelFromDataDictionary:(NSDictionary *)dataDict uid:(NSString *)uid
{
    YSRunDatabaseModel *runDatabaseModel = [YSRunDatabaseModel new];
    
    runDatabaseModel.uid = uid;
    runDatabaseModel.isUpdate = 1;
    
    runDatabaseModel.bdate = [[dataDict valueForKey:@"bdate"] integerValue];
    runDatabaseModel.cost = [[dataDict valueForKey:@"cost"] integerValue];
    runDatabaseModel.distance = [[dataDict valueForKey:@"distance"] floatValue];
    runDatabaseModel.speed = [[dataDict valueForKey:@"speed"] floatValue];
    runDatabaseModel.star = [[dataDict valueForKey:@"star"] integerValue];
    runDatabaseModel.hSpeed = [[dataDict valueForKey:@"h_speed"] floatValue];
    runDatabaseModel.date = [dataDict valueForKey:@"date"];
    runDatabaseModel.pace = [[dataDict valueForKey:@"pace"] floatValue];
    runDatabaseModel.lSpeed = [[dataDict valueForKey:@"l_speed"] floatValue];
    runDatabaseModel.usetime = [[dataDict valueForKey:@"usetime"] integerValue];
    
    runDatabaseModel.heartRateDataString = [dataDict valueForKey:@"heartdata"];
    runDatabaseModel.locationDataString = [dataDict valueForKey:@"location"];
    
    return runDatabaseModel;
}

- (YSUserDatabaseModel *)userDatabaseModelFromDictionary:(NSDictionary *)dict uid:(NSString *)uid lastTime:(NSString *)lastTime
{
    YSUserDatabaseModel *userDatabaseModel = [YSUserDatabaseModel new];
    
    userDatabaseModel.uid = uid;
    userDatabaseModel.phone = [dict valueForKey:@"phone"];
    userDatabaseModel.nickname = [dict valueForKey:@"nickname"];
    userDatabaseModel.birthday = [dict valueForKey:@"birthday"];
    userDatabaseModel.headimg = [dict valueForKey:@"headimg"];
    userDatabaseModel.lasttime = lastTime;
    
    id heightValue = [dict valueForKey:@"height"];
    userDatabaseModel.height = ([heightValue isKindOfClass:[NSNull class]]) ? 0 : [heightValue integerValue];
    id ageValue = [dict valueForKey:@"age"];
    userDatabaseModel.age = ([ageValue isKindOfClass:[NSNull class]]) ? 0 : [ageValue integerValue];
    id sexValue = [dict valueForKey:@"sex"];
    userDatabaseModel.sex = ([sexValue isKindOfClass:[NSNull class]]) ? 0 : [sexValue integerValue];
    
    return userDatabaseModel;
}

- (NSDictionary *)requestDictFromThirdPartLoginModel:(YSThirdPartLoginResponseModel *)model
{
    // 第三方登录向服务器请求的参数
    NSDictionary *dict = @{@"idstr" : [self getFromString:model.idstr],
                           @"screen_name" : [self getFromString:model.screenName],
                           @"city" : [self getFromString:model.city],
                           @"province" : [self getFromString:model.province],
                           @"profile_image_url" : [self getFromString:model.profileImageUrl],
                           @"gender" : [self getFromString:model.gender]
                           };
    
    return dict;
}

- (NSString *)getFromString:(NSString *)string
{
    // 保证用在dictionary不为nil
    NSString *s = (string != nil) ? string : (NSString *)[NSNull null];
    return s;
}

@end
