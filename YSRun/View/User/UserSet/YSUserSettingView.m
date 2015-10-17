//
//  YSUserSettingView.m
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSUserSettingView.h"
#import "YSUserSetCell.h"
#import "YSAppMacro.h"

#define UserSetTableViewReuseIdentifier @"UserSetTableViewReuseIdentifier"

@interface YSUserSettingView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArray;

@end

const CGFloat kHeightForRow = 46;
const CGFloat kHeightForHeader = 10;

@implementation YSUserSettingView

- (void)awakeFromNib
{
    [self initTableViewDataArray];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YSUserSetCell" bundle:nil] forCellReuseIdentifier:UserSetTableViewReuseIdentifier];
    
    self.tableView.backgroundColor = LightgrayBackgroundColor;
    self.tableView.scrollEnabled = NO;
}

- (void)initTableViewDataArray
{
    NSArray *array1 = @[[NSNumber numberWithInteger:YSUserSetCellTypeNickname]];
    NSArray *array2 = @[[NSNumber numberWithInteger:YSUserSetCellTypeModifyPassword], [NSNumber numberWithInteger:YSUserSetCellTypeMeasure]];
    NSArray *array3 = @[[NSNumber numberWithInteger:YSUserSetCellTypeLogout]];
    
    self.dataArray = @[array1, array2, array3];
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHeightForRow;
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
//    view.backgroundColor = [UIColor yellowColor];
    
    return view;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 1.我的昵称，修改密码；2.单位；3.退出登录
    NSArray *array = self.dataArray[section];
    return [array count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 1.我的昵称，修改密码；2.单位；3.退出登录
    return [self.dataArray count];;
}

- (YSUserSetCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSUserSetCell *cell = [tableView dequeueReusableCellWithIdentifier:UserSetTableViewReuseIdentifier forIndexPath:indexPath];
    
    NSArray *array = self.dataArray[indexPath.section];
    YSUserSetCellType type = [array[indexPath.row] integerValue];
    [cell setupWithType:type];
    
    return cell;
}

@end
