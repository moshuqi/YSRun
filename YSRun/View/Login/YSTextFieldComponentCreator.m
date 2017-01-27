//
//  YSTextFieldComponentCreator.m
//  YSRun
//
//  Created by moshuqi on 16/1/4.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSTextFieldComponentCreator.h"
#import "YSAppMacro.h"

@implementation YSTextFieldComponentCreator

+ (UIView *)getViewWithImage:(UIImage *)image textFieldHeight:(CGFloat)textFieldHeight
{
    // 根据图片和文本框高度，创建视图作为textField的leftView或rightView
    
    CGFloat imageHeight = 20;
    CGFloat imageWidth = 22;
    
//    CGFloat offset = textFieldHeight / 2;   // 文本框圆角为高度的一半
    CGFloat offset = 15;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageWidth + offset, textFieldHeight)]; // 用来放UIImageView，以显示间距
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CGRect frame = CGRectMake(offset, (textFieldHeight - imageHeight) / 2, imageWidth, imageHeight);
    imageView.frame = frame;
    
    [contentView addSubview:imageView];
    return contentView;
}

+ (UIView *)getViewWithPasswordSecureButton:(UIButton *)button
                                buttonWidth:(CGFloat)buttonWidth
                            textFieldHeight:(CGFloat)textFieldHeight
{
    // 文本框显示隐藏密码按钮的视图
    
    CGFloat d = 0;
    CGFloat buttonHeight = textFieldHeight - 2 * d;
    
    CGRect buttonFrame = CGRectMake(d, d, buttonWidth, buttonHeight);
    button.frame = buttonFrame;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, buttonWidth + 2 * d, textFieldHeight)];
    [contentView addSubview:button];
    
    return contentView;
}

+ (UIView *)getViewWithCaptchaButton:(UIButton *)button
                         buttonWidth:(CGFloat)buttonWidth
                     textFieldHeight:(CGFloat)textFieldHeight
{
    // 发送短信验证码按钮视图

    // 右边加上圆角的间距
    CGFloat offset = textFieldHeight / 2;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, buttonWidth + offset, textFieldHeight)];
    
    // 加上按钮
    CGFloat buttonHeight = 32;
    CGRect buttonFrame = CGRectMake((CGRectGetWidth(contentView.frame) - buttonWidth) / 2,
                                    (CGRectGetHeight(contentView.frame) - buttonHeight) / 2,
                                    buttonWidth, buttonHeight);
    
    button.frame = buttonFrame;
    [button setTitle:@"发送验证码" forState:UIControlStateNormal];
    
    [button setTitleColor:GreenBackgroundColor forState:UIControlStateNormal];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [contentView addSubview:button];
    
    // 左边的分割线
    CGFloat lineWidth = 1;
    CGFloat lineHeight = 20;
    CGRect lineFrame = CGRectMake(0, (CGRectGetHeight(contentView.frame) - lineHeight) / 2,
                                  lineWidth, lineHeight);
    
    UIView *line = [[UIView alloc] initWithFrame:lineFrame];
    line.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    
    [contentView addSubview:line];
    [contentView bringSubviewToFront:line];
    
    return contentView;
}

+ (void)setupTextField:(UITextField *)textField height:(CGFloat)height
{
    // 文本框基本外观设置
    
    // 设置圆角
    textField.layer.cornerRadius = 5;
    
//    textField.backgroundColor = [UIColor clearColor];
    
    // 设置白色边框
//    textField.layer.borderColor = [[UIColor whiteColor] CGColor];
//    textField.layer.borderWidth = 1.0f;
    
    // 光标和字体颜色
//    textField.tintColor = [UIColor whiteColor];
//    textField.textColor = [UIColor whiteColor];
}

+ (void)setupTextField:(UITextField *)textField withPlaceholder:(NSString *)placeholder
{
    // 设置文本框占位符及其颜色
    
//    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    textField.placeholder = placeholder;
}


// 根据文本框是否有内容显示对应的图标，既leftview里的图片
+ (UIImage *)getAccountIconWithContentEmptyState:(BOOL)isEmpty
{
    UIImage *image = nil;
    
    if (isEmpty)
    {
        image = [UIImage imageNamed:@"login_user"];
    }
    else
    {
        image = [UIImage imageNamed:@"login_user_has_content"];
    }
    
    return image;
}

+ (UIImage *)getPasswordIconWithContentEmptyState:(BOOL)isEmpty
{
    UIImage *image = nil;
    
    if (isEmpty)
    {
        image = [UIImage imageNamed:@"login_password"];
    }
    else
    {
        image = [UIImage imageNamed:@"login_password_has_content"];
    }
    
    return image;
}

@end
