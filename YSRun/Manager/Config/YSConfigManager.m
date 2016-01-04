//
//  YSConfigManager.m
//  YSRun
//
//  Created by moshuqi on 15/12/8.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSConfigManager.h"

@implementation YSConfigManager

static YSConfigManager *_instance;

+ (id)allocWithZone:(struct _NSZone *)zone
{
    //调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)shareConfigManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YSConfigManager alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

+ (BOOL)BLEConnectPromptHidden
{
    // 是否不再提示蓝牙连接提示
    BOOL bHidden = [[NSUserDefaults standardUserDefaults] boolForKey:YSBLEConnectPromptHiddenKey];
    return bHidden;
}

+ (void)setBLEConnectHintHidden:(BOOL)hidden
{
    // 设置是否显示蓝牙连接提示
    [[NSUserDefaults standardUserDefaults] setBool:hidden forKey:YSBLEConnectPromptHiddenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)heartRatePanelHidden
{
    // 是否隐藏心率面板
    BOOL bHidden = [[NSUserDefaults standardUserDefaults] boolForKey:YSHeartRatePanelShowStateKey];
    return bHidden;
}

+ (void)setHeartRatePanelHidden:(BOOL)hidden
{
    // 设置心率面板是否显示
    [[NSUserDefaults standardUserDefaults] setBool:hidden forKey:YSHeartRatePanelShowStateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (YSVoicePromptType)voicePromptType
{
    // 是否已经设置过提示音类型，默认为男声
    BOOL bSet = ([[NSUserDefaults standardUserDefaults] objectForKey:YSVoicePromptTypeKey] != nil);
    if (bSet)
    {
        YSVoicePromptType type = (YSVoicePromptType)[[NSUserDefaults standardUserDefaults] integerForKey:YSVoicePromptTypeKey];
        return type;
    }
    
    return YSVoicePromptTypeMan;
}

+ (void)setVoicePromptType:(YSVoicePromptType)type
{
    // 设置语音提示类型，暂时只支持两种
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:YSVoicePromptTypeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getVoiceTypeNameStringWithType:(YSVoicePromptType)type
{
    NSString *string = @"男声";
    if (type == YSVoicePromptTypeGirl)
    {
        string = @"女声";
    }
    else if (type == YSVoicePromptClose)
    {
        string = @"关";
    }
    
    return string;
}

@end
