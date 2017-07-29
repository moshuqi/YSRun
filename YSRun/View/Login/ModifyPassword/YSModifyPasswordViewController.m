//
//  YSModifyPasswordViewController.m
//  YSRun
//
//  Created by moshuqi on 15/10/30.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSModifyPasswordViewController.h"
#import "YSNavigationBarView.h"
#import "YSTextFieldTableView.h"
#import "YSAppMacro.h"
#import "YSTipLabelHUD.h"
#import "YSNetworkManager.h"
#import "YSTextFieldComponentCreator.h"
#import "YSLoadingHUD.h"
#import "YSDevice.h"

#import "YSTextFieldDelegateObj.h"
#import "YSContentCheckIconChange.h"

@interface YSModifyPasswordViewController () <YSNetworkManagerDelegate, YSContentCheckIconChangeDelegate, YSTextFieldDelegateObjCallBack>

@property (nonatomic, copy) NSString *phoneNumber;

@property (nonatomic, weak) IBOutlet YSNavigationBarView *navigationBarView;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;

@property (nonatomic, weak) IBOutlet UITextField *oldPasswordTextField;
@property (nonatomic, weak) IBOutlet UITextField *modifyPasswordTextField;

// 第一个文本框的高度约束，第二个文本框和按钮的高度都是根据这个来决定
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *textFieldHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *firstTextFieldTopToBarViewBottomConstraint;

// 显示密码的按钮
@property (nonatomic, strong) UIButton *oldPswTextFieldSecureTextBtn;
@property (nonatomic, strong) UIButton *modifyPswTextFieldSecureTextBtn;

@property (nonatomic, strong) YSTextFieldDelegateObj *oldPasswordTextFieldDelegateObj;
@property (nonatomic, strong) YSTextFieldDelegateObj *modifyPasswordTextFieldDelegateObj;

@end

@implementation YSModifyPasswordViewController

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
    
    [self.navigationBarView setupWithTitle:@"修改密码" barBackgroundColor:[UIColor clearColor] target:self action:@selector(modifyPasswordViewBack)];
    
    // 在此处改变constant并不会导致对应控件的高度立即变化，所以setup方法中需要控件高度的地方直接取constant的值
    self.firstTextFieldTopToBarViewBottomConstraint.constant = [self constraintConstant];
    if ([YSDevice isPhone6Plus])
    {
        self.textFieldHeightConstraint.constant = 52;
    }
    
    [self setupButton];
    [self setupTextFields];
    [self setupBackgroundImage];
    [self addBackgroundTapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)addBackgroundTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground:)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapBackground:(id)tapGesture
{
    // 点击背景处时收起键盘。
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)setupButton
{
//    CGFloat btnHeight = self.textFieldHeightConstraint.constant;
    self.submitButton.layer.cornerRadius = ButtonCornerRadius;
    
    [self.submitButton setTitle:@"确认" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitButton.backgroundColor = GreenBackgroundColor;
}

- (void)setupTextFields
{
    CGFloat textFieldHeight = CGRectGetHeight(self.oldPasswordTextField.frame);
    
    [YSTextFieldComponentCreator setupTextField:self.oldPasswordTextField height:textFieldHeight];
    [YSTextFieldComponentCreator setupTextField:self.modifyPasswordTextField height:textFieldHeight];
    
    // 设置文本框左边图标
    UIImage *image = [YSTextFieldComponentCreator getPasswordIconWithContentEmptyState:YES];
    
    self.oldPasswordTextField.leftView = [YSTextFieldComponentCreator getViewWithImage:image textFieldHeight:textFieldHeight];
    self.oldPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.modifyPasswordTextField.leftView = [YSTextFieldComponentCreator getViewWithImage:image textFieldHeight:textFieldHeight];
    self.modifyPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    // 占位符
    [YSTextFieldComponentCreator setupTextField:self.oldPasswordTextField withPlaceholder:@"请输入旧密码"];
    [YSTextFieldComponentCreator setupTextField:self.modifyPasswordTextField withPlaceholder:@"请输入新密码"];
    
    self.oldPasswordTextField.secureTextEntry = YES;
    self.modifyPasswordTextField.secureTextEntry = YES;
    
    // 右边显示明文密码的按钮
    self.oldPswTextFieldSecureTextBtn = [self getSecureTextButton];
    self.modifyPswTextFieldSecureTextBtn = [self getSecureTextButton];
    
    // 设置文本框右边图标
    self.oldPasswordTextField.rightView = [YSTextFieldComponentCreator getViewWithPasswordSecureButton:self.oldPswTextFieldSecureTextBtn buttonWidth:56 textFieldHeight:textFieldHeight];
    self.oldPasswordTextField.rightViewMode = UITextFieldViewModeAlways;
    
    self.modifyPasswordTextField.rightView = [YSTextFieldComponentCreator getViewWithPasswordSecureButton:self.modifyPswTextFieldSecureTextBtn buttonWidth:56 textFieldHeight:textFieldHeight];
    self.modifyPasswordTextField.rightViewMode = UITextFieldViewModeAlways;
    
    self.oldPasswordTextField.returnKeyType = UIReturnKeyNext;
    self.modifyPasswordTextField.returnKeyType = UIReturnKeyDone;
    
    self.oldPasswordTextField.enablesReturnKeyAutomatically = YES;
    self.modifyPasswordTextField.enablesReturnKeyAutomatically = YES;
    
    [self setupTextFieldDelegate];
}

- (void)setupTextFieldDelegate
{
    // 给文本框设置代理，有输入字符时文本框左边图标改变
    
    YSContentCheckIconChange *contentCheck1 = [[YSContentCheckIconChange alloc] initWithDelegate:self];
    NSArray *contentCheckArray1 = @[contentCheck1];
    
    self.oldPasswordTextFieldDelegateObj = [[YSTextFieldDelegateObj alloc] initWithEditingCheckArray:nil contentCheckArray:contentCheckArray1];
    self.oldPasswordTextField.delegate = self.oldPasswordTextFieldDelegateObj;
    
    YSContentCheckIconChange *contentCheck2 = [[YSContentCheckIconChange alloc] initWithDelegate:self];
    NSArray *contentCheckArray2 = @[contentCheck2];
    
    self.modifyPasswordTextFieldDelegateObj = [[YSTextFieldDelegateObj alloc] initWithEditingCheckArray:nil contentCheckArray:contentCheckArray2];
    self.modifyPasswordTextField.delegate = self.modifyPasswordTextFieldDelegateObj;
    
    self.oldPasswordTextFieldDelegateObj.delegate = self;
    self.modifyPasswordTextFieldDelegateObj.delegate = self;
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
    UITextField *textField = nil;
    if (button == self.oldPswTextFieldSecureTextBtn)
    {
        // 旧密码
        textField = self.oldPasswordTextField;
    }
    else if (button == self.modifyPswTextFieldSecureTextBtn)
    {
        // 新密码
        textField = self.modifyPasswordTextField;
    }
    
    if (textField)
    {
        textField.secureTextEntry = !textField.secureTextEntry;
        
        UIImage *image = textField.secureTextEntry ? [UIImage imageNamed:@"password_eye_close"] : [UIImage imageNamed:@"password_eye_open"];
        [button setImage:image forState:UIControlStateNormal];
    }
}

- (void)setupBackgroundImage
{
    // 设置背景图片
    UIImage *image = [UIImage imageNamed:@"login_background"];
    self.view.layer.contents = (id)image.CGImage;
}

- (CGFloat)constraintConstant
{
    // 根据实际情况计算的constant值，既第一个文本框与导航栏的距离
    
    CGFloat distance = 5;   // 控件间的间距
    CGFloat height = self.textFieldHeightConstraint.constant;   // 控件的高度，文本框和按钮的高度相同
    CGFloat barViewHeight = CGRectGetHeight(self.navigationBarView.frame);
    
    CGFloat screenHeight = [UIApplication sharedApplication].keyWindow.frame.size.height;
    // 按钮距底边的间距为第一个文本框距导航栏的间距的2倍
    CGFloat constant = (screenHeight - barViewHeight - height * 3 - distance * 2) / 3;
    
    return constant;
}

- (IBAction)submit:(id)sender
{
    [self modifyPassword];
}

- (void)modifyPassword
{
    NSString *oldPassword = self.oldPasswordTextField.text;
    NSString *newPassword = self.modifyPasswordTextField.text;
    
    if (([oldPassword length] < 1) || ([newPassword length] < 1))
    {
        NSString *type = ([oldPassword length] < 1) ? @"旧密码" : @"新密码";
        NSString *tip = [NSString stringWithFormat:@"%@不能为空", type];
        [self showTipLabelWithText:tip];
        return;
    }
    
    [[YSLoadingHUD shareLoadingHUD] show];
    
    YSNetworkManager *networkManager = [YSNetworkManager new];
    networkManager.delegate = self;
    
    [networkManager modifyPasswordWithPhoneNumber:self.phoneNumber oldPassword:oldPassword newPassword:newPassword];
}

- (void)showTipLabelWithText:(NSString *)text
{
    [[YSTipLabelHUD shareTipLabelHUD] showTipWithText:text];
}

- (void)modifyPasswordViewBack
{
    if (self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - YSNetworkManagerDelegate

- (void)modifyPasswordSuccess
{
    [[YSLoadingHUD shareLoadingHUD] dismiss];
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:^(){
        [self showTipLabelWithText:@"密码修改成功"];
    }];
}

- (void)modifyPasswordFailureWithMessage:(NSString *)message
{
    [[YSLoadingHUD shareLoadingHUD] dismiss];
    
    [self showTipLabelWithText:message];
}

#pragma mark - YSContentCheckIconChangeDelegate

- (void)needChangeTextField:(UITextField *)textField textEmpty:(BOOL)isEmpty
{
    CGFloat textFieldHeight = CGRectGetHeight(textField.frame);
    textField.leftView = [YSTextFieldComponentCreator getViewWithImage:[YSTextFieldComponentCreator getPasswordIconWithContentEmptyState:isEmpty] textFieldHeight:textFieldHeight];
}

#pragma mark - YSTextFieldDelegateObjCallBack

- (void)textFieldDidReturn:(UITextField *)textField
{
    if (textField == self.oldPasswordTextField)
    {
        [self.modifyPasswordTextField becomeFirstResponder];
    }
    else if (textField == self.modifyPasswordTextField)
    {
        [self modifyPassword];
    }
}

@end
