//
//  YSRunDataRecordCell.m
//  YSRun
//
//  Created by moshuqi on 15/11/24.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSRunDataRecordCell.h"
//#import "YSSubscriptLabel.h"
#import "YSBarChart.h"
#import "YSAppMacro.h"
#import "YSMarkLabel.h"
#import "YSMarkLabelsView.h"
#import "YSDataRecordModel.h"
#import "YSTimeFunc.h"
//#import "YSGraphData.h"
#import "YSStatisticsDefine.h"

@interface YSRunDataRecordCell ()

@property (nonatomic, weak) IBOutlet YSMarkLabelsView *markLabelsView;

@property (nonatomic, weak) IBOutlet YSBarChart *barChart;
@property (nonatomic, weak) IBOutlet UIView *cellTitleView; // 加上手势，点击显示帮助
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIView *helpIconView;

//@property (nonatomic, strong) YSDataRecordModel *model;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *markLabelsViewTopToSuperViewConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *markLabelsViewTopToTitleViewConstraint;

//@property (nonatomic, strong) IBOutlet NSLayoutConstraint *markLabelsViewBottomToSuperViewConstraint;
//@property (nonatomic, strong) IBOutlet NSLayoutConstraint *markLabelsViewBottomToBarChartConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *chartHeightConstraint;

@end

@implementation YSRunDataRecordCell

static const CGFloat kChartHeight = 20;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self setupLabels];
}

- (void)setupLabels
{
    [self setupMarkLabels];
    [self setupTitleView];
    
    [self testChart];
}

- (void)testChart
{
    YSChartElement *element1 = [YSChartElement new];
    element1.elementName = @"简单慢跑";
    element1.color = JoggingColor;
    element1.quantity = 20;
    
    YSChartElement *element2 = [YSChartElement new];
    element2.elementName = @"高效减脂";
    element2.color = EfficientReduceFatColor;
    element2.quantity = 30;
    
    YSChartElement *element3 = [YSChartElement new];
    element3.elementName = @"无氧运动";
    element3.color = AnaerobicExerciseColor;
    element3.quantity = 50;
    
    NSArray *elementArray = @[element1, element2, element3];
    YSChartData *chartData = [[YSChartData alloc] initWithElementArray:elementArray];
    
    self.barChart.chartData = chartData;
    self.barChart.layer.cornerRadius = 5;
    [self.barChart setNeedsDisplay];
}

- (void)setupTitleView
{
    // 设置标签，并加上手势事件，点击弹出帮助视图
    
    self.titleLabel.text = @"跑步成绩";
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = RGB(38, 38, 38);
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    [self addGesture];
}

- (void)addGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHelpIcon:)];
    [self.cellTitleView addGestureRecognizer:tap];
}

- (void)tapHelpIcon:(UITapGestureRecognizer *)tapGesture
{
    if ([self.delegate respondsToSelector:@selector(showContentHelpFromPoint:)])
    {
        [self.delegate showContentHelpFromPoint:[self getHelpViewShowingPointAtWindow]];
    }
}

- (void)setupMarkLabels
{
    CGFloat contentFontSize = 16;
    CGFloat markFontSize = 10;
    UIColor *contentTextColor = RGB(38, 38, 38);
    UIColor *markTextColor = RGB(136, 136, 136);
    
    [self.markLabelsView setContentTextBoldWithFontSize:contentFontSize];
    [self.markLabelsView setMarkTextFontSize:markFontSize];
    [self.markLabelsView setContentTextColor:contentTextColor];
    [self.markLabelsView setMarkTextColor:markTextColor];
    
    [self.markLabelsView setLeftLabelContentText:@"0.00"];
    [self.markLabelsView setLeftLabelMarkText:@"距离(公里)"];
    
    [self.markLabelsView setCenterLabelContentText:@"00:00:00"];
    [self.markLabelsView setCenterLabelMarkText:@"时长"];
    
    [self.markLabelsView setRightLabelContentText:@"888"];
    [self.markLabelsView setRightLabelMarkText:@"大卡"];
}

- (void)resetCellWithModel:(YSDataRecordModel *)model
{
    // 设置标签的数值
    NSString *distanceStr = [NSString stringWithFormat:@"%.2f", model.distance / 1000];
    [self.markLabelsView setLeftLabelContentText:distanceStr];
    
    NSInteger useTime = model.endTime - model.startTime;
    NSString *timeStr = [YSTimeFunc timeStrFromUseTime:useTime];
    [self.markLabelsView setCenterLabelContentText:timeStr];
    
    NSString *calorieStr = [NSString stringWithFormat:@"%@", @(model.calorie)];
    [self.markLabelsView setRightLabelContentText:calorieStr];
    
    // 根据是否有心率数据显示或隐藏条形统计图。
    BOOL hasHeartRateData = [model.heartRateArray count] > 0;
    if (hasHeartRateData)
    {
        [self resetBarChartWithHeartRateDataArray:model.heartRateArray];
    }
    [self setBarChartHidden:!hasHeartRateData];
}

- (void)resetBarChartWithHeartRateDataArray:(NSArray *)heartRateArray
{
    YSChartData *charData = [self getChartDataWithArray:heartRateArray];
    [self.barChart setupWithChartData:charData];
    [self.barChart setNeedsDisplay];
}

- (YSChartData *)getChartDataWithArray:(NSArray *)array
{
    NSInteger jogginQuantity = 0;
    NSInteger efficientQuantity = 0;
    NSInteger anaerobicQuantity = 0;
    
    for (id object in array)
    {
        if ([object isKindOfClass:[NSNumber class]])
        {
            NSInteger heartRate = [object integerValue];
            if (heartRate > YSGraphDataMiddleSectionMax)
            {
                anaerobicQuantity ++;
            }
            else if (heartRate < YSGraphDataMiddleSectionMin)
            {
                jogginQuantity ++;
            }
            else
            {
                efficientQuantity ++;
            }
        }
    }
    
    YSChartElement *element1 = [YSChartElement new];
    element1.elementName = @"简单慢跑";
    element1.color = JoggingColor;
    element1.quantity = jogginQuantity;
    
    YSChartElement *element2 = [YSChartElement new];
    element2.elementName = @"高效减脂";
    element2.color = EfficientReduceFatColor;
    element2.quantity = efficientQuantity;
    
    YSChartElement *element3 = [YSChartElement new];
    element3.elementName = @"无氧运动";
    element3.color = AnaerobicExerciseColor;
    element3.quantity = anaerobicQuantity;
    
    NSArray *elementArray = @[element1, element2, element3];
    YSChartData *chartData = [[YSChartData alloc] initWithElementArray:elementArray];
    
    return chartData;
}

- (void)setBarChartHidden:(BOOL)isHidden
{
    // 没有心率数据时不显示统计图
//    if (isHidden)
//    {
//        self.markLabelsViewBottomToBarChartConstraint.active = NO;
//        self.markLabelsViewBottomToSuperViewConstraint.active = YES;
//    }
//    else
//    {
//        self.markLabelsViewBottomToSuperViewConstraint.active = NO;
//        self.markLabelsViewBottomToBarChartConstraint.active = YES;
//    }
    
    if (isHidden)
    {
        self.chartHeightConstraint.constant = 0;
    }
    else
    {
        self.chartHeightConstraint.constant = kChartHeight;
    }
    
    self.barChart.hidden = isHidden;
    [self layoutIfNeeded];
}

- (void)setHelpTitleHidden:(BOOL)isHidden
{
    if (isHidden)
    {
        self.markLabelsViewTopToTitleViewConstraint.active = NO;
        self.markLabelsViewTopToSuperViewConstraint.active = YES;
    }
    else
    {
        self.markLabelsViewTopToSuperViewConstraint.active = NO;
        self.markLabelsViewTopToTitleViewConstraint.active = YES;
    }
    self.helpIconView.hidden = isHidden;
    [self layoutIfNeeded];
}

- (CGPoint)getHelpViewShowingPointAtWindow
{
    CGRect frame = self.cellTitleView.frame;
    CGFloat d = 5;  // 间距
    CGPoint point = CGPointMake(frame.origin.x + frame.size.width,
                                frame.origin.y + d);
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGPoint pointAtWindow = [self convertPoint:point toView:window];
    
    return pointAtWindow;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
