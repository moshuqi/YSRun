//
//  YSResultRecordView.m
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSResultRecordView.h"
#import "YSStarRatingView.h"
#import "YSRunInfoModel.h"
#import "YSResultHeartRateDataLabels.h"
#import "YSResultRunDataLabels.h"
#import "YSTimeFunc.h"
#import "YSCalorieCalculateFunc.h"
#import "YSHeartRateDataManager.h"
#import "YSDevice.h"
#import "YSResultDataLabelsView.h"
#import "YSResultTipView.h"
#import "YSPopView.h"
#import "YSRatingDetailView.h"

@interface YSResultRecordView () <YSResultHeartRateDataLabelsDelegate, YSResultRunDataLabelsDelegate, YSResultTipViewDelegate>

@property (nonatomic, weak) IBOutlet YSStarRatingView *starRattingView;
@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;

@property (nonatomic, weak) IBOutlet YSResultDataLabelsView *resultDataLabelsView;
@property (nonatomic, weak) IBOutlet YSResultTipView *tipView;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *starRattingViewHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *labelsViewHeightConstraint;

@property (nonatomic, assign) NSInteger starRating;

@end

@implementation YSResultRecordView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSResultRecordView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        containerView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self addBackgroundPhoto];
    
//    [[self.dataLabelsContentView superview] bringSubviewToFront:self.dataLabelsContentView];
    
    // 6plus适配
    if ([YSDevice isPhone6Plus])
    {
        self.starRattingViewHeightConstraint.constant = 92;
        self.labelsViewHeightConstraint.constant = 96;
    }
    
    self.tipView.delegate = self;
}


- (void)addBackgroundPhoto
{
    UIImage *image = [UIImage imageNamed:@"background_image2.png"];
    
//    CGRect frame = self.bgImageView.frame;
//    
//    CGSize size = frame.size;
//    UIGraphicsBeginImageContext(size);
//
//    CGFloat originWidth = image.size.width;
//    CGFloat originHeight = image.size.height;
//    CGFloat scale = size.width / originWidth;
//    
//    [image drawInRect:CGRectMake(0, 0, originWidth * scale, originHeight * scale)];
//    image = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
    
    self.bgImageView.image = image;
}

- (void)setupRecordWith:(YSRunInfoModel *)runInfoModel
{
    [self.starRattingView setRattingLevel:runInfoModel.star];
//    [self setupEffectLabelWithRattingLevel:runInfoModel.star];
    [self.tipView showTipWithRating:runInfoModel.star];
    
    // 根据是否有心率数据来决定显示对应的视图
    [self showDataLabelsWithRunInfoModel:runInfoModel];
    
    self.starRating = runInfoModel.star;
}

//- (void)setupEffectLabelWithRattingLevel:(NSInteger)level
//{
//    // 根据评分等级显示对应的提示
//    NSString *text = nil;
//    
//    // 零星的时候：没有跑步成绩
//    // 一星的时候：跑步效果一般
//    // 二星的时候：跑步效果良好
//    // 三星的时候：跑步效果完美
//    switch (level)
//    {
//        case 0:
//            text = @"没有跑步成绩";
//            break;
//            
//        case 1:
//            text = @"跑步效果一般";
//            break;
//            
//        case 2:
//            text = @"跑步效果良好";
//            break;
//            
//        default:
//            text = @"跑步效果完美";
//            break;
//    }
//    
//    self.effectLabel.text = text;
//}

- (void)showDataLabelsWithRunInfoModel:(YSRunInfoModel *)runInfoModel
{
    CGFloat kilometre = runInfoModel.distance / 1000;
    NSString *timeStr = [YSTimeFunc timeStrFromUseTime:runInfoModel.useTime];
    CGFloat calorie = [YSCalorieCalculateFunc calculateCalorieWithWeight:65 distance:kilometre];
    
    NSString *distanceStr = [NSString stringWithFormat:@"%.2f", kilometre];
    NSString *calorieStr = [NSString stringWithFormat:@"%@", @((NSInteger)calorie)];
    [self.resultDataLabelsView setupWithDistance:distanceStr time:timeStr calorie:calorieStr];
    
    BOOL hasHeartRateData = ([runInfoModel.heartRateArray count] > 0);
    if (hasHeartRateData)
    {
        CGFloat proportion = [YSHeartRateDataManager efficientProportionWithHeartRateArray:runInfoModel.heartRateArray];
        [self.resultDataLabelsView setStandarRate:proportion];
    }
    
//    if (hasHeartRateData)
//    {
//        // 有心率熟虑时多显示一个心率达标标签
//        self.heartRateDataLabels = [[[UINib nibWithNibName:@"YSResultHeartRateDataLabels" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
//        self.heartRateDataLabels.delegate = self;
//        
//        self.heartRateDataLabels.frame = self.dataLabelsContentView.bounds;
//        [self.dataLabelsContentView addSubview:self.heartRateDataLabels];
//        
//        CGFloat proportion = [YSHeartRateDataManager efficientProportionWithHeartRateArray:runInfoModel.heartRateArray];
//        [self.heartRateDataLabels setDistance:kilometre time:timeStr calorie:calorie heartRateProportion:proportion];
//    }
//    else
//    {
//        self.runDataLabels = [[[UINib nibWithNibName:@"YSResultRunDataLabels" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
//        self.runDataLabels.delegate = self;
//        
//        self.runDataLabels.frame = self.dataLabelsContentView.bounds;
//        [self.dataLabelsContentView addSubview:self.runDataLabels];
//        
//        [self.runDataLabels setDistance:kilometre time:timeStr calorie:calorie];
//    }
}

- (IBAction)back:(id)sender
{
    [self.delegate resultRecordViewBack];
}


#pragma mark - YSResultHeartRateDataLabelsDelegate

- (void)heartRateDataLabelsTapDetail
{
    [self.delegate showHeartRateDataDetail];
}

#pragma mark - YSResultRunDataLabelsDelegate

- (void)runDataLabelsTapDetail
{
    [self.delegate showRunDataDetail];
}

#pragma mark - YSResultTipViewDelegate

- (void)showHelpFromPoint:(CGPoint)point
{
    CGPoint p = [self convertPoint:point fromView:self.tipView];
    p = CGPointMake(p.x, p.y + 5); // 与问号图标的间距
    
    YSPopView *popView = [[[UINib nibWithNibName:@"YSPopView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    CGFloat popViewWidth = 260;
    CGFloat popViewHeight = 88;
    
    CGRect popViewFrame = CGRectMake((CGRectGetWidth(self.frame) - popViewWidth) / 2, p.y, popViewWidth, popViewHeight);
    
    CGFloat d = p.x - popViewFrame.origin.x;
    CGPoint atPoint = CGPointMake(popViewWidth * (d / popViewWidth), 0);
    
    [popView showPopViewWithFrame:popViewFrame fromView:self atPoint:atPoint];
    
    // 添加提示内容的视图
    YSRatingDetailView *detailView = [[[UINib nibWithNibName:@"YSRatingDetailView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    CGRect detailViewFrame = CGRectMake(0, 0, popViewWidth - 52, popViewHeight - 32);
    detailView.frame = detailViewFrame;
    [detailView setTextWithRating:self.starRating];
    
    [popView addContentView:detailView];
}

@end
