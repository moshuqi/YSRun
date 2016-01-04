//
//  SSCAttachment.h
//  ShareSDKCoreService
//
//  Created by 冯 鸿杰 on 13-3-15.
//  Copyright (c) 2013年 掌淘科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISSCAttachment.h"

/**
 *	@brief	附件信息
 */
@interface SSCAttachment : NSObject <ISSCAttachment>
{
@private
    id _completeHandler;
    id _faultHandler;
}

/**
 *	@brief	文件路径
 */
@property (nonatomic,readonly) NSString *path;

/**
 *	@brief	远程文件路径
 */
@property (nonatomic,readonly) NSString *url;

/**
 *	@brief	是否为远程文件
 */
@property (nonatomic,readonly) BOOL isRemoteFile;

/**
 *	@brief	文件数据
 */
@property (nonatomic,readonly) NSData *data;

/**
 *	@brief	文件名称
 */
@property (nonatomic,readonly) NSString *fileName;

/**
 *	@brief	mime类型
 */
@property (nonatomic,readonly) NSString *mimeType;

/**
 *	@brief	初始化附件
 *
 *	@param 	path 	路径
 *
 *	@return	附件信息
 */
- (id)initWithPath:(NSString *)path;

/**
 *	@brief	初始化附件
 *
 *	@param 	data 	文件数据
 *	@param 	fileName 	文件名称
 *	@param 	mimeType 	MIME类型
 *
 *	@return	附件信息
 */
- (id)initWithData:(NSData *)data fileName:(NSString *)fileName mimeType:(NSString *)mimeType;

/**
 *	@brief	初始化附件
 *
 *	@param 	url 	网络地址
 *
 *	@return	附件信息
 */
- (id)initWithUrl:(NSString *)url;

@end
