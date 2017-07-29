//
//  YSTextFieldDelegateObj.h
//  YSRun
//
//  Created by moshuqi on 16/1/13.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class YSEditingCheck;
@class YSContentCheck;

@protocol YSTextFieldDelegateObjCallBack <NSObject>

@optional
- (void)textFieldDidReturn:(UITextField *)textField;

@end

@interface YSTextFieldDelegateObj : NSObject <UITextFieldDelegate>

@property (nonatomic, weak) id<YSTextFieldDelegateObjCallBack> delegate;

- (id)initWithEditingCheckArray:(NSArray<YSEditingCheck *> *)editingCheckArray
        contentCheckArray:(NSArray<YSContentCheck *> *)contentCheckArray;

@end
