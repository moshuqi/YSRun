//
//  YSTextFieldTableView.h
//  YSRun
//
//  Created by moshuqi on 15/10/17.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSTextFieldTableView : UIView

- (void)setupFirstTextFieldWithPlaceholder:(NSString *)placeholder
                                  leftView:(UIView *)leftView
                                 rightView:(UIView *)rightView;
- (void)setupSecondTextFieldWithPlaceholder:(NSString *)placeholder
                                  leftView:(UIView *)leftView
                                 rightView:(UIView *)rightView;

- (UIView *)getFirstTextFieldLeftView;
- (UIView *)getSecondTextFieldLeftView;
- (UIView *)getCaptchaButtonView;

@end
