//
//  YSShareFunc.m
//  YSRun
//
//  Created by moshuqi on 15/12/5.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSShareFunc.h"
#import "YSUtilsMacro.h"

#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <ShareSDK/ShareSDK+Base.h>
//#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"

@implementation YSShareFunc

+ (void)shareConfig
{
    // 暂只支持微信、QQ、微博的分享，而且是其中的子平台。
    [ShareSDK registerApp:@"bce22a9fa218"
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
//                            @(SSDKPlatformSubTypeWechatSession),
//                            @(SSDKPlatformSubTypeWechatTimeline),
                            @(SSDKPlatformTypeQQ),
//                            @(SSDKPlatformSubTypeQZone)
                            ]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                         default:
                             break;
                     }
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"135783971"
                                                appSecret:@"d49fa05e72d226f4d1bf83b4fcf6ae62"
                                              redirectUri:@"http://www.yspaobu.com"
                                                 authType:SSDKAuthTypeBoth];
                      break;
//                  case SSDKPlatformTypeTencentWeibo:
//                      //设置腾讯微博应用信息，其中authType设置为只用Web形式授权
//                      [appInfo SSDKSetupTencentWeiboByAppKey:@"801307650"
//                                                   appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
//                                                 redirectUri:@"http://www.sharesdk.cn"];
//                      break;
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"wx90ba4bea7d713467"
                                            appSecret:@"d4624c36b6795d1d99dcf0547af5443d"];
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:@"1104855423"
                                           appKey:@"XQA4q5owJjroKMzx"
                                         authType:SSDKAuthTypeBoth];
                      break;
                  default:
                      break;
              }
          }];
    
    [ShareSDK isClientInstalled:SSDKPlatformTypeQQ];
}

+ (void)shareInfo:(YSShareInfo *)shareInfo fromView:(UIView *)view callbackBlock:(ShareFuncCallbackBlock)callbackBlock
{
    if ([shareInfo.imageArray count] < 1)
    {
        YSLog(@"分享的照片为空");
        return;
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:shareInfo.contentText
                                     images:shareInfo.imageArray
                                        url:shareInfo.url
                                      title:shareInfo.title
                                       type:SSDKContentTypeAuto];
    
    // 通过客户端打开分享
    [shareParams SSDKEnableUseClientShare];
    
    NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:[ShareSDK activePlatforms]];
    SSUIShareActionSheetController *sheet =
    [ShareSDK showShareActionSheet:view
                             items:activePlatforms
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
                           //                           [theController showLoadingView:YES];
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           callbackBlock(YSShareFuncResponseStateSuccess);
                           
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       default:
                           break;
                   }
                   
                   if (state != SSDKResponseStateBegin)
                   {
                       //                       [theController showLoadingView:NO];
                       //                       [theController.tableView reloadData];
                   }
                   
               }];
    
    // 跳过编辑页面，直接打开客户端进行编辑
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeQQ)];
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeWechat)];
}

+ (void)showLoginActionSheetFromViewController:(UIViewController *)viewController
                                 callbackBlock:(ThirdPartLoginCallbackBlock)callbackBlock
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if ([ShareSDK isClientInstalled:SSDKPlatformTypeWechat])
    {
        [alertController addAction: [UIAlertAction actionWithTitle: @"微信" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [YSShareFunc thirdPartLoginByPlatform:SSDKPlatformTypeWechat callbackBlock:callbackBlock];
        }]];
    }
    
    if ([ShareSDK isClientInstalled:SSDKPlatformTypeQQ])
    {
        [alertController addAction: [UIAlertAction actionWithTitle: @"QQ" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [YSShareFunc thirdPartLoginByPlatform:SSDKPlatformTypeQQ callbackBlock:callbackBlock];
        }]];
    }
    
    if ([ShareSDK isClientInstalled:SSDKPlatformTypeSinaWeibo])
    {
        [alertController addAction: [UIAlertAction actionWithTitle: @"新浪微博" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [YSShareFunc thirdPartLoginByPlatform:SSDKPlatformTypeSinaWeibo callbackBlock:callbackBlock];
        }]];
    }
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
}

+ (void)thirdPartLoginByPlatform:(SSDKPlatformType)platform
                   callbackBlock:(ThirdPartLoginCallbackBlock)callbackBlock
{
    [SSEThirdPartyLoginHelper loginByPlatform:platform
           onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
               
               //在此回调中可以将社交平台用户信息与自身用户系统进行绑定，最后使用一个唯一用户标识来关联此用户信息。
               //在此示例中没有跟用户系统关联，则使用一个社交用户对应一个系统用户的方式。将社交用户的uid作为关联ID传入associateHandler。
               associateHandler (user.uid, user, user);
               NSLog(@"dd%@",user.rawData);
               NSLog(@"dd%@",user.credential);
               
           }
        onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
            
            YSThirdPartLoginResponseModel *model = nil;
            YSShareFuncResponseState responseState = YSShareFuncResponseStateBegin;
            if (state == SSDKResponseStateSuccess)
            {
                responseState = YSShareFuncResponseStateSuccess;
                model = [YSThirdPartLoginResponseModel new];
                
                [ShareSDK getUserInfo:platform conditional:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error){
                    if (state == SSDKResponseStateSuccess)
                    {
                        NSDictionary *rawDataOfCredential = user.credential.rawData;
                        NSString *openid = [rawDataOfCredential valueForKey:@"openid"];
                        
                        model.idstr = openid;
                        model.screenName = user.nickname;
                        model.profileImageUrl = user.icon;
                        
                        NSDictionary *dict = user.rawData;
                        model.city = [dict valueForKey:@"city"];
                        model.province = [dict valueForKey:@"province"];
                        
                        model.gender = (user.gender == 0) ? @"m" : @"w";
                        callbackBlock(responseState, model);
                    }
                }];
            }
            else if (state == SSDKResponseStateFail)
            {
//                responseState = YSShareFuncResponseStateFail;
            }
            else if (state == SSDKResponseStateCancel)
            {
//                responseState = YSShareFuncResponseStateCancel;
            }
            
        }];
}

+ (void)test
{
//    [ShareSDK authWithType:SSDKPlatformTypeQQ];
    
    [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeQQ
                                   onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                                       
                                       //在此回调中可以将社交平台用户信息与自身用户系统进行绑定，最后使用一个唯一用户标识来关联此用户信息。
                                       //在此示例中没有跟用户系统关联，则使用一个社交用户对应一个系统用户的方式。将社交用户的uid作为关联ID传入associateHandler。
                                       associateHandler (user.uid, user, user);
                                       NSLog(@"dd%@",user.rawData);
                                       NSLog(@"dd%@",user.credential);
                                       
                                   }
                                onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                                    
                                    if (state == SSDKResponseStateSuccess)
                                    {
                                        
                                    }
                                    
                                }];
}

+ (BOOL)hasAuthorized
{
    NSArray *platforms = [YSShareFunc platforms];
    for (NSInteger i = 0; i < [platforms count]; i++)
    {
        SSDKPlatformType type = (SSDKPlatformType)[platforms[i] integerValue];
        BOOL hasAuthorized = [ShareSDK hasAuthorized:type];
        
        if (hasAuthorized)
        {
            return YES;
        }
    }

    return NO;
}

+ (void)cancelAuthorized
{
    // 取消授权，用户退出的时候调用
    NSArray *platforms = [YSShareFunc platforms];
    for (NSInteger i = 0; i < [platforms count]; i++)
    {
        SSDKPlatformType type = (SSDKPlatformType)[platforms[i] integerValue];
        [ShareSDK cancelAuthorize:type];
    }
}

+ (NSArray *)platforms
{
    // 授权的平台列表
    NSArray *platforms = @[[NSNumber numberWithInteger:SSDKPlatformTypeQQ],
                           [NSNumber numberWithInteger:SSDKPlatformTypeWechat],
                           [NSNumber numberWithInteger:SSDKPlatformTypeSinaWeibo]];
    
    return platforms;
}

+ (BOOL)hasClientInstalled
{
    // 是否安装有客户端
    BOOL hasClientInstalled = ([ShareSDK isClientInstalled:SSDKPlatformTypeQQ] ||
                               [ShareSDK isClientInstalled:SSDKPlatformTypeWechat] ||
                               [ShareSDK isClientInstalled:SSDKPlatformTypeSinaWeibo]);
    return hasClientInstalled;
}

@end
