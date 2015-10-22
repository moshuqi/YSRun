//
//  YSFindPasswordViewController.m
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSFindPasswordViewController.h"
#import "YSNavigationBarView.h"
#import "YSTextFieldTableView.h"
#import "YSAppMacro.h"
#import "YSPhoneTextFieldLimitDelegate.h"
#import "YSTipLabelHUD.h"

@interface YSFindPasswordViewController () <YSPhoneTextFieldLimitDelegateCallback, YSTextFieldTableViewDelegate>

@property (nonatomic, weak) IBOutlet YSNavigationBarView *navigationBarView;
@property (nonatomic, weak) IBOutlet YSTextFieldTableView *textFieldTable;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;
@property (nonatomic, strong) YSPhoneTextFieldLimitDelegate *phoneTextFieldDelegate;

@end

@implementation YSFindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationBarView setupWithTitle:@"找回密码" target:self action:@selector(findPasswordViewBack)];
    
    [self setupButton];
    [self setupTextFieldTable];
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

- (void)findPasswordViewBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
    NSString *tipText = @"手机号不正确";
    if (isValid)
    {
        tipText = @"验证码已发送至手机短信";
    }
    
    [[YSTipLabelHUD shareTipLabelHUD] showTipWithText:tipText];
}

- (BOOL)checkPhoneNumberValid:(NSString *)phoneNumber
{
    NSInteger length = [phoneNumber length];
    NSInteger requireLength = 11;
    return (length == requireLength);
}

@end
