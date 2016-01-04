//
//  SSUserField.h
//  ShareSDK
//
//  Created by 冯 鸿杰 on 13-5-14.
//  Copyright (c) 2013年 掌淘科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISSUserField.h"

/**
 *	@brief	用户字段
 */
@interface SSUserField : NSObject <ISSUserField>

/**
 *	@brief	字段值
 */
@property (nonatomic,copy) NSString *value;

/**
 *	@brief	字段类型
 */
@property (nonatomic) SSUserFieldType type;

@end
