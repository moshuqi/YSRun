//
//  YSTextFieldDelegateObj.m
//  YSRun
//
//  Created by moshuqi on 16/1/13.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSTextFieldDelegateObj.h"
#import "YSEditingCheck.h"
#import "YSContentCheck.h"

@interface YSTextFieldDelegateObj ()

@property (nonatomic, copy) NSString *beginText;
@property (nonatomic, copy) NSString *endText;

@property (nonatomic, copy) NSArray<YSEditingCheck *> *editingCheckArray;
@property (nonatomic, copy) NSArray<YSContentCheck *> *contentCheckArray;

@end

@implementation YSTextFieldDelegateObj

- (id)initWithEditingCheckArray:(NSArray<YSEditingCheck *> *)editingCheckArray
              contentCheckArray:(NSArray<YSContentCheck *> *)contentCheckArray
{
    self = [super init];
    if (self)
    {
        self.editingCheckArray = editingCheckArray;
        self.contentCheckArray = contentCheckArray;
    }
    
    return self;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.editingCheckArray count] > 0)
    {
        for (YSEditingCheck *check in self.editingCheckArray)
        {
            BOOL checkResult = [check checkTextField:textField inRange:range replacementString:string];
            if (checkResult == NO)
            {
                return NO;
            }
        }
    }
    
    // 输入内容检查放在确定能输入之后
    if ([self.contentCheckArray count] > 0)
    {
        NSString *beginText = textField.text;
        NSMutableString *endText = [NSMutableString stringWithString:beginText];
        [endText replaceCharactersInRange:range withString:string];
        
        for (YSContentCheck *contentCheck in self.contentCheckArray)
        {
            [contentCheck checkWithTextField:textField beginText:beginText endText:endText];
        }
    }
    
    return YES;
}


@end
