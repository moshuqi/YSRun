//
//  YSUserSettingView.m
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSUserSettingView.h"
#import "YSAppMacro.h"
#import "YSDataManager.h"
#import "YSDevice.h"

#define UserSetTableViewReuseIdentifier @"UserSetTableViewReuseIdentifier"

@interface YSUserSettingView () <UITableViewDelegate, UITableViewDataSource, YSUserSetCellDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArray;

@end

const CGFloat kHeightForHeader = 10;

@implementation YSUserSettingView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initTableViewDataArray];
    [self.tableView registerNib:[UINib nibWithNibName:@"YSUserSetCell" bundle:nil] forCellReuseIdentifier:UserSetTableViewReuseIdentifier];
    
    self.tableView.backgroundColor = LightgrayBackgroundColor;
    self.tableView.scrollEnabled = NO;
}

- (void)initTableViewDataArray
{
    // 1、我的昵称；2、设置
    NSArray *array1 = @[[NSNumber numberWithInteger:YSSettingsTypeNickname]];
    NSArray *array2 = @[[NSNumber numberWithInteger:YSSettingsTypeSet]];
    
    self.dataArray = @[array1, array2];
}


//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super initWithCoder:aDecoder])
//    {
//        UIView *containerView = [[[UINib nibWithNibName:@"YSUserSettingView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
//        
//        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//        containerView.frame = newFrame;
//        containerView.backgroundColor = [UIColor clearColor];
//        
//        [self addSubview:containerView];
//    }
//    
//    return self;
//}

- (void)reloadTableView
{
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = self.dataArray[indexPath.section];
    YSSettingsType cellType = (YSSettingsType)[array[indexPath.row] integerValue];
    
    // 单位和心率cell点击时没有反应
    if (cellType == YSSettingsTypeMeasure ||
        cellType == YSSettingsTypeHeartRatePanel ||
        cellType == YSSettingsTypeNickname)
    {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *array = self.dataArray[indexPath.section];
    YSSettingsType cellType = (YSSettingsType)[array[indexPath.row] integerValue];
    
    [self.delegate userSettingViewDidSelectedType:cellType];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightForRow = 44;
    if ([YSDevice isPhone6Plus])
    {
        heightForRow = 60;
    }
    
    return heightForRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeightForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = LightgrayBackgroundColor;
    
    return view;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.dataArray[section];
    return [array count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];;
}

- (YSUserSetCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSUserSetCell *cell = [tableView dequeueReusableCellWithIdentifier:UserSetTableViewReuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    
    NSArray *array = self.dataArray[indexPath.section];
    YSSettingsType type = [array[indexPath.row] integerValue];
    
    switch (type)
    {
        case YSSettingsTypeNickname:
            [cell setupCellWithLeftText:@"我的昵称"
                             centerText:nil
                              rightText:nil
                          textFieldText:[[YSDataManager shareDataManager] getUserName]
                          switchVisible:NO];
            break;
            
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

#pragma mark - YSUserSetCellDelegate

- (void)textFieldTextChange:(NSString *)text
{
    [self.delegate modifyNickame:text];
}

@end
