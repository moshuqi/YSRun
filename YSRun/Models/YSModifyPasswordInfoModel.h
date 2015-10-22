//
//  YSModifyPasswordInfoModel.h
//  YSRun
//
//  Created by moshuqi on 15/10/22.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSModifyPasswordInfoModel : NSObject

@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *oldPassword;
@property (nonatomic, copy) NSString *modifiedPassword;

@end
