//
//  YSEditingCheck.h
//  YSRun
//
//  Created by moshuqi on 16/1/13.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UITextField;

@interface YSEditingCheck : NSObject

- (BOOL)checkTextField:(UITextField *)textField inRange:(NSRange)range replacementString:(NSString *)string;

@end
