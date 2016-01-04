//
//  YSThirdPartLoginFunc.h
//  YSRun
//
//  Created by moshuqi on 15/12/10.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YSThirdPartLoginResponseModel;

@protocol YSThirdPartLoginFuncDelegate <NSObject>

@required
- (void)thirdPartLoginSuccessWithResponseModel:(YSThirdPartLoginResponseModel *)respondeModel;
- (void)thirdPartLoginFailureWithMessage:(NSString *)message;

@end

@interface YSThirdPartLoginFunc : NSObject

@property (nonatomic, weak) id<YSThirdPartLoginFuncDelegate> delegate;

- (void)showActionSheet;

@end
