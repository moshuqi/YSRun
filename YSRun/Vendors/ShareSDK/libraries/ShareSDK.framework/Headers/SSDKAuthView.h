//
//  SSDKAuthView.h
//  ShareSDK
//
//  Created by 冯 鸿杰 on 15/2/27.
//  Copyright (c) 2015年 掌淘科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSDKTypeDefine.h"

/**
 *  授权视图
 */
@interface SSDKAuthView : UIView

/**
 *  取消授权
 */
- (void)cancel;

/**
 *  授权状态变更时触发
 *
 *  @param stateChangedHandler 授权状态变更处理器
 */
- (void)onAuthStateChanged:(SSDKAuthorizeStateChangedHandler)stateChangedHandler;

@end
