//
//  YSContentCheckIconChange.m
//  YSRun
//
//  Created by moshuqi on 16/1/13.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSContentCheckIconChange.h"

@interface YSContentCheckIconChange ()

@property (nonatomic, weak) id<YSContentCheckIconChangeDelegate> delegate;

@end

@implementation YSContentCheckIconChange

- (id)initWithDelegate:(id<YSContentCheckIconChangeDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.delegate = delegate;
    }
    
    return self;
}

- (void)checkWithTextField:(UITextField *)textField beginText:(NSString *)beginText endText:(NSString *)endText
{
    BOOL endEmptyState = [endText length] < 1;
    BOOL beginEmptyState = [beginText length] < 1;
    
    if (endEmptyState != beginEmptyState)
    {
        // 开始和结束时，字符是否为空状态改变，则改变图标
        if ([self.delegate respondsToSelector:@selector(needChangeTextField:textEmpty:)])
        {
            BOOL bEmpty = [endText length] < 1;
            [self.delegate needChangeTextField:textField textEmpty:bEmpty];
        }
    }
}

@end
