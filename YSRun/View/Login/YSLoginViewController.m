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

@interface YSLoginViewController ()

@property (nonatomic, weak) IBOutlet YSNavigationBarView *navigationBarView;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UIButton *registerButton;
@property (nonatomic, weak) IBOutlet UIButton *forgetPasswordButton;
@property (nonatomic, weak) IBOutlet YSTextFieldTableView *textFieldTable;

@end

@implementation YSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationBarView setupWithTitle:@"登 录" target:self action:@selector(loginViewBack)];
    
    [self setupButtons];
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

- (void)setupButtons
{
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.backgroundColor = GreenBackgroundColor;
    
    [self.registerButton setTitle:@"快速注册" forState:UIControlStateNormal];
    [self.registerButton setTitleColor:GreenBackgroundColor forState:UIControlStateNormal];
    self.registerButton.backgroundColor = [UIColor clearColor];
    
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
    NSString *secondPlaceholder = @"请输入密码";
    [self.textFieldTable setupSecondTextFieldWithPlaceholder:secondPlaceholder leftView:secondLeftView rightView:nil];
}

- (void)loginViewBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)loginButtonClicked:(id)sender
{
    
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






@end
