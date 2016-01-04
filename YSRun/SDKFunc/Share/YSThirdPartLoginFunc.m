//
//  YSThirdPartLoginFunc.m
//  YSRun
//
//  Created by moshuqi on 15/12/10.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSThirdPartLoginFunc.h"
#import "YSShareFunc.h"
#import "YSIconActionSheet.h"
#import <UIKit/UIKit.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

@interface YSThirdPartLoginFunc ()

@property (nonatomic, strong) YSIconActionSheet *actionSheet;

@end

@implementation YSThirdPartLoginFunc

- (void)showActionSheet
{
    NSArray *dictArray = [self itemDictArray];
    if ([dictArray count] > 0)
    {
        self.actionSheet = [[YSIconActionSheet alloc] initWithDictArray:dictArray];
        [self.actionSheet showIconActionSheet];
    }
    else
    {
        [self showClientNoInstalledAlert];
    }
}

- (void)showClientNoInstalledAlert
{
    // 没有安装任何一个客户端。
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请确保已安装QQ、微信、新浪微博任一客户端"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (NSArray *)itemDictArray
{
    NSMutableArray *dictArray = [NSMutableArray array];
    
    if ([ShareSDK isClientInstalled:SSDKPlatformTypeQQ])
    {
        UIImage *qqIcon = [UIImage imageNamed:@"qq_icon"];
        NSDictionary *qqItem = [self itemDictWithImage:qqIcon text:@"QQ" object:self selectorStr:@"qqLogin"];
        [dictArray addObject:qqItem];
    }
    
    if ([ShareSDK isClientInstalled:SSDKPlatformTypeWechat])
    {
        UIImage *wechatIcon = [UIImage imageNamed:@"wechat_icon"];
        NSDictionary *wechatItem = [self itemDictWithImage:wechatIcon text:@"微信" object:self selectorStr:@"wechatLogin"];
        [dictArray addObject:wechatItem];
    }
    
    if ([ShareSDK isClientInstalled:SSDKPlatformTypeSinaWeibo])
    {
        UIImage *weiboIcon = [UIImage imageNamed:@"weibo_icon"];
        NSDictionary *weiboItem = [self itemDictWithImage:weiboIcon text:@"新浪微博" object:self selectorStr:@"weiboLogin"];
        [dictArray addObject:weiboItem];
    }
    
    return dictArray;
}

- (NSDictionary *)itemDictWithImage:(UIImage *)image
                               text:(NSString *)text
                             object:(id)object
                        selectorStr:(NSString *)selectorStr
{
    NSDictionary *dict = @{YSIconActionSheetItemIconKey : image,
                           YSIconActionSheetItemTextKey : text,
                           YSIconActionSheetItemSelectorStringKey : selectorStr,
                           YSIconActionSheetItemObjectKey : object};
    return dict;
}

// 第三方登录暂时只支持QQ、微信、新浪微博
- (void)qqLogin
{
    [self thirdPartLoginByPlatform:SSDKPlatformTypeQQ];
}

- (void)wechatLogin
{
    [self thirdPartLoginByPlatform:SSDKPlatformTypeWechat];
}

- (void)weiboLogin
{
    [self thirdPartLoginByPlatform:SSDKPlatformTypeSinaWeibo];
}

- (void)thirdPartLoginByPlatform:(SSDKPlatformType)platform
{
    // 登录之后的回调
    ThirdPartLoginCallbackBlock callback = ^(YSShareFuncResponseState state, YSThirdPartLoginResponseModel* responseModel)
    {
        if (state == YSShareFuncResponseStateSuccess)
        {
            // 登录成功
            [self.delegate thirdPartLoginSuccessWithResponseModel:responseModel];
        }
        else
        {
            // 登录失败
            [self.delegate thirdPartLoginFailureWithMessage:@"登录失败"];
        }
    };
    
    [YSShareFunc thirdPartLoginByPlatform:platform callbackBlock:callback];
    
    // 点击按钮之后sheet收起隐藏
    [self.actionSheet hideIconActionSheet];
}

@end
