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

@interface YSTextFieldDelegateObj : NSObject <UITextFieldDelegate>

- (id)initWithEditingCheckArray:(NSArray<YSEditingCheck *> *)editingCheckArray
        contentCheckArray:(NSArray<YSContentCheck *> *)contentCheckArray;

@end
