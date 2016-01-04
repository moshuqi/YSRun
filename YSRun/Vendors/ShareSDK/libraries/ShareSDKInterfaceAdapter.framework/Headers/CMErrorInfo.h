//
//  VFErrorInfo.m
//  AppgoFramework
//
//  Created by 冯 鸿杰 on 12-12-27.
//  Copyright (c) 2012年 掌淘科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICMErrorInfo.h"

///#begin zh-cn
/**
 *	@brief	异常信息
 */
///#end
///#begin en
/**
 *	@brief	Error information.
 */
///#end
@interface CMErrorInfo : NSObject <ICMErrorInfo>

///#begin zh-cn
/**
 *	@brief	错误代码，如果为调用API出错则应该参考API错误码对照表，如果为HTTP错误，此属性则指示HTTP错误码。
 */
///#end
///#begin en
/**
 *	@brief	Error code，If it is you call the API, you should see the error code table, if it is an HTTP error, this attribute indicates the HTTP error code.
 */
///#end
@property (nonatomic,assign) NSInteger errorCode;

///#begin zh-cn
/**
 *	@brief	错误描述，对应相应的错误码的描述
 */
///#end
///#begin en
/**
 *	@brief	Error description
 */
///#end
@property (nonatomic,copy) NSString *errorDescription;

///#begin zh-cn
/**
 *	@brief	错误级别
 */
///#end
///#begin en
/**
 *	@brief	Error level.
 */
///#end
@property (nonatomic) CMErrorLevel errorLevel;


@end
