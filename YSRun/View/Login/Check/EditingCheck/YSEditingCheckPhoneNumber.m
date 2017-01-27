//
//  YSEditingCheckPhoneNumber.m
//  YSRun
//
//  Created by moshuqi on 16/1/13.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSEditingCheckPhoneNumber.h"
#import <UIKit/UIKit.h>

#define NUMBERS @"0123456789\n"

@implementation YSEditingCheckPhoneNumber

- (BOOL)checkTextField:(UITextField *)textField inRange:(NSRange)range replacementString:(NSString *)string
{
    // 电话号码输入必须为数字
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    BOOL isNumber = [string isEqualToString:filtered];
    
    return isNumber;
}

@end
