//
//  YSUserNoLoginView.m
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSUserNoLoginView.h"
#import "YSAppMacro.h"
#import "YSDevice.h"

#define UserNoLoginTableViewReuseIdentifier @"UserNoLoginTableViewReuseIdentifier"

@interface YSUserNoLoginView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UILabel *loginTipLabel;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *loginButtonHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@property (nonatomic, strong) NSArray *cellTypeArray;

@end

@implementation YSUserNoLoginView

- (void)awakeFromNib
{
    [self.tableView registerNib:[UINib nibWithNibName:@"YSUserSetCell" bundle:nil] forCellReuseIdentifier:UserNoLoginTableViewReuseIdentifier];
    self.tableView.scrollEnabled = NO;
    
    self.backgroundColor = RGB(245, 245, 245);
    
    self.loginTipLabel.textColor = RGB(136, 136, 136);
    self.loginTipLabel.backgroundColor = [UIColor clearColor];
    
    self.loginButton.backgroundColor = GreenBackgroundColor;
    self.loginButton.layer.cornerRadius = ButtonCornerRadius;
    self.loginButton.clipsToBounds = YES;
    
    if ([YSDevice isPhone6Plus])
    {
        self.loginButtonHeightConstraint.constant = 52;
        self.tableViewHeightConstraint.constant = 60;
    }
    
    [self setupCellTypeArray];
}

- (IBAction)loginButtonClicked:(id)sender
{
    [self.delegate login];
}

- (void)setupCellTypeArray
{
    // 未登录时，暂时只显示“设置”
    self.cellTypeArray = @[[NSNumber numberWithInteger:YSSettingsTypeSet]];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YSSettingsType cellType = (YSSettingsType)[self.cellTypeArray[indexPath.row] integerValue];
    [self.delegate userNoLoginViewDidSelectedType:cellType];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGRectGetHeight(self.tableView.frame) / [self.cellTypeArray count];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cellTypeArray count];
}

- (YSUserSetCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSUserSetCell *cell = [tableView dequeueReusableCellWithIdentifier:UserNoLoginTableViewReuseIdentifier forIndexPath:indexPath];
    YSSettingsType type = (YSSettingsType)[self.cellTypeArray[indexPath.row] integerValue];
    
    switch (type)
    {
        case YSSettingsTypeSet:
            [cell setupCellWithLeftText:@"设置"
                             centerText:nil
                              rightText:nil
                          textFieldText:nil
                          switchVisible:NO];
            break;
            
        default:
            break;
    }
    
    
    return cell;
}


@end
