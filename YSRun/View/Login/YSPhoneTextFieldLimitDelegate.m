//
//  YSPhoneTextFieldLimitDelegate.m
//  YSRun
//
//  Created by moshuqi on 15/10/22.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSPhoneTextFieldLimitDelegate.h"

#define NUMBERS @"0123456789\n"

@implementation YSPhoneTextFieldLimitDelegate

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 电话号码输入必须为数字
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    BOOL isNumber = [string isEqualToString:filtered];
    
    // 电话号码长度限制
    
    NSInteger lengthLimit = 11; // 手机号码为11位
    BOOL lengthWithinLimit = YES;
    
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > lengthLimit)
    {
        lengthWithinLimit = NO;
    }
    
    if (!lengthWithinLimit)
    {
        // 超过长度界面提示
        [self.delegate phoneLengthMoreThanLimit];
    }
    
    BOOL canChange = isNumber && lengthWithinLimit;
    return canChange;
}

@end
