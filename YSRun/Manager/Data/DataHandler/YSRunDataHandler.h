//
//  YSRunDataHandler.h
//  YSRun
//
//  Created by moshuqi on 15/11/18.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YSRunDataHandlerDelegate <NSObject>

@optional
- (void)runDataHandleFinish;   // 在回调中处理完数据后通知界面的更新。

@end

@class YSRunDatabaseModel;
@class YSUserInfoResponseModel;
@class YSUserDatabaseModel;

@interface YSRunDataHandler : NSObject

@property (nonatomic, weak) id<YSRunDataHandlerDelegate> delegate;

- (void)synchronizeRunData;
- (void)uploadNotLoginRunData;
- (void)recordSingleRunData:(YSRunDatabaseModel *)runDatabaseModel;

- (void)loginSuccessWithUserInfoResponseModel:(YSUserInfoResponseModel *)userInfoResponseModel
;
- (void)registerSuccessWithResponseUserInfo:(YSUserDatabaseModel *)userInfo;

@end
