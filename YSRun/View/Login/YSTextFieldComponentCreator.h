//
//  YSTextFieldComponentCreator.h
//  YSRun
//
//  Created by moshuqi on 16/1/4.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YSTextFieldComponentCreator : NSObject

+ (void)setupTextField:(UITextField *)textField height:(CGFloat)height;
+ (void)setupTextField:(UITextField *)textField withPlaceholder:(NSString *)placeholder;

+ (UIView *)getViewWithImage:(UIImage *)image textFieldHeight:(CGFloat)textFieldHeight;

+ (UIView *)getViewWithPasswordSecureButton:(UIButton *)button
                                buttonWidth:(CGFloat)buttonWidth
                            textFieldHeight:(CGFloat)textFieldHeight;

+ (UIView *)getViewWithCaptchaButton:(UIButton *)button
                         buttonWidth:(CGFloat)buttonWidth
                     textFieldHeight:(CGFloat)textFieldHeight;

+ (UIImage *)getAccountIconWithContentEmptyState:(BOOL)isEmpty;
+ (UIImage *)getPasswordIconWithContentEmptyState:(BOOL)isEmpty;

@end
