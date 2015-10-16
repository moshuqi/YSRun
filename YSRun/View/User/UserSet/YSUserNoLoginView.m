//
//  YSUserNoLoginView.m
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSUserNoLoginView.h"
#import "YSUserSetCell.h"
#import "YSAppMacro.h"

#define UserNoLoginTableViewReuseIdentifier @"UserNoLoginTableViewReuseIdentifier"

@interface YSUserNoLoginView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UILabel *loginTipLabel;

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
}

- (IBAction)loginButtonClicked:(id)sender
{
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGRectGetHeight(self.tableView.frame);
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (YSUserSetCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSUserSetCell *cell = [tableView dequeueReusableCellWithIdentifier:UserNoLoginTableViewReuseIdentifier forIndexPath:indexPath];
    
    [cell setupWithType:YSUserSetCellTypeMeasure];
    
    return cell;
}


@end
