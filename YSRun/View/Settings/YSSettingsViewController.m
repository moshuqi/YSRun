//
//  YSSettingsViewController.m
//  YSRun
//
//  Created by moshuqi on 15/12/7.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSSettingsViewController.h"
#import "YSNavigationBarView.h"
#import "YSSettingsTypeDefine.h"
#import "YSDataManager.h"
#import "YSUserSetCell.h"
#import "YSAppMacro.h"
#import "YSConfigManager.h"
#import "YSVoiceSettingsViewController.h"
#import "YSModifyPasswordViewController.h"
#import "UMFeedback.h"
#import "YSDevice.h"

#define SettingsTableViewReuseIdentifier @"SettingsTableViewReuseIdentifier"

@interface YSSettingsViewController () <UITableViewDataSource, UITableViewDelegate, YSUserSetCellDelegate>

@property (nonatomic, weak) IBOutlet YSNavigationBarView *navigationBarView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *settingsTypeSections;

@end

@implementation YSSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupSettingsTypeArray];
    [self setupTableView];
    
    [self.navigationBarView setupWithTitle:@"设 置" target:self action:@selector(settingsViewBack)];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 声音提示改变之后，通过这里刷新一下来改变对应的标签。
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)settingsViewBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupSettingsTypeArray
{
    // 未登录时：1、心率面板、语音提示；2、意见反馈
    // 登录时：1、心率面板、语音提示；2、修改密码（非第三方登录）、意见反馈；3、退出登录
    NSMutableArray *sectionArray = [NSMutableArray array];
    NSArray *section0 = @[[NSNumber numberWithInteger:YSSettingsTypeHeartRatePanel],
                          [NSNumber numberWithInteger:YSSettingsTypeVoicePrompt]];
    [sectionArray addObject:section0];
    
    YSDataManager *dataManager = [YSDataManager shareDataManager];
    if ([dataManager isLogin])
    {
        NSArray *section1 = nil;
        if ([dataManager isThirdPartLogin])
        {
            // 第三方登录的用户不提供修改密码
            section1 = @[[NSNumber numberWithInteger:YSSettingsTypeFeedback]];
        }
        else
        {
            section1 = @[[NSNumber numberWithInteger:YSSettingsTypeModifyPassword],
                         [NSNumber numberWithInteger:YSSettingsTypeFeedback]];
        }
        [sectionArray addObject:section1];
        
        // 退出登录
        NSArray *section2 = @[[NSNumber numberWithInteger:YSSettingsTypeLogout]];
        [sectionArray addObject:section2];
    }
    else
    {
        NSArray *section1 = @[[NSNumber numberWithInteger:YSSettingsTypeFeedback]];
        [sectionArray addObject:section1];
    }
    
    self.settingsTypeSections = [NSArray arrayWithArray:sectionArray];
}

- (void)setupTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"YSUserSetCell" bundle:nil] forCellReuseIdentifier:SettingsTableViewReuseIdentifier];
    
    self.tableView.backgroundColor = LightgrayBackgroundColor;
    self.tableView.scrollEnabled = NO;
}

- (NSString *)getCellTextWithSettingsType:(YSSettingsType)type
{
    NSString *text = nil;
    switch (type)
    {
        case YSSettingsTypeHeartRatePanel:
            text = @"心率面板";
            break;
            
        case YSSettingsTypeVoicePrompt:
            text = @"语音提示";
            break;
            
        case YSSettingsTypeModifyPassword:
            text = @"修改密码";
            break;
            
        case YSSettingsTypeFeedback:
            text = @"用户反馈";
            break;
            
        case YSSettingsTypeLogout:
            text = @"退出登录";
            break;
            
        case YSSettingsTypeMeasure:
            text = @"单位";
            break;
            
        case YSSettingsTypeNickname:
            text = @"我的昵称";
            break;
            
        default:
            break;
    }
    
    return text;
}

- (void)setupCell:(YSUserSetCell *)cell bySettingsType:(YSSettingsType)type
{
    NSString *leftText = [self getCellTextWithSettingsType:type];
    switch (type) {
        case YSSettingsTypeHeartRatePanel:
            [cell setupCellWithLeftText:leftText
                             centerText:nil
                              rightText:nil
                          textFieldText:nil
                          switchVisible:YES];
            [cell setSwitchOn:![YSConfigManager heartRatePanelHidden]];
            break;
            
        case YSSettingsTypeVoicePrompt:
            [cell setupCellWithLeftText:leftText
                             centerText:nil
                              rightText:[self voiceTypeString]
                          textFieldText:nil
                          switchVisible:NO];
            break;
            
        case YSSettingsTypeModifyPassword:
        case YSSettingsTypeFeedback:
        case YSSettingsTypeLogout:
            [cell setupCellWithLeftText:leftText
                             centerText:nil
                              rightText:nil
                          textFieldText:nil
                          switchVisible:NO];
            break;
            
        default:
            break;
    }
}

- (NSString *)voiceTypeString
{
    YSVoicePromptType type = [YSConfigManager voicePromptType];
    NSString *string = [YSConfigManager getVoiceTypeNameStringWithType:type];
    
    return string;
}

- (void)showVoiceSettingsView
{
    YSVoiceSettingsViewController *voiceSettingsViewController = [YSVoiceSettingsViewController new];
    [self.navigationController pushViewController:voiceSettingsViewController animated:YES];
}

- (void)showModifyPasswordView
{
    // 修改密码
    NSString *phoneNumber = [[YSDataManager shareDataManager] getUserPhone];
    
    YSModifyPasswordViewController *modifyPasswordViewController = [[YSModifyPasswordViewController alloc] initWithPhoneNumber:phoneNumber];
    
    [self.navigationController pushViewController:modifyPasswordViewController animated:YES];
}

- (void)showFeedbackView
{
    // 用户反馈
    UIViewController *feedbackViewController = [UMFeedback feedbackModalViewController];
    feedbackViewController.navigationController.navigationBarHidden = NO;
    
    [self.navigationController pushViewController:feedbackViewController animated:YES];
}

- (void)userLogout
{
    // 用户退出
    [self.delegate settingsViewDidSelectedLogout];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.settingsTypeSections[section];
    return [array count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.settingsTypeSections count];
}

- (YSUserSetCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSUserSetCell *cell = [tableView dequeueReusableCellWithIdentifier:SettingsTableViewReuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    
    NSArray *array = self.settingsTypeSections[indexPath.section];
    YSSettingsType type = (YSSettingsType)[array[indexPath.row] integerValue];
    
    [self setupCell:cell bySettingsType:type];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = self.settingsTypeSections[indexPath.section];
    YSSettingsType cellType = (YSSettingsType)[array[indexPath.row] integerValue];
    
    // 单位和心率cell点击时没有反应
    if (cellType == YSSettingsTypeHeartRatePanel)
    {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *array = self.settingsTypeSections[indexPath.section];
    YSSettingsType cellType = (YSSettingsType)[array[indexPath.row] integerValue];
    
    if (cellType == YSSettingsTypeVoicePrompt)
    {
        // 语音提示
        [self showVoiceSettingsView];
    }
    else if (cellType == YSSettingsTypeModifyPassword)
    {
        // 修改密码
        [self showModifyPasswordView];
    }
    else if (cellType == YSSettingsTypeFeedback)
    {
        // 用户反馈
        [self showFeedbackView];
    }
    else if (cellType == YSSettingsTypeLogout)
    {
        // 退出登录
        [self userLogout];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44;
    if ([YSDevice isPhone6Plus])
    {
        height = 60;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    CGFloat sectionHeight = 10;
//    if (section == ([self.settingsTypeSections count] - 1))
//    {
//        sectionHeight = 0;
//    }
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [UIView new];
    footerView.backgroundColor = LightgrayBackgroundColor;
    
    return footerView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = LightgrayBackgroundColor;
    
    return view;
}

#pragma mark - YSUserSetCellDelegate

- (void)textFieldTextChange:(NSString *)text
{
//    [self.delegate modifyNickame:text];
}

- (void)switchStateChanged:(UISwitch *)switchControl
{
    [YSConfigManager setHeartRatePanelHidden:!switchControl.on];
}

@end
