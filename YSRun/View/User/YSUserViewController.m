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

@interface YSUserViewController ()

@property (nonatomic, weak) IBOutlet YSUserLevelView *userLevelView;
@property (nonatomic, weak) IBOutlet UIView *settingContentView;


@end

@implementation YSUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
//        YSUserSettingView *userSettingView = [[YSUserSettingView alloc] initWithFrame:frame];
        
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"YSUserNoLoginView" owner:self options:nil];
        YSUserNoLoginView *userSettingView = [nibViews objectAtIndex:0];
        userSettingView.frame = frame;
        
        [self.settingContentView addSubview:userSettingView];
    }
}

- (BOOL)hasLogin
{
    return YES;
}

@end
