//
//  YSDetailDataView.m
//  YSRun
//
//  Created by moshuqi on 16/1/25.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSDetailDataView.h"
#import "YSDetailLabelView.h"
#import "YSDataRecordModel.h"
#import "YSTimeFunc.h"
#import "YSStatisticsDefine.h"
#import "YSAppMacro.h"
#import "YSDevice.h"

@interface YSDetailDataView ()

@property (nonatomic, weak) IBOutlet YSDetailLabelView *detailLabel1;
@property (nonatomic, weak) IBOutlet YSDetailLabelView *detailLabel2;
@property (nonatomic, weak) IBOutlet YSDetailLabelView *detailLabel3;

@property (nonatomic, weak) IBOutlet UIView *line;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *labelHeightConstraint;

@end

@implementation YSDetailDataView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupSuperscript];
    
    self.backgroundColor = LightgrayBackgroundColor;
    self.line.backgroundColor = RGB(215, 215, 215);
    
    if ([YSDevice isPhone6Plus])
    {
        self.labelHeightConstraint.constant = 88;
    }
}

- (void)setupSuperscript
{
    // 设置所有标签的上标
    
    [self.detailLabel1 setLeftScriptText:@"总距离（公里）"];
    [self.detailLabel1 setRightScriptText:@"总时长"];
    
    [self.detailLabel2 setLeftScriptText:@"平均时速（公里/小时）"];
    [self.detailLabel2 setRightScriptText:@"平均配速（分钟/公里）"];
    
    [self.detailLabel3 setLeftScriptText:@"热量（卡）"];
    [self.detailLabel3 setRightScriptText:@"心率达标率"];
}

- (void)setupWithDataRecordModel:(YSDataRecordModel *)dataRecordModel
{
    NSString *distanceStr = [NSString stringWithFormat:@"%.2f", (dataRecordModel.distance / 1000)];
    [self.detailLabel1 setLeftContentText:distanceStr];
    
    NSInteger useTime = dataRecordModel.endTime - dataRecordModel.startTime;
    NSString *timeStr = [YSTimeFunc timeStrFromUseTime:useTime];
    [self.detailLabel1 setRightContentText:timeStr];
    
    // 平均时速
    CGFloat speed = (dataRecordModel.distance / 1000) / (useTime / 60.0 / 60);
    NSString *speedStr = [NSString stringWithFormat:@"%.2f", speed];
    [self.detailLabel2 setLeftContentText:speedStr];
    
    // 平均配速
    NSString *paceStr = [NSString stringWithFormat:@"%.2f", [dataRecordModel getPace]];
    [self.detailLabel2 setRightContentText:paceStr];
    
    NSString *caloriesStr = [NSString stringWithFormat:@"%@", @(dataRecordModel.calorie)];
    [self.detailLabel3 setLeftContentText:caloriesStr];
    
    // 有心率数据则显示达标率，无数据则隐藏对应标签
    if ([dataRecordModel.heartRateArray count] > 0)
    {
        CGFloat rate = [self getStandardRateFromHeartRateArray:dataRecordModel.heartRateArray];
        NSString *standardRateStr = [NSString stringWithFormat:@"%.1f%%", (rate * 100)];
        [self.detailLabel3 setRightContentText:standardRateStr];
    }
    else
    {
        [self.detailLabel3 setRightHidden:YES];
    }
}

- (CGFloat)getStandardRateFromHeartRateArray:(NSArray *)heartRateArray
{
    NSInteger total = [heartRateArray count];
    NSInteger standardCount = 0;
    for (NSInteger i = 0; i < total; i++)
    {
        NSInteger heartRate = [heartRateArray[i] integerValue];
        if ([self isStandard:heartRate])
        {
            standardCount ++;
        }
    }
    
    CGFloat rate = (CGFloat)standardCount / total;
    return rate;
}

- (BOOL)isStandard:(NSInteger)heartRate
{
    if ((heartRate <= YSGraphDataMiddleSectionMax) && (heartRate >= YSGraphDataMiddleSectionMin))
    {
        return YES;
    }
    
    return NO;
}

@end
