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

@interface YSUserViewController () <YSUserNoLoginViewDelegate, YSLoginViewControllerDelegate>

@property (nonatomic, weak) IBOutlet YSUserLevelView *userLevelView;
@property (nonatomic, weak) IBOutlet UIView *settingContentView;

@property (nonatomic, strong) YSUserSettingView *userSettingView;
@property (nonatomic, strong) YSUserNoLoginView *userNoLoginView;

@end

@implementation YSUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupContentView
{
    // 根据当前是否已登录来决定显示对应的视图
    
    CGRect frame = self.settingContentView.bounds;
    
    if ([self hasLogin])
    {
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"YSUserSettingView" owner:self options:nil];
        self.userSettingView = [nibViews objectAtIndex:0];
        self.userSettingView.frame = frame;
        
        [self.settingContentView addSubview:self.userSettingView];
    }
    else
    {
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"YSUserNoLoginView" owner:self options:nil];
        self.userNoLoginView = [nibViews objectAtIndex:0];
        self.userNoLoginView.frame = frame;
        self.userNoLoginView.delegate = self;
        
        [self.settingContentView addSubview:self.userNoLoginView];
    }
}

- (BOOL)hasLogin
{
    return NO;
}

- (void)enterLoginView
{
    YSLoginViewController *loginViewController = [YSLoginViewController new];
    loginViewController.delegate = self;
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (void)setupWithUserModel:(YSUserModel *)userModel
{
    
}

#pragma mark - YSUserNoLoginViewDelegate

- (void)login
{
    [self enterLoginView];
}

#pragma mark - YSLoginViewControllerDelegate

- (void)loginViewController:(YSLoginViewController *)loginViewController loginFinishWithUserModel:(YSUserModel *)userModel
{
    [self setupWithUserModel:userModel];
    
    [loginViewController.navigationController popToRootViewControllerAnimated:YES];
}

@end
