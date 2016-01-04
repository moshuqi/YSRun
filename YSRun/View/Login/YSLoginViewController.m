//
//  YSLoginViewController.m
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSLoginViewController.h"
#import "YSNavigationBarView.h"
#import "YSRegisterViewController.h"
#import "YSFindPasswordViewController.h"
#import "YSAppMacro.h"
#import "YSTextFieldTableView.h"
#import "YSNetworkManager.h"
#import "YSTipLabelHUD.h"
#import "YSShareFunc.h"
#import "YSThirdPartLoginFunc.h"
#import "YSLoadingHUD.h"

@interface YSLoginViewController () <YSNetworkManagerDelegate, YSThirdPartLoginFuncDelegate>

@property (nonatomic, weak) IBOutlet YSNavigationBarView *navigationBarView;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UIButton *registerButton;
@property (nonatomic, weak) IBOutlet UIButton *forgetPasswordButton;
@property (nonatomic, weak) IBOutlet UIButton *thirdPartLogin;  // 第三方登录
@property (nonatomic, weak) IBOutlet YSTextFieldTableView *textFieldTable;

@property (nonatomic, strong) YSNetworkManager *networkManager;
@property (nonatomic, strong) YSThirdPartLoginFunc *thirdPartLoginFunc;

@end

@implementation YSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationBarView setupWithTitle:@"登 录" target:self action:@selector(loginViewBack)];
    
    [self setupButtons];
    
    self.networkManager = [YSNetworkManager new];
    self.networkManager.delegate = self;
    
    self.loginButton.layer.cornerRadius = ButtonCornerRadius;
    self.loginButton.clipsToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupTextFieldTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setupButtons
{
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.backgroundColor = GreenBackgroundColor;
    
    [self.registerButton setTitle:@"快速注册" forState:UIControlStateNormal];
    [self.registerButton setTitleColor:GreenBackgroundColor forState:UIControlStateNormal];
    self.registerButton.backgroundColor = [UIColor clearColor];
    
    [self.thirdPartLogin setTitle:@"其他账号登录" forState:UIControlStateNormal];
    [self.thirdPartLogin setTitleColor:GreenBackgroundColor forState:UIControlStateNormal];
    self.thirdPartLogin.backgroundColor = [UIColor clearColor];
    
    // 是否安装有客户端，若无则不显示第三方登录按钮
    self.thirdPartLogin.hidden = ![YSShareFunc hasClientInstalled];
    
    [self.forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [self.forgetPasswordButton setTitleColor:RGB(136, 136, 136) forState:UIControlStateNormal];
    self.forgetPasswordButton.backgroundColor = [UIColor clearColor];
}

- (void)setupTextFieldTable
{
    UIView *firstLeftView = [self.textFieldTable getFirstTextFieldLeftView];
    NSString *firstPlaceholder = @"请输入用户名/手机号";
    [self.textFieldTable setupFirstTextFieldWithPlaceholder:firstPlaceholder leftView:firstLeftView rightView:nil];
    
    UIView *secondLeftView = [self.textFieldTable getSecondTextFieldLeftView];
    UIView *secondRightView = [self.textFieldTable getPasswordTextFieldRightButtonView];
    NSString *secondPlaceholder = @"请输入密码";
    [self.textFieldTable setupSecondTextFieldWithPlaceholder:secondPlaceholder leftView:secondLeftView rightView:secondRightView];
    [self.textFieldTable setSecondTextFieldSecureTextEntry:YES];
}

- (void)loginViewBack
{
    // 收起键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginButtonClicked:(id)sender
{
//    // 临时代码
//    [self.networkManager loginWithAccount:@"13417790407" password:@"a123456"];
//    [[YSLoadingHUD shareLoadingHUD] show];
//    return;
    
    NSString *account = [self.textFieldTable firstText];
    NSString *password = [self.textFieldTable secondText];
    
    if (([account length] < 1) || ([password length] < 1))
    {
        NSString *type = ([account length] < 1) ? @"用户名" : @"密码";
        NSString *tip = [NSString stringWithFormat:@"请输入%@", type];
        [[YSTipLabelHUD shareTipLabelHUD] showTipWithText:tip];
        return;
    }
    
    [self.networkManager loginWithAccount:account password:password];
    
    // 加载界面
    [[YSLoadingHUD shareLoadingHUD] show];
}

- (IBAction)registerButtonClicked:(id)sender
{
    YSRegisterViewController *registerViewController = [YSRegisterViewController new];
    [self.navigationController pushViewController:registerViewController animated:YES];
}

- (IBAction)forgetPasswordButtonClicked:(id)sender
{
    YSFindPasswordViewController *findPasswordViewController = [YSFindPasswordViewController new];
    [self.navigationController pushViewController:findPasswordViewController animated:YES];
}

- (IBAction)thirdPartLoginButtonClicked:(id)sender
{
    // 第三方登录的回调处理
//    ThirdPartLoginCallbackBlock callbackBlock = ^(YSShareFuncResponseState state, YSThirdPartLoginResponseModel *model)
//    {
//        if (state == YSShareFuncResponseStateSuccess)
//        {
//            // 第三方登录成功后
//            [self.networkManager thirdPartLoginWithThirdPartLoginResponseModel:model];
//        }
//    };
//    [YSShareFunc showLoginActionSheetFromViewController:self callbackBlock:callbackBlock];
    
    self.thirdPartLoginFunc = [YSThirdPartLoginFunc new];
    self.thirdPartLoginFunc.delegate = self;
    
    [self.thirdPartLoginFunc showActionSheet];
}

#pragma mark - YSNetworkManagerDelegate

- (void)loginSuccessWithUserInfoResponseModel:(YSUserInfoResponseModel *)userInfoResponseModel
{
    [[YSLoadingHUD shareLoadingHUD] dismiss];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [self.delegate loginViewController:self loginFinishWithUserInfoResponseModel:userInfoResponseModel];
}

- (void)loginFailure
{
    [[YSLoadingHUD shareLoadingHUD] dismiss];
    
    [[YSTipLabelHUD shareTipLabelHUD] showTipWithText:@"登录失败，请检查用户名密码是否正确"];
}

#pragma mark - YSThirdPartLoginResponseModel

- (void)thirdPartLoginSuccessWithResponseModel:(YSThirdPartLoginResponseModel *)respondeModel
{
    // 第三方登录成功返回到App，此时用第三方返回的数据向服务器请求，之后流程和正常登录一致。请求过程先显示加载界面
    [[YSLoadingHUD shareLoadingHUD] show];
    
    [self.networkManager thirdPartLoginWithThirdPartLoginResponseModel:respondeModel];
}

- (void)thirdPartLoginFailureWithMessage:(NSString *)message
{
    [[YSTipLabelHUD shareTipLabelHUD] showTipWithText:@"登录失败"];
}

@end
