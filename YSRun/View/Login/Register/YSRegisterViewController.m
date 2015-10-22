//
//  YSRegisterViewController.m
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSRegisterViewController.h"
#import "YSNavigationBarView.h"
#import "YSTextFieldTableView.h"
#import "YSAppMacro.h"
#import "YSPhoneTextFieldLimitDelegate.h"
#import "YSTipLabelHUD.h"
#import "YSNetworkManager.h"

@interface YSRegisterViewController () <YSPhoneTextFieldLimitDelegateCallback, YSTextFieldTableViewDelegate, YSNetworkManagerDelegate>

@property (nonatomic, weak) IBOutlet YSNavigationBarView *navigationBarView;
@property (nonatomic, weak) IBOutlet YSTextFieldTableView *textFieldTable;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;

@property (nonatomic, strong) YSPhoneTextFieldLimitDelegate *phoneTextFieldDelegate;
@property (nonatomic, strong) YSNetworkManager *networkManager;

@end

@implementation YSRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationBarView setupWithTitle:@"注 册" target:self action:@selector(registerViewBack)];
    
    [self setupButton];
    [self setupTextFieldTable];
    
    self.networkManager = [YSNetworkManager new];
    self.networkManager.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupButton
{
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextButton.backgroundColor = GreenBackgroundColor;
}

- (void)setupTextFieldTable
{
    UIView *firstLeftView = [self.textFieldTable getFirstTextFieldLeftView];
    NSString *firstPlaceholder = @"请输入手机号";
    [self.textFieldTable setupFirstTextFieldWithPlaceholder:firstPlaceholder leftView:firstLeftView rightView:[self.textFieldTable getCaptchaButtonView]];
    
    UIView *secondLeftView = [self.textFieldTable getSecondTextFieldLeftView];
    NSString *secondPlaceholder = @"请输入验证码";
    [self.textFieldTable setupSecondTextFieldWithPlaceholder:secondPlaceholder leftView:secondLeftView rightView:nil];
    
    self.phoneTextFieldDelegate = [YSPhoneTextFieldLimitDelegate new];
    self.phoneTextFieldDelegate.delegate = self;
    [self.textFieldTable setFirstTextFieldDelegate:self.phoneTextFieldDelegate];
    
    self.textFieldTable.delegate = self;
}


- (void)registerViewBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextStep:(id)sender
{
    NSString *phoneNumber = [self.textFieldTable firstText];
    NSString *captcha = [self.textFieldTable secondText];
    
    // 保证两个文本框的输入不为空。
    if (([phoneNumber length] < 1) || ([captcha length] < 1))
    {
        NSString *type = ([phoneNumber length] < 1) ? @"手机号" : @"验证码";
        NSString *tip = [NSString stringWithFormat:@"%@不能为空", type];
        [self showTipLabelWithText:tip];
        return;
    }
    
    [self.networkManager checkCaptcha:captcha phoneNumber:phoneNumber];
}

- (void)showTipLabelWithText:(NSString *)text
{
    [[YSTipLabelHUD shareTipLabelHUD] showTipWithText:text];
}

#pragma mark - YSPhoneTextFieldLimitDelegateCallback

- (void)phoneLengthMoreThanLimit
{
    [[YSTipLabelHUD shareTipLabelHUD] showTipWithText:@"长度超过限制"];
}

#pragma mark - YSTextFieldTableViewDelegate

- (void)sendCaptchaWithPhoneNumber:(NSString *)phoneNumber
{
    BOOL isValid = [self checkPhoneNumberValid:phoneNumber];
    if (isValid)
    {
        [self.networkManager acquireCaptchaWithPhoneNumber:phoneNumber];
    }
    else
    {
        NSString *tipText = @"手机号不正确";
        if ([phoneNumber length] < 1)
        {
            tipText = @"手机号不能为空";
        }
        [[YSTipLabelHUD shareTipLabelHUD] showTipWithText:tipText];
    }
}

- (BOOL)checkPhoneNumberValid:(NSString *)phoneNumber
{
    NSInteger length = [phoneNumber length];
    NSInteger requireLength = 11;
    return (length == requireLength);
}

#pragma mark - YSNetworkManagerDelegate

- (void)showAcquireCaptchaResultTip:(NSString *)tip
{
    [self showTipLabelWithText:tip];
}

- (void)checkCaptchaSuccess
{
    // 验证成功，页面跳转
}

- (void)checkCaptchaFailureWithMessage:(NSString *)message
{
    [self showTipLabelWithText:message];
}

@end
