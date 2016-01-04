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

@interface YSRegisterUserInfoViewController () <YSPhotoPickerDelegate, YSNetworkManagerDelegate>

@property (nonatomic, weak) IBOutlet YSNavigationBarView *navigationBarView;
@property (nonatomic, weak) IBOutlet YSTextFieldTableView *textFieldTable;
@property (nonatomic, weak) IBOutlet UIButton *photoButton;
@property (nonatomic, weak) IBOutlet UIButton *registerButton;

@property (nonatomic, strong) UIImage *photoImage;
@property (nonatomic, copy) NSString *account;

@property (nonatomic, strong) YSPhotoPicker *photoPicker;

@end

@implementation YSRegisterUserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationBarView setupWithTitle:@"注 册" target:self action:@selector(registerViewBack)];
    
    [self setupButtons];
    [self setupTextFieldTable];
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
    [self.registerButton setTitle:@"注 册" forState:UIControlStateNormal];
    [self.registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.registerButton.backgroundColor = GreenBackgroundColor;
    self.registerButton.layer.cornerRadius = ButtonCornerRadius;
    self.registerButton.clipsToBounds = YES;
    
    CGFloat width = CGRectGetWidth(self.photoButton.frame);
    self.photoButton.layer.cornerRadius = width / 2;
    self.photoButton.clipsToBounds = YES;
}

- (void)setupTextFieldTable
{
    UIView *firstLeftView = [self.textFieldTable getFirstTextFieldLeftView];
    NSString *firstPlaceholder = @"请输入昵称";
    [self.textFieldTable setupFirstTextFieldWithPlaceholder:firstPlaceholder leftView:firstLeftView rightView:nil];
    
    UIView *secondLeftView = [self.textFieldTable getSecondTextFieldLeftView];
    UIView *secondRightView = [self.textFieldTable getPasswordTextFieldRightButtonView];
    NSString *secondPlaceholder = @"请输入密码";
    
    [self.textFieldTable setupSecondTextFieldWithPlaceholder:secondPlaceholder leftView:secondLeftView rightView:secondRightView];
    [self.textFieldTable setSecondTextFieldSecureTextEntry:YES];
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
    NSString *nickName = [self.textFieldTable firstText];
    NSString *password = [self.textFieldTable secondText];
    
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

@end
