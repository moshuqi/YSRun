//
//  YSEditingCheck.m
//  YSRun
//
//  Created by moshuqi on 16/1/13.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSEditingCheck.h"
#import <UIKit/UIKit.h>

@implementation YSEditingCheck

- (BOOL)checkTextField:(UITextField *)textField inRange:(NSRange)range replacementString:(NSString *)string
{
    // 子类重载
    return NO;
}

@end
