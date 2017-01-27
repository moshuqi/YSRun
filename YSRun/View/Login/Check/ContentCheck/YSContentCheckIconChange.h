//
//  YSContentCheckIconChange.h
//  YSRun
//
//  Created by moshuqi on 16/1/13.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSContentCheck.h"

@protocol YSContentCheckIconChangeDelegate <NSObject>

@optional
- (void)needChangeTextField:(UITextField *)textField textEmpty:(BOOL)isEmpty;

@end

@interface YSContentCheckIconChange : YSContentCheck

- (id)initWithDelegate:(id<YSContentCheckIconChangeDelegate>)delegate;

@end
