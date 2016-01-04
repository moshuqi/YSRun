//
//  SSContent.h
//  ShareSDKInterface
//
//  Created by gzsj on 13-4-3.
//  Copyright (c) 2013年 掌淘科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISSContent.h"

/**
 *	@brief	分享内容信息
 */
@interface SSContent : NSObject<ISSContent,NSCoding>
{
@private
    NSMutableDictionary *_metadata;
    NSMutableDictionary *_units;
}

/**
 *	@brief	标题
 */
@property (nonatomic,copy) NSString *title;

/**
 *	@brief	链接
 */
@property (nonatomic,copy) NSString *url;

/**
 *	@brief	主体内容
 */
@property (nonatomic,copy) NSString *desc;

/**
 *	@brief	分享类型
 */
@property (nonatomic) SSPublishContentMediaType mediaType;

/**
 *	@brief	分享内容
 */
@property (nonatomic,copy) NSString *content;

/**
 *	@brief	默认分享内容
 */
@property (nonatomic,copy) NSString *defaultContent;

/**
 *	@brief	分享图片
 */
@property (nonatomic,retain) id<ISSCAttachment> image;

/**
 *	@brief	地理位置
 */
@property (nonatomic,retain) SSCLocationCoordinate2D *locationCoordinate;

/**
 *	@brief	分组标识
 */
@property (nonatomic,retain) NSString *groupId;

/**
 *  内容字典
 */
@property(nonatomic, strong) NSMutableDictionary *contentDic;


@end
