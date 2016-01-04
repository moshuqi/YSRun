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
#import "YSCaptchaTimer.h"
#import "YSRegisterUserInfoViewController.h"
#import "YSLoadingHUD.h"

@interface YSRegisterViewController () <YSPhoneTextFieldLimitDelegateCallback, YSTextFieldTableViewDelegate, YSNetworkManagerDelegate>

@property (nonatomic, weak) IBOutlet YSNavigationBarView *navigationBarView;
@property (nonatomic, weak) IBOutlet YSTextFieldTableView *textFieldTable;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;

@property (nonatomic, strong) YSPhoneTextFieldLimitDelegate *phoneTextFieldDelegate;
@property (nonatomic, strong) YSNetworkManager *networkManager;

@property (nonatomic, copy) NSString *account;  // 注册手机

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self resetCaptchaButtonState];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setupButton
{
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextButton.backgroundColor = GreenBackgroundColor;
    
    self.nextButton.layer.cornerRadius = ButtonCornerRadius;
    self.nextButton.clipsToBounds = YES;
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
    
    [[YSLoadingHUD shareLoadingHUD] show];
    
    [self.networkManager checkCaptcha:captcha phoneNumber:phoneNumber];
}

- (void)showTipLabelWithText:(NSString *)text
{
    [[YSTipLabelHUD shareTipLabelHUD] showTipWithText:text];
}

- (void)resetCaptchaButtonState
{
    // 根据单例里保存的数据来设置发送验证码按钮的状态
    
    YSCaptchaTimer *captchaTimer = [YSCaptchaTimer shareCaptchaTimer];
    
    if ([captchaTimer isCountdownState])
    {
        [self setCaptchaButtonDisabled];
        
        CallbackBlock block = [self getCaptchaTimerCallBackBlock];
        [captchaTimer setCallbackWithBlock:block];
    }
}

- (void)sendCaptchaSuccess
{
    // 发送验证码按钮置灰，倒计时完成后才能点击。
    
    [[YSCaptchaTimer shareCaptchaTimer] startWithBlock:[self getCaptchaTimerCallBackBlock]];
    
    [self setCaptchaButtonDisabled];
}

- (void)setCaptchaButtonDisabled
{
    UIButton *captchaButton = [self.textFieldTable getButton];
    captchaButton.enabled = NO;
    captchaButton.backgroundColor = RGB(215, 215, 215);
}

- (CallbackBlock)getCaptchaTimerCallBackBlock
{
    CallbackBlock block = ^(NSInteger remainTime, BOOL finished)
    {
        UIButton *captchaButton = [self.textFieldTable getButton];
        if (finished)
        {
            captchaButton.enabled = YES;
            captchaButton.backgroundColor = [UIColor whiteColor];
        }
        else
        {
            NSString *text = [NSString stringWithFormat:@"发送验证码(%@)", @(remainTime)];
            
            // 需同时设置，，并且保证captchaButton.titleLabel.text在setTitle:forState:之前，否则按钮的字在NSTimer调用时会闪。
            captchaButton.titleLabel.text = text;
            [captchaButton setTitle:text forState:UIControlStateDisabled];
        }
    };
    
    return block;
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
        
        [self sendCaptchaSuccess];
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

- (void)acquireCaptchaSuccess
{
    [self showTipLabelWithText:@"验证码已发送至手机短信"];
}

- (void)checkCaptchaSuccessWithPhoneNumber:(NSString *)phoneNumber
{
    // 验证成功，页面跳转
    
    [[YSLoadingHUD shareLoadingHUD] dismiss];
    
    YSRegisterUserInfoViewController *registerUserInfoViewController = [[YSRegisterUserInfoViewController alloc] initWithAccount:phoneNumber];
    [self.navigationController pushViewController:registerUserInfoViewController animated:YES];
}

- (void)checkCaptchaFailureWithMessage:(NSString *)message
{
    [[YSLoadingHUD shareLoadingHUD] dismiss];
    
    [self showTipLabelWithText:message];
}

@end
