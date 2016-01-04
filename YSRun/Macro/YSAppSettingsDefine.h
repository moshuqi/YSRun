//
//  YSAppSettingsDefine.h
//  YSRun
//
//  Created by moshuqi on 15/12/8.
//  Copyright © 2015年 msq. All rights reserved.
//

#ifndef YSAppSettingsDefine_h
#define YSAppSettingsDefine_h

// 语音提示类型，暂时只有男声和女声，关闭
typedef NS_ENUM(NSInteger, YSVoicePromptType) {
    YSVoicePromptTypeMan = 1,
    YSVoicePromptTypeGirl = 2,
    YSVoicePromptClose
};

#define YSBLEConnectPromptHiddenKey         @"YSBLEConnectPromptHiddenKey"      // 蓝牙设备连接的不再提示
#define YSHeartRatePanelShowStateKey        @"YSHeartRatePanelShowStateKey"     // 心率面板显示是否需要显示
#define YSVoicePromptTypeKey                @"YSVoicePromptTypeKey"             // 语音提示类型

#define YSDatabaseVersionKey                @"YSDatabaseVersionKey"             // 数据库的版本号

#endif /* YSAppSettingsDefine_h */
