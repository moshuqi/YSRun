//
//  YSTextFieldTableView.m
//  YSRun
//
//  Created by moshuqi on 15/10/17.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSTextFieldTableView.h"
#import "YSAppMacro.h"

@interface YSTextFieldTableView ()

@property (nonatomic, weak) IBOutlet UITextField *firstTextField;
@property (nonatomic, weak) IBOutlet UITextField *secondTextField;
@property (nonatomic, weak) IBOutlet UIView *lineView;

@end

@implementation YSTextFieldTableView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSTextFieldTableView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        
        [self addSubview:containerView];
        
        [self setupSubviewsColor];
    }
    
    return self;
}

- (void)setupSubviewsColor
{
    UIColor *lineColor = RGB(215, 215, 215);
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = lineColor.CGColor;
    self.layer.cornerRadius = 5;
    
    self.lineView.backgroundColor = lineColor;
}

- (void)setupFirstTextFieldWithPlaceholder:(NSString *)placeholder
                                  leftView:(UIView *)leftView
                                 rightView:(UIView *)rightView
{
    [self.firstTextField setPlaceholder:placeholder];
    
    self.firstTextField.leftView = leftView;
    self.firstTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.firstTextField.rightView = rightView;
    self.firstTextField.rightViewMode = UITextFieldViewModeAlways;
}

- (void)setupSecondTextFieldWithPlaceholder:(NSString *)placeholder
                                   leftView:(UIView *)leftView
                                  rightView:(UIView *)rightView
{
    [self.secondTextField setPlaceholder:placeholder];
    
    self.secondTextField.leftView = leftView;
    self.secondTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.secondTextField.rightView = rightView;
    self.secondTextField.rightViewMode = UITextFieldViewModeAlways;
}

// 三个界面的leftView都一样，暂时写个统一的方法
- (UIView *)getFirstTextFieldLeftView
{
    UIImage *image = [UIImage imageNamed:@"login_user.png"];
    
    return [self getTextLeftViewWithImage:image];
}

- (UIView *)getSecondTextFieldLeftView
{
    UIImage *image = [UIImage imageNamed:@"login_password.png"];
    
    return [self getTextLeftViewWithImage:image];
}

- (UIView *)getTextLeftViewWithImage:(UIImage *)image
{
    CGFloat d = 10; // 图片和边缘的间距
    CGFloat textFieldHeight = CGRectGetHeight(self.frame) / 2;
    
    CGFloat imageHeight = textFieldHeight - 2 * d;
    CGFloat imageWidth = imageHeight;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageWidth + 2 * d, textFieldHeight)]; // 用来放UIImageView，以显示间距
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CGRect frame = CGRectMake(d, d, imageWidth, imageHeight);
    imageView.frame = frame;
    
    [contentView addSubview:imageView];
    return contentView;
}

- (UIView *)getCaptchaButtonView
{
    CGFloat textFieldHeight = CGRectGetHeight(self.frame) / 2;
    CGFloat d = 10; // 按钮距边缘的间距
    
    CGFloat buttonWidth = 86;
    CGFloat buttonHeight = textFieldHeight - 2 * d;
    CGRect buttonFrame = CGRectMake(d, d, buttonWidth, buttonHeight);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = buttonFrame;
    
    button.layer.borderWidth = 1;
    button.layer.borderColor = RGB(215, 215, 215).CGColor;
    button.layer.cornerRadius = 3;
    
    [button setTitleColor:RGB(136, 136, 136) forState:UIControlStateNormal];
    [button setTitle:@"发送验证码" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(captchaButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, buttonWidth + 2 * d, textFieldHeight)];
    [contentView addSubview:button];
    
    return contentView;
}

- (void)captchaButtonClicked:(id)sender
{
    // 发送手机短信验证码
    
    NSString *phoneNumber = self.firstTextField.text;
    [self.delegate sendCaptchaWithPhoneNumber:phoneNumber];
}

- (void)setFirstTextFieldDelegate:(id<UITextFieldDelegate>)delegate
{
    self.firstTextField.delegate = delegate;
}

- (NSString *)firstText
{
    return self.firstTextField.text;
}

- (NSString *)secondText
{
    return self.secondTextField.text;
}

@end
