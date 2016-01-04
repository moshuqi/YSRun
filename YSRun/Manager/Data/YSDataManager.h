//
//  YSDataManager.h
//  YSRun
//
//  Created by moshuqi on 15/10/26.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YSUserInfoModel;

@interface YSDataManager : NSObject

+ (instancetype)shareDataManager;

- (void)resetData;
- (BOOL)isLogin;
- (BOOL)isThirdPartLogin;
- (YSUserInfoModel *)getUserInfo;

- (NSString *)getUserName;
- (NSString *)getUid;
- (NSString *)getUserPhone;

@end
