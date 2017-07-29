//
//  YSHeartRateDataView.m
//  YSRun
//
//  Created by moshuqi on 16/1/25.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSHeartRateDataView.h"
#import "YSMarkLabelsView.h"
#import "YSHeartRateRecordCommentView.h"
#import "YSBarChart.h"
#import "YSHeartRateGraphView.h"
#import "YSAppMacro.h"
#import "YSStatisticsDefine.h"
#import "YSDataRecordModel.h"
#import "YSTimeFunc.h"
#import "YSPopView.h"
#import "YSContentHelpView.h"

@interface YSHeartRateDataView () <YSHeartRateGraphViewDelegate>

@property (nonatomic, weak) IBOutlet YSMarkLabelsView *labelsView;
@property (nonatomic, weak) IBOutlet YSHeartRateRecordCommentView *commentView;
@property (nonatomic, weak) IBOutlet YSBarChart *barChart;
@property (nonatomic, weak) IBOutlet YSHeartRateGraphView *graphView;
@property (nonatomic, weak) IBOutlet UIView *line;
@property (nonatomic, weak) IBOutlet UILabel *label;    // “心率达标率”标签

@property (nonatomic, weak) IBOutlet UIView *contentView;   // labelsView的父视图

@property (nonatomic, strong) YSDataRecordModel *dataRecordModel;

@end

@implementation YSHeartRateDataView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupMarkLabelsView];
    [self setupCommentView];
    
    self.label.text = @"心率达标率";
    self.label.textColor = [self textColor];
    self.label.font = [UIFont systemFontOfSize:12];
    
    self.line.backgroundColor = LightgrayBackgroundColor;
}

- (void)setupMarkLabelsView
{
    // 设置字体大小、颜色
    [self.labelsView setLeftLabelMarkText:@"高效减脂"];
    [self.labelsView setCenterLabelMarkText:@"简单慢跑"];
    [self.labelsView setRightLabelMarkText:@"无氧运动"];
    
    CGFloat contentFontSize = 16;
    CGFloat markFontSize = 10;
    UIColor *contentColor = RGB(80, 80, 80);
    UIColor *markColor = RGB(121, 121, 121);
    
    [self.labelsView setContentTextBoldWithFontSize:contentFontSize];
    [self.labelsView setMarkTextFontSize:markFontSize];
    [self.labelsView setContentTextColor:contentColor];
    [self.labelsView setMarkTextColor:markColor];
    
    // 数据标签的背景色设置
    self.contentView.backgroundColor = LightgrayBackgroundColor;
}

- (void)setupCommentView
{
    [self.commentView setLeftCommentElementColor:JoggingColor text:@"<140"];
    [self.commentView setCenterCommentElementColor:EfficientReduceFatColor text:@"140~160"];
    [self.commentView setRightCommentElementColor:AnaerobicExerciseColor text:@">160"];
    
    [self.commentView setFontSize:12];
}

- (void)setupWithDataRecordModel:(YSDataRecordModel *)dataRecordModel
{
    self.dataRecordModel = dataRecordModel;
    
    [self setupLabelsWith:dataRecordModel];
    
    // 必须保证一定存在心率数据
    if ([dataRecordModel.heartRateArray count] > 0)
    {
        YSChartData *chartData = [self getChartData];
        [self.barChart setupWithChartData:chartData];
        self.barChart.layer.cornerRadius = 5;
        self.barChart.clipsToBounds = YES;
    }
    
    // 必须保证一定存在心率数据
    NSArray *dictDataArray = [self dictDataArrayWithHeartRates:dataRecordModel.heartRateArray];
    if ([dictDataArray count] > 0)
    {
        [self.graphView setupWithStartTime:dataRecordModel.startTime endTime:dataRecordModel.endTime dictDataArray:dictDataArray];
        self.graphView.delegate = self;
    }
}

- (void)setupLabelsWith:(YSDataRecordModel *)dataModel
{
    NSInteger useTime = dataModel.endTime - dataModel.startTime;
    YSChartData *chartData = [self getChartData];
    
    // 各个心率区间所占时间数据
    CGFloat joggingPercent = [chartData getElementPercentAtIndex:0];
    CGFloat efficientReduceFatPercent = [chartData getElementPercentAtIndex:1];
    CGFloat anaerobicExercisePercent = [chartData getElementPercentAtIndex:2];
    
    NSInteger joggingTime = (NSInteger)(useTime * joggingPercent);
    NSInteger efficientReduceFatTime = (NSInteger)(useTime * efficientReduceFatPercent);
    NSInteger anaerobicExerciseTime = (NSInteger)(useTime * anaerobicExercisePercent);
    
    [self.labelsView setLeftLabelContentText:[YSTimeFunc timeStrFromUseTime:joggingTime]];
    [self.labelsView setCenterLabelContentText:[YSTimeFunc timeStrFromUseTime:efficientReduceFatTime]];
    [self.labelsView setRightLabelContentText:[YSTimeFunc timeStrFromUseTime:anaerobicExerciseTime]];
}

- (YSChartData *)getChartData
{
    return [self getChartDataWithHeartRateArray:self.dataRecordModel.heartRateArray];
}

- (YSChartData *)getChartDataWithHeartRateArray:(NSArray *)heartRateArray
{
    NSArray *dictDataArray = [self dictDataArrayWithHeartRates:heartRateArray];
    YSChartData *chartData = [self chartDataWithDictDataArray:dictDataArray];
    
    return chartData;
}

- (NSArray *)dictDataArrayWithHeartRates:(NSArray *)heartRates
{
    // heartRates里包含记录的心率数据
    
    NSMutableArray *chartDataArray = [NSMutableArray array];
    NSInteger count = [heartRates count];
    for (NSInteger i = 0; i < count; i++)
    {
        NSInteger timestamp = i;    //
        
        NSDictionary *dict = @{YSGraphDataHeartRateKey : heartRates[i],
                               YSGraphDataTimestampKey : [NSNumber numberWithInteger:timestamp]};
        [chartDataArray addObject:dict];
    }
    
    return chartDataArray;
}

- (YSChartData *)chartDataWithDictDataArray:(NSArray *)dataArray
{
    NSInteger topQuantity = 0;
    NSInteger middleQuantity = 0;
    NSInteger bottomQuantity = 0;
    
    for (NSDictionary *dict in dataArray)
    {
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            NSInteger heartRate = [[dict valueForKey:YSGraphDataHeartRateKey] integerValue];
            if (heartRate > YSGraphDataMiddleSectionMax)
            {
                topQuantity++;
            }
            else if (heartRate < YSGraphDataMiddleSectionMin)
            {
                bottomQuantity++;
            }
            else
            {
                middleQuantity++;
            }
        }
    }
    
    YSChartElement *element1 = [YSChartElement new];
    element1.elementName = @"简单慢跑";
    element1.color = JoggingColor;
    element1.quantity = bottomQuantity;
    
    YSChartElement *element2 = [YSChartElement new];
    element2.elementName = @"高效减脂";
    element2.color = EfficientReduceFatColor;
    element2.quantity = middleQuantity;
    
    YSChartElement *element3 = [YSChartElement new];
    element3.elementName = @"无氧运动";
    element3.color = AnaerobicExerciseColor;
    element3.quantity = topQuantity;
    
    NSArray *elementArray = @[element1, element2, element3];
    YSChartData *chartData = [[YSChartData alloc] initWithElementArray:elementArray];
    
    return chartData;
}

- (void)showPercentValue
{
    // 显示百分比标签，必须在视图布局完成之后调用。
    [self.barChart setChartElementVisible:NO percentVisible:YES];
}

- (UIColor *)textColor
{
    UIColor *color = RGB(81, 81, 81);
    return color;
}

#pragma mark - YSHeartRateGraphViewDelegate

- (void)tapHelpFromPoint:(CGPoint)point
{
    CGPoint p = [self convertPoint:point fromView:self.graphView];
    p = CGPointMake(p.x, p.y + 5);
    
    YSPopView *popView = [[[UINib nibWithNibName:@"YSPopView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    CGFloat popViewWidth = 260;
    CGFloat popViewHeight = 200;
    
    CGRect popViewFrame = CGRectMake(CGRectGetWidth(self.frame) - popViewWidth - 10, p.y, popViewWidth, popViewHeight);
    
    CGFloat d = p.x - popViewFrame.origin.x;
    CGPoint atPoint = CGPointMake(popViewWidth * (d / popViewWidth), 0);
    
    [popView setColor:RGB(245, 245, 245)];
    [popView setArrowHeight:10];
    [popView showPopViewWithFrame:popViewFrame fromView:self atPoint:atPoint];
    
    YSContentHelpView *helpView = [[[UINib nibWithNibName:@"YSContentHelpView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [helpView setupComponents];
    
    CGRect helpViewFrame = CGRectMake(0, 0, popViewWidth - 20, popViewHeight - 32);
    helpView.frame = helpViewFrame;
    
    [popView addContentView:helpView];
}

@end
