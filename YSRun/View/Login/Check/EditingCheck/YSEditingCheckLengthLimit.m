//
//  YSEditingCheckLengthLimit.m
//  YSRun
//
//  Created by moshuqi on 16/1/13.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSEditingCheckLengthLimit.h"
#import <UIKit/UIKit.h>

@interface YSEditingCheckLengthLimit ()

@property (nonatomic, assign) NSInteger maxLimit;
@property (nonatomic, weak) id<YSEditingCheckLengthLimitDelegate> delegate;

@end

@implementation YSEditingCheckLengthLimit

- (id)initWithMaxLimit:(NSInteger)maxLimit
              delegate:(id<YSEditingCheckLengthLimitDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.maxLimit = maxLimit;
        self.delegate = delegate;
    }
    
    return self;
}

- (BOOL)checkTextField:(UITextField *)textField inRange:(NSRange)range replacementString:(NSString *)string
{
    // 输入的字符长度不能超过最大限定值
    BOOL lengthWithinLimit = YES;
    
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    
    if (existedLength - selectedLength + replaceLength > self.maxLimit)
    {
        lengthWithinLimit = NO;
    }
    
    if (lengthWithinLimit == NO)
    {
        // 输入长度超过最大值
        if ([self.delegate respondsToSelector:@selector(beyondMaxLimit)])
        {
            [self.delegate beyondMaxLimit];
        }
    }
    
    return lengthWithinLimit;
}

@end
