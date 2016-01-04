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

@interface YSModifyPasswordViewController () <YSNetworkManagerDelegate>

@property (nonatomic, copy) NSString *phoneNumber;

@property (nonatomic, weak) IBOutlet YSNavigationBarView *navigationBarView;
@property (nonatomic, weak) IBOutlet YSTextFieldTableView *textFieldTable;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;

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
    
    [self.navigationBarView setupWithTitle:@"重新设置密码" target:self action:@selector(modifyPasswordViewBack)];
    
    [self setupButton];
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

- (void)setupButton
{
    [self.submitButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitButton.backgroundColor = GreenBackgroundColor;
}

- (void)setupTextFieldTable
{
    UIView *firstLeftView = [self.textFieldTable getSecondTextFieldLeftView];
    UIView *firstRightView = [self.textFieldTable getPasswordTextFieldRightButtonView];
    NSString *firstPlaceholder = @"请输入旧密码";
    
    [self.textFieldTable setupFirstTextFieldWithPlaceholder:firstPlaceholder leftView:firstLeftView rightView:firstRightView];
    [self.textFieldTable setFirstTextFieldSecureTextEntry:YES];
    
    UIView *secondLeftView = [self.textFieldTable getSecondTextFieldLeftView];
    UIView *secondRightView = [self.textFieldTable getPasswordTextFieldRightButtonView];
    NSString *secondPlaceholder = @"请输入新密码";
    
    [self.textFieldTable setupSecondTextFieldWithPlaceholder:secondPlaceholder leftView:secondLeftView rightView:secondRightView];
    [self.textFieldTable setSecondTextFieldSecureTextEntry:YES];
}

- (IBAction)submit:(id)sender
{
    NSString *oldPassword = [self.textFieldTable firstText];
    NSString *newPassword = [self.textFieldTable secondText];
    
    if (([oldPassword length] < 1) || ([newPassword length] < 1))
    {
        NSString *type = ([oldPassword length] < 1) ? @"旧密码" : @"新密码";
        NSString *tip = [NSString stringWithFormat:@"%@不能为空", type];
        [self showTipLabelWithText:tip];
        return;
    }
    
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
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:^(){
        [self showTipLabelWithText:@"密码修改成功"];
    }];
}

- (void)modifyPasswordFailureWithMessage:(NSString *)message
{
    [self showTipLabelWithText:message];
}

@end
