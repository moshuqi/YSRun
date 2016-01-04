//
//  YSSettingsTypeDefine.h
//  YSRun
//
//  Created by moshuqi on 15/12/7.
//  Copyright © 2015年 msq. All rights reserved.
//

#ifndef YSSettingsTypeDefine_h
#define YSSettingsTypeDefine_h

typedef NS_ENUM(NSInteger, YSSettingsType) {
    YSSettingsTypeNone = 0,
    YSSettingsTypeHeartRatePanel = 1,       // 心率面板
    YSSettingsTypeVoicePrompt,              // 语音提示
    YSSettingsTypeModifyPassword,           // 修改密码
    YSSettingsTypeFeedback,                 // 用户反馈
    YSSettingsTypeLogout,                   // 退出登录
    YSSettingsTypeMeasure,                  // 单位计量
    YSSettingsTypeNickname,                 // 用户昵称
    YSSettingsTypeSet                       // 设置
};

#endif /* YSSettingsTypeDefine_h */
