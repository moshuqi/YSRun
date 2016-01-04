//
//  YSThirdPartLoginResponseModel.h
//  YSRun
//
//  Created by moshuqi on 15/12/6.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YSThirdPartLoginType)
{
    YSThirdPartLoginTypeNone = 0,
    YSThirdPartLoginTypeWeibo,
    YSThirdPartLoginTypeWechat,
    YSThirdPartLoginTypeQQ
};

@interface YSThirdPartLoginResponseModel : NSObject

// 向服务器请求时对应的字段，主要保证有昵称、头像、openid即可。
@property (nonatomic, copy) NSString *screenName;   // 昵称
@property (nonatomic, copy) NSString *gender;       // 性别，m为男，SDK请求到的gender为int，赋值时做相应处理
@property (nonatomic, copy) NSString *city;         // 城市
@property (nonatomic, copy) NSString *province;     // 省市
@property (nonatomic, copy) NSString *profileImageUrl;      // 头像的url
@property (nonatomic, copy) NSString *idstr;        // openid

@end
