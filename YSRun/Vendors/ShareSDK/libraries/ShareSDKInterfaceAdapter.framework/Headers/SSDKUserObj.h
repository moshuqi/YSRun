//
//  SSDKUserObj.h
//  ShareSDKInterfaceAdapter
//
//  Created by 刘靖煌 on 15/9/5.
//  Copyright (c) 2015年 mob.com. All rights reserved.
//

#import <ShareSDK/ShareSDK.h>
#import "ISSPlatformUser.h"
#import <ShareSDK/SSDKUser.h>

@interface SSDKUserObj : NSObject<ISSPlatformUser>

/**
 *  平台类型
 */
@property (nonatomic, assign) ShareType type;

/**
 *  授权凭证， 为nil则表示尚未授权
 */
@property (nonatomic, retain) SSDKCredential *credential;

/**
 *  用户标识
 */
@property (nonatomic, copy) NSString *uid;

/**
 *  昵称
 */
@property (nonatomic, copy) NSString *nickname;

/**
 *  头像
 */
@property (nonatomic, copy) NSString *profileImage;

/**
 *  性别
 */
@property (nonatomic, assign) NSInteger gender;

/**
 *  用户主页
 */
@property (nonatomic, copy) NSString *url;

/**
 *  用户简介
 */
@property (nonatomic, copy) NSString *aboutMe;

/**
 *  认证用户类型
 */
@property (nonatomic) NSInteger verifyType;

/**
 *  认证描述
 */
@property (nonatomic, copy) NSString *verifyReason;

/**
 *  生日
 */
@property (nonatomic, copy) NSString *birthday;

/**
 *  粉丝数
 */
@property (nonatomic) NSInteger followerCount;

/**
 *  好友数
 */
@property (nonatomic) NSInteger friendCount;

/**
 *  分享数
 */
@property (nonatomic) NSInteger shareCount;

/**
 *  注册时间
 */
@property (nonatomic) NSTimeInterval regAt;

/**
 *  用户等级
 */
@property (nonatomic) NSInteger level;

/**
 *  教育信息
 */
@property (nonatomic, retain) NSArray *educations;

/**
 *  职业信息
 */
@property (nonatomic, retain) NSArray *works;

/**
 *  原始数据
 */
@property (nonatomic, strong) NSDictionary *sourceData;


- (SSDKUserObj *)getPlatformUserFromUserObj:(SSDKUser *)user;

- (SSDKUser *)getUserObjFromPlatformUser:(id<ISSPlatformUser>)userObj;


@end
