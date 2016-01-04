//
//  YSConfigManager.h
//  YSRun
//
//  Created by moshuqi on 15/12/8.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSAppSettingsDefine.h"

@interface YSConfigManager : NSObject

+ (instancetype)shareConfigManager;

+ (BOOL)BLEConnectPromptHidden;
+ (void)setBLEConnectHintHidden:(BOOL)hidden;

+ (BOOL)heartRatePanelHidden;
+ (void)setHeartRatePanelHidden:(BOOL)hidden;

+ (YSVoicePromptType)voicePromptType;
+ (void)setVoicePromptType:(YSVoicePromptType)type;
+ (NSString *)getVoiceTypeNameStringWithType:(YSVoicePromptType)type;

@end
