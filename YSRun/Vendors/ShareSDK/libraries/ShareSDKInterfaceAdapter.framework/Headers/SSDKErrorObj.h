//
//  SSDKErrorObj.h
//  ShareSDKInterfaceAdapter
//
//  Created by 刘靖煌 on 15/9/24.
//  Copyright © 2015年 mob.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICMErrorInfo.h"

@interface SSDKErrorObj : NSError<ICMErrorInfo>

@property(nonatomic, assign) NSInteger errorCode;
@property(nonatomic, copy) NSString *errorDescription;
@property(nonatomic, assign) CMErrorLevel errorLevel;

-(SSDKErrorObj *)getErrorObjFromNSError:(NSError *)error;

@end
