//
//  SSDKCredentialObject.h
//  ShareSDKInterfaceAdapter
//
//  Created by 刘靖煌 on 15/9/5.
//  Copyright (c) 2015年 mob.com. All rights reserved.
//

#import <ShareSDK/ShareSDK.h>
#import "ISSPlatformCredential.h"

@interface SSDKCredentialObject : SSDKCredential<ISSPlatformCredential>
{
    BOOL _available;
}

@property (nonatomic, strong) NSDictionary *extInfo;
@property (nonatomic, assign) BOOL available;

- (BOOL)available;
- (void)setAvailable:(BOOL)available;

- (SSDKCredentialObject* )getPlatformCredentialFromCredential:(SSDKCredential *)credential;
- (SSDKCredential *)getCredentialFromPlatformCredential:(id<ISSPlatformCredential>)credentialObj;

@end
