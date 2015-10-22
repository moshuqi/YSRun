//
//  YSPhoneTextFieldLimitDelegate.h
//  YSRun
//
//  Created by moshuqi on 15/10/22.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol YSPhoneTextFieldLimitDelegateCallback <NSObject>

- (void)phoneLengthMoreThanLimit;

@end

@interface YSPhoneTextFieldLimitDelegate : NSObject <UITextFieldDelegate>

@property (nonatomic, weak) id<YSPhoneTextFieldLimitDelegateCallback> delegate;

@end
