//
//  YSContentTable.m
//  YSRun
//
//  Created by moshuqi on 15/11/24.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSContentTable.h"
#import "YSRunDataRecordCell.h"
#import "YSTipCell.h"
#import "YSRunDatabaseModel.h"
#import "YSContentHelp.h"
#import "YSDataRecordModel.h"
#import "YSAppMacro.h"

#define YSContentTableRecordIdentifier  @"YSContentTableRecordIdentifier"
#define YSContentTableTipIdentifier     @"YSContentTableTipIdentifier"

#define kTipKey                 @"kTipKey"
#define kTipDetailKey           @"kTipDetailKey"

@interface YSContentTable () <UITableViewDelegate, UITableViewDataSource, YSRunDataRecordCellDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *recordArray;     // 记录跑步数据的数组，包含YSDataRecordModel
@property (nonatomic, strong) NSArray *tipArray;        // 记录建议内容
@property (nonatomic, strong) NSArray *sectionArray;    // 包含recordArray和tipArray的数组，若recordArray元素为0，则只包含tipArray
@property (nonatomic, strong) YSContentHelp *contentHelp;

@end

@implementation YSContentTable

static const CGFloat kCellTitleHeight = 30;     // 第一个cell显示“跑步成绩”标签的高度
static const CGFloat kCellDataHeight = 60;      // 显示跑步数据的高度
static const CGFloat kCellChartHeight = 26;     // 显示条形统计图的高度
static const CGFloat kTipCellHeight = 52;       // 提示cell的高度

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSContentTable" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self.tableView registerNib:[UINib nibWithNibName:@"YSTipCell" bundle:nil] forCellReuseIdentifier:YSContentTableTipIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"YSRunDataRecordCell" bundle:nil] forCellReuseIdentifier:YSContentTableRecordIdentifier];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = LightgrayBackgroundColor;
    
    [self initSectionArray];
}

- (void)initSectionArray
{
    [self initTipArray];
    
    NSMutableArray *array = [NSMutableArray array];
    if ([self.recordArray count] > 0)
    {
        [array addObject:self.recordArray];
    }
    [array addObject:self.tipArray];
    
    self.sectionArray = [NSArray arrayWithArray:array];
}

- (void)initTipArray
{
    NSDictionary *dict1 = @{kTipKey : @"饮食建议",
                            kTipDetailKey : @"减肥过程中的饮食摄入量应注意低糖低脂肪"};
    
    NSDictionary *dict2 = @{kTipKey : @"运动建议",
                            kTipDetailKey : @"刚开始不要追求跑步速度和距离，以坚持更久为目标吧"};
    
    self.tipArray = @[dict1, dict2];
}

- (void)setupCell:(YSTipCell *)cell withDict:(NSDictionary *)dict
{
    NSString *tipText = [dict valueForKey:kTipKey];
    NSString *detailText = [dict valueForKey:kTipDetailKey];
    
    [cell setupWithTip:tipText tipDetail:detailText];
}

- (void)resetTableWithRecordDataArray:(NSArray *)recordDataArray
{
    // 通过数据刷新tableview，runDataArray为包含YSDataRecordModel对象的数组
    if ([recordDataArray count] > 0)
    {
        self.recordArray = recordDataArray;
        self.sectionArray = @[self.recordArray, self.tipArray];
    }
    else
    {
        self.sectionArray = @[self.tipArray];
    }
    
    [self.tableView reloadData];
}

- (void)setRecordCell:(YSRunDataRecordCell *)recordCell withModel:(YSDataRecordModel *)model
{
    [recordCell resetCellWithModel:model];
}

- (BOOL)isDataRecordCellWithIndexPath:(NSIndexPath *)indexPath
{
    // 是否为数据cell
    BOOL bSelectedData = ([self.sectionArray count] > 1) && (indexPath.section == 0);
    return bSelectedData;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isDataRecordCellWithIndexPath:indexPath])
    {
        CGFloat height = kCellDataHeight;
        
        // 第一个跑步记录的cell包含"跑步成绩"标签。
        if (indexPath.row == 0)
        {
            height += kCellTitleHeight;
        }
        
        // 若存在心率数据，则显示条形统计图
        YSDataRecordModel *dataModel = self.recordArray[indexPath.row];
        if ([dataModel.heartRateArray count] > 0)
        {
            height += kCellChartHeight;
        }
        
        return height;
    }
    
    return kTipCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == ([self.sectionArray count] - 1))
    {
        return 0.1;
    }
    return 20;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [UIView new];
    footerView.backgroundColor = LightgrayBackgroundColor;
    
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isDataRecordCellWithIndexPath:indexPath])
    {
        if ([self.delegate respondsToSelector:@selector(showHeartRateRecordWithDataModel:)])
        {
            YSDataRecordModel *dataModel = self.recordArray[indexPath.row];
            [self.delegate showHeartRateRecordWithDataModel:dataModel];
        }
    }
    else
    {
        // 跳转到指定网页
        NSURL *url = [NSURL URLWithString:@"http://s.p.qq.com/pub/jump?d=AAAWBM71"];
        [[UIApplication sharedApplication] openURL:url];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSInteger count = [self.recordArray count] + [self.tipArray count];
    NSArray *array = self.sectionArray[section];
    NSInteger count = [array count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if ([self isDataRecordCellWithIndexPath:indexPath])
    {
        // 显示数据的cell
        cell = [self.tableView dequeueReusableCellWithIdentifier:YSContentTableRecordIdentifier];
        ((YSRunDataRecordCell *)cell).delegate = self;
        
        BOOL hiddenHelp = (indexPath.row != 0);
        [(YSRunDataRecordCell *)cell setHelpTitleHidden:hiddenHelp];
        
        YSDataRecordModel *model = self.recordArray[indexPath.row];
        [self setRecordCell:(YSRunDataRecordCell *)cell withModel:model];
    }
    else
    {
        // 提示cell
        cell = (YSTipCell *)[self.tableView dequeueReusableCellWithIdentifier:YSContentTableTipIdentifier];
        
        NSDictionary *dict = self.tipArray[indexPath.row];
        [self setupCell:(YSTipCell *)cell withDict:dict];
    }
    
    return cell;
}

#pragma mark - YSRunDataRecordCellDelegate

- (void)showContentHelpFromPoint:(CGPoint)point
{
    self.contentHelp = [YSContentHelp new];
    [self.contentHelp showHelpFromPoint:point];
}

@end
