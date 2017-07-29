//
//  YSShareFunc.h
//  YSRun
//
//  Created by moshuqi on 15/12/5.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSShareInfo.h"
#import "YSThirdPartLoginResponseModel.h"
#import <ShareSDK/ShareSDK.h>

@class UIView;
@class UIViewController;

typedef NS_ENUM(NSInteger, YSShareFuncResponseState) {
    YSShareFuncResponseStateBegin = 0,
    YSShareFuncResponseStateSuccess,
    YSShareFuncResponseStateFail,
    YSShareFuncResponseStateCancel
};

typedef void(^ShareFuncCallbackBlock)(YSShareFuncResponseState);
typedef void(^ThirdPartLoginCallbackBlock)(YSShareFuncResponseState, YSThirdPartLoginResponseModel*);

@interface YSShareFunc : NSObject

+ (void)shareConfig;

+ (void)shareInfo:(YSShareInfo *)shareInfo
         fromView:(UIView *)view
    callbackBlock:(ShareFuncCallbackBlock)callbackBlock;
+ (void)shareInfo:(YSShareInfo *)shareInfo
       byPlatform:(SSDKPlatformType)platform
    callbackBlock:(ShareFuncCallbackBlock)callbackBlock;

+ (void)showLoginActionSheetFromViewController:(UIViewController *)viewController
                                 callbackBlock:(ThirdPartLoginCallbackBlock)callbackBlock;
+ (void)thirdPartLoginByPlatform:(SSDKPlatformType)platform
                   callbackBlock:(ThirdPartLoginCallbackBlock)callbackBlock;

+ (BOOL)hasAuthorized;
+ (void)cancelAuthorized;
+ (BOOL)hasClientInstalled;

@end
