//
//  YSUserViewController.m
//  YSRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSUserViewController.h"
#import "YSUserLevelView.h"
#import "YSUserSettingView.h"
#import "YSUserNoLoginView.h"
#import "YSLoginViewController.h"
#import "YSDataManager.h"
#import "YSUserInfoModel.h"
#import "YSUserInfoResponseModel.h"
#import "YSDatabaseManager.h"
#import "YSNetworkManager.h"
#import "YSRunDatabaseModel.h"
#import "YSUtilsMacro.h"
#import "YSModifyPasswordViewController.h"
#import "YSPhotoPicker.h"
#import "YSUserDatabaseModel.h"
#import "YSModelReformer.h"
#import "YSSetUserRequestModel.h"
#import "YSRunDataHandler.h"
#import "YSSettingsViewController.h"
#import "YSShareFunc.h"
#import "YSUserDataHandler.h"

@interface YSUserViewController () <YSUserNoLoginViewDelegate, YSLoginViewControllerDelegate, YSNetworkManagerDelegate, YSUserSettingViewDelegate, YSUserLevelViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, YSPhotoPickerDelegate, YSRunDataHandlerDelegate, YSSettingsViewControllerDelegate, YSUserDataHandlerDelegate>

@property (nonatomic, weak) IBOutlet YSUserLevelView *userLevelView;
@property (nonatomic, weak) IBOutlet UIView *settingContentView;

@property (nonatomic, strong) YSUserSettingView *userSettingView;
@property (nonatomic, strong) YSUserNoLoginView *userNoLoginView;

@property (nonatomic, strong) YSPhotoPicker *photoPicker;
@property (nonatomic, strong) YSRunDataHandler *runDataHandler;
@property (nonatomic, strong) YSUserDataHandler *userDataHandler;

@end

@implementation YSUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = YES;
    [self setupContentView];
    
    self.userLevelView.delegate = self;
    
    self.runDataHandler = [YSRunDataHandler new];
    self.runDataHandler.delegate = self;
    
    self.userDataHandler = [YSUserDataHandler new];
    self.userDataHandler.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 显示用户界面时设置用户数据
    [self setupUserLevel];
    [self changeViewWithLoginState:[self hasLogin]];
    
    [self.userSettingView reloadTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self resizeContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setupContentView
{
    // 用户登录显示的界面
    NSArray *nibViews1 = [[NSBundle mainBundle] loadNibNamed:@"YSUserSettingView" owner:self options:nil];
    self.userSettingView = [nibViews1 objectAtIndex:0];
    self.userSettingView.delegate = self;
    
    [self.settingContentView addSubview:self.userSettingView];
    
    // 用户未登录时显示的界面
    NSArray *nibViews2 = [[NSBundle mainBundle] loadNibNamed:@"YSUserNoLoginView" owner:self options:nil];
    self.userNoLoginView = [nibViews2 objectAtIndex:0];
    self.userNoLoginView.delegate = self;
    
    [self.settingContentView addSubview:self.userNoLoginView];
}

- (void)resizeContentView
{
    CGRect frame = self.settingContentView.bounds;
    
    self.userSettingView.frame = frame;
    self.userNoLoginView.frame = frame;
}

- (void)resetUserLevel
{
    [[YSDataManager shareDataManager] resetData];
    [self setupUserLevel];
}

- (void)setupUserLevel
{
    // 放子线程执行了，否则开启APP时有可能会在这卡死。 2016.01.29
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        YSUserInfoModel *userInfo = [[YSDataManager shareDataManager] getUserInfo];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self.userLevelView setUserName:userInfo.nickname
                                  headPhoto:userInfo.headImage
                                      grade:userInfo.grade
                               achieveTitle:userInfo.achieveTitle
                                   progress:userInfo.progress
                        upgradeRequireTimes:userInfo.upgradeRequireTimes];
        });
    });
}

- (BOOL)hasLogin
{
    return [[YSDataManager shareDataManager] isLogin];
}

- (void)enterLoginView
{
    YSLoginViewController *loginViewController = [YSLoginViewController new];
    loginViewController.delegate = self;
//    [self.navigationController pushViewController:loginViewController animated:YES];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    loginViewController.navigationController.navigationBarHidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)changeViewWithLoginState:(BOOL)isLogin
{
    if (isLogin)
    {
        [self.settingContentView bringSubviewToFront:self.userSettingView];
    }
    else
    {
        [self.settingContentView bringSubviewToFront:self.userNoLoginView];
    }
}

- (void)showPhotoSourceChoice
{
    self.photoPicker = [[YSPhotoPicker alloc] initWithViewController:self];
    self.photoPicker.delegate = self;
    
    [self.photoPicker showPickerChoice];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 接受点击事件，当在编辑用户昵称时，点击其他地方退出编辑转台收起键盘
    [super touchesBegan:touches withEvent:event];
    
    if ([self hasLogin])
    {
        // 登录情况下才能编辑用户昵称
        [self.view endEditing:YES];
    }
}

- (void)logout
{
    // 用户注销时，删除数据库用户数据，和用户所对应的跑步数据。
    YSDataManager *manager = [YSDataManager shareDataManager];
    
    YSDatabaseManager *databaseManager = [YSDatabaseManager new];
    [databaseManager deleteUserAndRelatedRunDataWithUid:[manager getUid]];
    
    // 数据库更新后重置数据。
    [self resetUserLevel];
    [self changeViewWithLoginState:NO];
    
    // 退出登录后取消第三方的授权
    [YSShareFunc cancelAuthorized];
    
    // 用户退出时日历界面的跑步数据需要刷新一次
    [self.delegate userViewUserStateChanged];
}

- (void)modifyPassword
{
    // 修改密码
    NSString *phoneNumber = [[YSDataManager shareDataManager] getUserPhone];
    
    YSModifyPasswordViewController *modifyPasswordViewController = [[YSModifyPasswordViewController alloc] initWithPhoneNumber:phoneNumber];
    
    [self presentViewController:modifyPasswordViewController animated:YES completion:nil];
}

- (void)showSettingsView
{
    // 跳转到设置界面
    YSSettingsViewController *settingViewController = [YSSettingsViewController new];
    settingViewController.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - YSUserNoLoginViewDelegate

- (void)login
{
    [self enterLoginView];
}

- (void)userNoLoginViewDidSelectedType:(YSSettingsType)type
{
    switch (type) {
        case YSSettingsTypeSet:
            [self showSettingsView];
            break;
            
        default:
            break;
    }
}

#pragma mark - YSLoginViewControllerDelegate

- (void)loginViewController:(YSLoginViewController *)loginViewController loginFinishWithUserInfoResponseModel:(YSUserInfoResponseModel *)userInfoResponseModel
{
    // 用户登录成功
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        [self.runDataHandler loginSuccessWithUserInfoResponseModel:userInfoResponseModel];
    });
    
    [loginViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginViewController:(YSLoginViewController *)loginViewController registerFinishWithResponseUserInfo:(YSUserDatabaseModel *)userInfo
{
    // 用户注册成功，请求并返回用户信息，将用户保存到本地数据库，并上传未登录时的跑步数据。
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        [self.runDataHandler registerSuccessWithResponseUserInfo:userInfo];
    });
    
    [loginViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - YSNetworkManagerDelegate

// 设置信息
- (void)setInfoSuccess
{
    
}

- (void)setInfoFailureWithMessage:(NSString *)message
{
    YSLog(@"%@", message);
}

#pragma mark - YSRunDataHandlerDelegate

- (void)runDataHandleFinish
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self setupUserLevel];
        [self changeViewWithLoginState:[self hasLogin]];
        
        // 登录成功后刷新一下，否则昵称会因为时机上的问题仍然显示“未登录”
        if ([self hasLogin])
        {
            [self.userSettingView reloadTableView];
        }
        
        // 用户登录注册成功之后，跑步数据处理完成之后的回调，此时刷新一下日历界面的跑步数据，保证日历正确显示数据
        [self.delegate userViewUserStateChanged];
    });
}

#pragma mark - YSUserDataHandlerDelegate

- (void)uploadHeadImageFinish
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        YSUserInfoModel *userInfo = [[YSDataManager shareDataManager] getUserInfo];
        [self.userLevelView setHeadPhoto:userInfo.headImage];
    });
}

#pragma mark - YSUserSettingViewDelegate

- (void)userSettingViewDidSelectedType:(YSSettingsType)type
{
    switch (type) {
        case YSSettingsTypeSet:
            [self showSettingsView];
            break;
            
        default:
            break;
    }
}

- (void)modifyNickame:(NSString *)nickname
{
    // 修改用户昵称
    NSString *uid = [[YSDataManager shareDataManager] getUid];
    
    // 修改本地数据库数据
    YSDatabaseManager *databaseManager = [YSDatabaseManager new];
    [databaseManager setUser:uid withNickname:nickname];
    
    // 修改服务器数据
    YSSetUserRequestModel *setUserRequestModel = [YSSetUserRequestModel new];
    setUserRequestModel.uid = uid;
    setUserRequestModel.nickname = nickname;
    
    YSNetworkManager *networkManager = [YSNetworkManager new];
    networkManager.delegate = self;
    [networkManager setUserWithRequestModel:setUserRequestModel];
    
    [self resetUserLevel];
}

#pragma mark - YSUserLevelViewDelegate

- (void)headPhotoChange
{
    [self showPhotoSourceChoice];
}

- (void)toLogin
{
    [self login];
}

- (BOOL)loginState
{
    return [self hasLogin];
}

#pragma mark - YSPhotoPickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didSelectImage:(UIImage *)image
{
//    YSNetworkManager *networkManager = [YSNetworkManager new];
//    networkManager.delegate = self;
//    
//    NSString *uid = [[YSDataManager shareDataManager] getUid];
//    [networkManager uploadHeadImage:image uid:uid];
    
    if (image)
    {
        [self.userDataHandler uploadHeadImage:image];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - YSSettingsViewControllerDelegate

- (void)settingsViewDidSelectedLogout
{
    [self logout];
}

@end
