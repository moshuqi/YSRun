//
//  YSTipView.m
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSTipView.h"
#import "YSTipCell.h"

#define TipTableViewIdentifier  @"TipTableViewIdentifier"
#define kTipKey                 @"kTipKey"
#define kTipDetailKey           @"kTipDetailKey"

@interface YSTipView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArray;

@end

@implementation YSTipView

- (void)awakeFromNib
{
    [self initTableViewDataArray];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YSTipCell" bundle:nil] forCellReuseIdentifier:TipTableViewIdentifier];
    self.tableView.userInteractionEnabled = NO;
}

- (void)initTableViewDataArray
{
    NSDictionary *dict1 = @{kTipKey : @"饮食建议",
                            kTipDetailKey : @"减肥过程中的饮食摄入量应注意低糖低脂肪"};
    
    NSDictionary *dict2 = @{kTipKey : @"运动建议",
                            kTipDetailKey : @"刚开始不要追求跑步速度和距离，以坚持更久为目标吧"};
    
    self.dataArray = @[dict1, dict2];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSTipView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        
        [self addSubview:containerView];
    }
    
    return self;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat rowHeight = height / [self.dataArray count];
    
    return rowHeight;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (YSTipCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSTipCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TipTableViewIdentifier];
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    [self setupCell:cell withDict:dict];
    
    return cell;
}

- (void)setupCell:(YSTipCell *)cell withDict:(NSDictionary *)dict
{
    NSString *tipText = [dict valueForKey:kTipKey];
    NSString *detailText = [dict valueForKey:kTipDetailKey];
    
    [cell setupWithTip:tipText tipDetail:detailText];
}

@end
