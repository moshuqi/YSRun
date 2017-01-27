//
//  YSEditingCheckLengthLimit.h
//  YSRun
//
//  Created by moshuqi on 16/1/13.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSEditingCheck.h"

@protocol YSEditingCheckLengthLimitDelegate <NSObject>

@optional
- (void)beyondMaxLimit;

@end

@interface YSEditingCheckLengthLimit : YSEditingCheck

- (id)initWithMaxLimit:(NSInteger)maxLimit
              delegate:(id<YSEditingCheckLengthLimitDelegate>)delegate;

@end
