//
//  SSLocationCoordinate2D.m
//  ShareSDKCoreService
//
//  Created by 冯 鸿杰 on 13-8-29.
//  Copyright (c) 2013年 掌淘科技. All rights reserved.
//

#import <Foundation/Foundation.h>

///#begin zh-cn
/**
 *	@brief	地理位置信息
 */
///#end
///#begin en
/**
 *	@brief	Location information
 */
///#end
@interface SSCLocationCoordinate2D : NSObject

///#begin zh-cn
/**
 *	@brief	纬度
 */
///#end
///#begin en
/**
 *	@brief	Latitude.
 */
///#end
@property (nonatomic) double latitude;

///#begin zh-cn
/**
 *	@brief	经度
 */
///#end
///#begin en
/**
 *	@brief	Longitude.
 */
///#end
@property (nonatomic) double longitude;

///#begin zh-cn
/**
 *	@brief	地理位置信息
 *
 *	@param 	latitude 	纬度
 *	@param 	longitude 	经度
 *
 *	@return	地理位置信息
 */
///#end
///#begin en
/**
 *	@brief	Location information.
 *
 *	@param 	latitude 	Latitude
 *	@param 	longitude 	Longitude
 *
 *	@return	Location information.
 */
///#end
+ (SSCLocationCoordinate2D *)locationCoordinate2DWithLatitude:(double)latitude
                                                    longitude:(double)longitude;


@end
