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

@interface YSResultRecordView () <YSResultHeartRateDataLabelsDelegate, YSResultRunDataLabelsDelegate>

@property (nonatomic, weak) IBOutlet UILabel *effectLabel;
@property (nonatomic, weak) IBOutlet UILabel *tipLabel1;
@property (nonatomic, weak) IBOutlet UILabel *tipLabel2;

@property (nonatomic, weak) IBOutlet YSStarRatingView *starRattingView;
@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;

@property (nonatomic, weak) IBOutlet UIView *dataLabelsContentView;
@property (nonatomic, strong) YSResultHeartRateDataLabels *heartRateDataLabels;
@property (nonatomic, strong) YSResultRunDataLabels *runDataLabels;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *starRattingViewHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *effectLabelHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *tipContentViewHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *dataLabelsHeightConstraint;

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
    [self setupLabels];
    
    [[self.dataLabelsContentView superview] bringSubviewToFront:self.dataLabelsContentView];
    
    // 6plus适配
    if ([YSDevice isPhone6Plus])
    {
        self.starRattingViewHeightConstraint.constant = 112;
        self.effectLabelHeightConstraint.constant = 62;
        self.tipContentViewHeightConstraint.constant = 60;
        self.dataLabelsHeightConstraint.constant = 52;
        
        // 字体大小调整
        self.effectLabel.font = [UIFont systemFontOfSize:24];
        self.tipLabel1.font = [UIFont systemFontOfSize:16];
        self.tipLabel2.font = [UIFont systemFontOfSize:16];
    }
}

- (void)setupLabels
{
    CGFloat fontSize = 14;
    self.tipLabel1.font = [UIFont systemFontOfSize:fontSize];
    self.tipLabel2.font = [UIFont systemFontOfSize:fontSize];
    
    self.tipLabel1.adjustsFontSizeToFitWidth = YES;
    self.tipLabel2.adjustsFontSizeToFitWidth = YES;
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
    [self setupEffectLabelWithRattingLevel:runInfoModel.star];
    
    // 根据是否有心率数据来决定显示对应的视图
    [self showDataLabelsWithRunInfoModel:runInfoModel];
}

- (void)setupEffectLabelWithRattingLevel:(NSInteger)level
{
    // 根据评分等级显示对应的提示
    NSString *text = nil;
    
    // 零星的时候：没有跑步成绩
    // 一星的时候：跑步效果一般
    // 二星的时候：跑步效果良好
    // 三星的时候：跑步效果完美
    switch (level)
    {
        case 0:
            text = @"没有跑步成绩";
            break;
            
        case 1:
            text = @"跑步效果一般";
            break;
            
        case 2:
            text = @"跑步效果良好";
            break;
            
        default:
            text = @"跑步效果完美";
            break;
    }
    
    self.effectLabel.text = text;
}

- (void)showDataLabelsWithRunInfoModel:(YSRunInfoModel *)runInfoModel
{
    CGFloat kilometre = runInfoModel.distance / 1000;
    NSString *timeStr = [YSTimeFunc timeStrFromUseTime:runInfoModel.useTime];
    CGFloat calorie = [YSCalorieCalculateFunc calculateCalorieWithWeight:65 distance:kilometre];
    
    BOOL hasHeartRateData = ([runInfoModel.heartRateArray count] > 0);
    if (hasHeartRateData)
    {
        // 有心率熟虑时多显示一个心率达标标签
        self.heartRateDataLabels = [[[UINib nibWithNibName:@"YSResultHeartRateDataLabels" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        self.heartRateDataLabels.delegate = self;
        
        self.heartRateDataLabels.frame = self.dataLabelsContentView.bounds;
        [self.dataLabelsContentView addSubview:self.heartRateDataLabels];
        
        CGFloat proportion = [YSHeartRateDataManager efficientProportionWithHeartRateArray:runInfoModel.heartRateArray];
        [self.heartRateDataLabels setDistance:kilometre time:timeStr calorie:calorie heartRateProportion:proportion];
    }
    else
    {
        self.runDataLabels = [[[UINib nibWithNibName:@"YSResultRunDataLabels" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        self.runDataLabels.delegate = self;
        
        self.runDataLabels.frame = self.dataLabelsContentView.bounds;
        [self.dataLabelsContentView addSubview:self.runDataLabels];
        
        [self.runDataLabels setDistance:kilometre time:timeStr calorie:calorie];
    }
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

@end
