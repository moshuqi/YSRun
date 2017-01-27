//
//  YSRegisterUserInfoViewController.m
//  YSRun
//
//  Created by moshuqi on 15/10/29.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSRegisterUserInfoViewController.h"
#import "YSNavigationBarView.h"
#import "YSTextFieldTableView.h"
#import "YSAppMacro.h"
#import "YSUtilsMacro.h"
#import "YSTipLabelHUD.h"
#import "YSNetworkManager.h"
#import "YSRegisterInfoRequestModel.h"
#import "YSPhotoPicker.h"
#import "YSUserDatabaseModel.h"
#import "YSDatabaseManager.h"
#import "YSLoginViewController.h"
#import "YSLoadingHUD.h"
#import "YSTextFieldComponentCreator.h"
#import "YSDevice.h"

#import "YSTextFieldDelegateObj.h"
#import "YSContentCheckIconChange.h"

@interface YSRegisterUserInfoViewController () <YSPhotoPickerDelegate, YSNetworkManagerDelegate, YSContentCheckIconChangeDelegate>

@property (nonatomic, weak) IBOutlet YSNavigationBarView *navigationBarView;
@property (nonatomic, weak) IBOutlet UIButton *photoButton;
@property (nonatomic, weak) IBOutlet UIButton *registerButton;

@property (nonatomic, strong) UIImage *photoImage;
@property (nonatomic, copy) NSString *account;

@property (nonatomic, strong) YSPhotoPicker *photoPicker;

@property (nonatomic, weak) IBOutlet UITextField *nicknameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *textFieldHeightConstraint;

@property (nonatomic, strong) YSTextFieldDelegateObj *nicknameTextFieldDelegateObj;
@property (nonatomic, strong) YSTextFieldDelegateObj *passwordTextFieldDelegateObj;

@end

@implementation YSRegisterUserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationBarView setupWithTitle:@"注 册" barBackgroundColor:[UIColor clearColor] target:self action:@selector(registerViewBack)];
    
    if ([YSDevice isPhone6Plus])
    {
        self.textFieldHeightConstraint.constant = 52;
    }
    
    [self setupButtons];
//    [self setupTextFieldTable];
    [self setupTextFields];
    [self setupBackgroundImage];
}

- (id)initWithAccount:(NSString *)account
{
    self = [super init];
    if (self)
    {
        self.account = account;
    }
    
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setupButtons
{
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
//    CGFloat btnHeight = self.textFieldHeightConstraint.constant;
    self.registerButton.layer.cornerRadius = ButtonCornerRadius;
    
    self.registerButton.backgroundColor = GreenBackgroundColor;
    self.registerButton.clipsToBounds = YES;
    
    CGFloat width = CGRectGetWidth(self.photoButton.frame);
    self.photoButton.layer.cornerRadius = width / 2;
    self.photoButton.clipsToBounds = YES;
}

- (void)setupBackgroundImage
{
    // 设置背景图片
    UIImage *image = [UIImage imageNamed:@"login_background"];
    self.view.layer.contents = (id)image.CGImage;
}

- (void)setupTextFields
{
    CGFloat textFieldHeight = self.textFieldHeightConstraint.constant;
    
    [YSTextFieldComponentCreator setupTextField:self.nicknameTextField height:textFieldHeight];
    [YSTextFieldComponentCreator setupTextField:self.passwordTextField height:textFieldHeight];
    
    // 设置文本框左边图标
    UIImage *accountImage = [YSTextFieldComponentCreator getAccountIconWithContentEmptyState:YES];
    UIImage *passwordImage = [YSTextFieldComponentCreator getPasswordIconWithContentEmptyState:YES];
    
    self.nicknameTextField.leftView = [YSTextFieldComponentCreator getViewWithImage:accountImage textFieldHeight:textFieldHeight];
    self.nicknameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.passwordTextField.leftView = [YSTextFieldComponentCreator getViewWithImage:passwordImage textFieldHeight:textFieldHeight];
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    // 占位符
    [YSTextFieldComponentCreator setupTextField:self.nicknameTextField withPlaceholder:@"请输入昵称"];
    [YSTextFieldComponentCreator setupTextField:self.passwordTextField withPlaceholder:@"请输入密码"];
    
    self.passwordTextField.secureTextEntry = YES;
    UIButton *secureTextButton = [self getSecureTextButton];
    self.passwordTextField.rightView = [YSTextFieldComponentCreator getViewWithPasswordSecureButton:secureTextButton buttonWidth:56 textFieldHeight:textFieldHeight];
    self.passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    
    [self setupTextFieldDelegate];
}

- (void)setupTextFieldDelegate
{
    // 给文本框设置代理，有输入字符时文本框左边图标改变
    
    YSContentCheckIconChange *contentCheck1 = [[YSContentCheckIconChange alloc] initWithDelegate:self];
    NSArray *contentCheckArray1 = @[contentCheck1];
    
    self.nicknameTextFieldDelegateObj = [[YSTextFieldDelegateObj alloc] initWithEditingCheckArray:nil contentCheckArray:contentCheckArray1];
    self.nicknameTextField.delegate = self.nicknameTextFieldDelegateObj;
    
    YSContentCheckIconChange *contentCheck2 = [[YSContentCheckIconChange alloc] initWithDelegate:self];
    NSArray *contentCheckArray2 = @[contentCheck2];
    
    self.passwordTextFieldDelegateObj = [[YSTextFieldDelegateObj alloc] initWithEditingCheckArray:nil contentCheckArray:contentCheckArray2];
    self.passwordTextField.delegate = self.passwordTextFieldDelegateObj;
}

- (UIButton *)getSecureTextButton
{
    UIButton *secureTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [secureTextButton addTarget:self action:@selector(secureTextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageNamed:@"password_eye_close"];
    [secureTextButton setImage:image forState:UIControlStateNormal];
    
    return secureTextButton;
}

- (void)secureTextButtonClicked:(UIButton *)button
{
    self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
    
    UIImage *image = self.passwordTextField.secureTextEntry ? [UIImage imageNamed:@"password_eye_close"] : [UIImage imageNamed:@"password_eye_open"];
    [button setImage:image forState:UIControlStateNormal];
}

- (void)registerViewBack
{
    [self.navigationController popViewControllerAnimated:YES];
    
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)photoButtonClicked:(id)sender
{
    [self showPhotoSourceChoice];
}

- (IBAction)registerButtonClicked:(id)sender
{
    [self userRegister];
}

- (void)userRegister
{
    NSString *nickName = self.nicknameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    // 检查输入不允许为空
    if (([nickName length] < 1) || ([password length] < 1))
    {
        NSString *type = ([nickName length] < 1) ? @"昵称" : @"密码";
        NSString *tip = [NSString stringWithFormat:@"请输入%@", type];
        [[YSTipLabelHUD shareTipLabelHUD] showTipWithText:tip];
        return;
    }
    
    YSRegisterInfoRequestModel *requestModel = [YSRegisterInfoRequestModel new];
    requestModel.nickname = nickName;
    requestModel.phone = self.account;
    requestModel.pwd = password;
    requestModel.photoData = UIImageJPEGRepresentation(self.photoImage, 1.0);
    
    YSNetworkManager *networkManager = [YSNetworkManager new];
    networkManager.delegate = self;
    [networkManager userRegister:requestModel];
    
    // 加载等待界面
    [[YSLoadingHUD shareLoadingHUD] show];
}


- (void)showPhotoSourceChoice
{
    self.photoPicker = [[YSPhotoPicker alloc] initWithViewController:self];
    self.photoPicker.delegate = self;
    
    [self.photoPicker showPickerChoice];
}


#pragma mark - YSPhotoPickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didSelectImage:(UIImage *)image
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.photoImage = image;
    [self.photoButton setImage:image forState:UIControlStateNormal];
}

#pragma mark - YSNetworkManagerDelegate

- (void)registerSuccessWithUid:(NSString *)uid
{
    // 注册成功之后用返回的uid向服务器请求用户数据并保存到本地。
    
    YSNetworkManager *networkManager = [YSNetworkManager new];
    networkManager.delegate = self;
    [networkManager getUserInfoWithUid:uid];
}

- (void)registerSuccessFailureWithMessage:(NSString *)message
{
    [[YSLoadingHUD shareLoadingHUD] dismiss];
    
    [[YSTipLabelHUD shareTipLabelHUD] showTipWithText:message];
}

- (void)getUserInfoSuccessWithModel:(YSUserDatabaseModel *)model
{
    // 注册成功之后用uid请求用户数据成功。
    
    [[YSLoadingHUD shareLoadingHUD] dismiss];
    
    // 通过这种方式来取LoginViewController了。
    NSArray *viewControllers = [self.navigationController viewControllers];
    YSLoginViewController *loginViewController = nil;
    
    for (UIViewController *viewController in viewControllers)
    {
        if ([viewController isKindOfClass:[YSLoginViewController class]])
        {
            loginViewController = (YSLoginViewController *)viewController;
            break;
        }
    }
    
    if (loginViewController)
    {
        [loginViewController.delegate loginViewController:loginViewController registerFinishWithResponseUserInfo:model];
    }
    else
    {
        YSLog(@"navigation栈里木有loginViewController！！");
    }
}

- (void)getUserInfoFailureWithMessage:(NSString *)message
{
    [[YSLoadingHUD shareLoadingHUD] dismiss];
    
    [[YSTipLabelHUD shareTipLabelHUD] showTipWithText:message];
}

#pragma mark - YSContentCheckIconChangeDelegate

- (void)needChangeTextField:(UITextField *)textField textEmpty:(BOOL)isEmpty
{
    CGFloat textFieldHeight = CGRectGetHeight(textField.frame);
    UIImage *image = nil;
    
    if (textField == self.nicknameTextField)
    {
        image = [YSTextFieldComponentCreator getAccountIconWithContentEmptyState:isEmpty];
    }
    else if (textField == self.passwordTextField)
    {
        image = [YSTextFieldComponentCreator getPasswordIconWithContentEmptyState:isEmpty];
    }
    
    textField.leftView = [YSTextFieldComponentCreator getViewWithImage:image textFieldHeight:textFieldHeight];
}

@end
