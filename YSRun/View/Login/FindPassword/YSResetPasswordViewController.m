//
//  YSResetPasswordViewController.m
//  YSRun
//
//  Created by moshuqi on 15/10/30.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSResetPasswordViewController.h"
#import "YSNavigationBarView.h"
#import "YSAppMacro.h"
#import "YSNetworkManager.h"
#import "YSTipLabelHUD.h"
#import "YSLoginViewController.h"
#import "YSUtilsMacro.h"
#import "YSLoadingHUD.h"

@interface YSResetPasswordViewController () <YSNetworkManagerDelegate>

@property (nonatomic, weak) IBOutlet YSNavigationBarView *navigationBarView;
@property (nonatomic, weak) IBOutlet UITextField *textFiled;
@property (nonatomic, weak) IBOutlet UIButton *sumbitButton;

@property (nonatomic, strong) NSString *phoneNumber;

@end

@implementation YSResetPasswordViewController

- (id)initWithPhoneNumber:(NSString *)phoneNumber
{
    self = [super init];
    if (self)
    {
        self.phoneNumber = phoneNumber;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationBarView setupWithTitle:@"找回密码" target:self action:@selector(resetPasswordViewBack)];
    
    [self setupButton];
    [self setupTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setupButton
{
    [self.sumbitButton setTitle:@"提  交" forState:UIControlStateNormal];
    [self.sumbitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.sumbitButton.backgroundColor = GreenBackgroundColor;
    self.sumbitButton.layer.cornerRadius = ButtonCornerRadius;
    self.sumbitButton.clipsToBounds = YES;
}

- (void)setupTextField
{
    UIColor *lineColor = RGB(215, 215, 215);
    
    self.textFiled.layer.borderWidth = 1;
    self.textFiled.layer.borderColor = lineColor.CGColor;
    self.textFiled.layer.cornerRadius = 5;

    UIImage *image = [UIImage imageNamed:@"login_password"];
    UIView *leftView = [self getTextFieldLeftViewWithImage:image];
    UIView *rightView = [self getPasswordTextFieldRightButtonView];
    
    NSString *placeholder = [NSString stringWithFormat:@"请设置新密码"];
    [self.textFiled setPlaceholder:placeholder];
    self.textFiled.secureTextEntry = YES;
    
    self.textFiled.leftView = leftView;
    self.textFiled.leftViewMode = UITextFieldViewModeAlways;
    
    self.textFiled.rightView = rightView;
    self.textFiled.rightViewMode = UITextFieldViewModeAlways;
}

- (UIView *)getTextFieldLeftViewWithImage:(UIImage *)image
{
    CGFloat d = 10; // 图片和边缘的间距
    CGFloat textFieldHeight = CGRectGetHeight(self.textFiled.frame);
    
    CGFloat imageHeight = textFieldHeight - 2 * d;
    CGFloat imageWidth = imageHeight;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageWidth + 2 * d, textFieldHeight)]; // 用来放UIImageView，以显示间距
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CGRect frame = CGRectMake(d, d, imageWidth, imageHeight);
    imageView.frame = frame;
    
    [contentView addSubview:imageView];
    return contentView;
}

- (UIView *)getPasswordTextFieldRightButtonView
{
    UIImage *image = [UIImage imageNamed:@"password_eye_close"];
    
    CGFloat d = 0;
    CGFloat textFieldHeight = CGRectGetHeight(self.textFiled.frame);
    
    CGFloat buttonHeight = textFieldHeight - 2 * d;
    CGFloat buttonWidth = 56;
    CGRect buttonFrame = CGRectMake(d, d, buttonWidth, buttonHeight);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(passwordRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = buttonFrame;
    [button setImage:image forState:UIControlStateNormal];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, buttonWidth + 2 * d, textFieldHeight)];
    [contentView addSubview:button];
    
    return contentView;
}

- (void)passwordRightButtonClicked:(UIButton *)button
{
    BOOL secureTextEntry = self.textFiled.secureTextEntry;
    UIImage *image = secureTextEntry ? [UIImage imageNamed:@"password_eye_open"] : [UIImage imageNamed:@"password_eye_close"];
    [button setImage:image forState:UIControlStateNormal];
    
    self.textFiled.secureTextEntry = !secureTextEntry;
}

- (UITextField *)getTextFieldWithRightButton:(UIButton *)button
{
    // 获取button所在的textfield
    
    // button先加在一个view上，该view为textField的rightView，通过这种方法获得textField
    id object = [[button superview] superview];
    if ([object isKindOfClass:[UITextField class]])
    {
        return object;
    }
    
    return nil;
}


- (IBAction)submitButtonClicked:(id)sender
{
    NSString *newPassword = self.textFiled.text;
    
    if ([newPassword length] < 1)
    {
        NSString *tip = @"密码不能为空";
        [self showTipLabelWithText:tip];
        return;
    }
    
    [[YSLoadingHUD shareLoadingHUD] show];
    
    YSNetworkManager *networkManager = [YSNetworkManager new];
    networkManager.delegate = self;
    
    [networkManager resetPassword:newPassword phoneNumber:self.phoneNumber];
}

- (void)showTipLabelWithText:(NSString *)text
{
    [[YSTipLabelHUD shareTipLabelHUD] showTipWithText:text];
}

- (void)resetPasswordViewBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - YSNetworkManagerDelegate

- (void)resetPasswordSuccess
{
    // 重置密码成功后跳转到登录界面
    
    [[YSLoadingHUD shareLoadingHUD] dismiss];
    
    [[YSTipLabelHUD shareTipLabelHUD] showTipWithText:@"密码重置成功"];
    
    NSArray *viewControllers = [self.navigationController viewControllers];
    UIViewController *popToViewController = nil;
    
    for (UIViewController *viewController in viewControllers)
    {
        if ([viewController isKindOfClass:[YSLoginViewController class]])
        {
            popToViewController = viewController;
            break;
        }
    }
    
    [self.navigationController popToViewController:popToViewController animated:YES];
}

- (void)resetPasswordFailureWithMessage:(NSString *)message
{
    [[YSLoadingHUD shareLoadingHUD] dismiss];
    
    [[YSTipLabelHUD shareTipLabelHUD] showTipWithText:message];
}

@end
