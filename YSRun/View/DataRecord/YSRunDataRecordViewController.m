//
//  YSRunDataRecordViewController.m
//  YSRun
//
//  Created by moshuqi on 15/12/2.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSRunDataRecordViewController.h"
#import "YSDataRecordBar.h"
#import "YSDataRecordModel.h"
#import "YSMarkLabelsView.h"
#import "YSAppMacro.h"
#import "YSMapScreenshotPaint.h"
#import "YSTimeFunc.h"
#import "YSHeartRateScopeTipView.h"
#import "YSDevice.h"

@interface YSRunDataRecordViewController () <YSDataRecordBarDelegate>

@property (nonatomic, weak) IBOutlet YSDataRecordBar *bar;
@property (nonatomic, weak) IBOutlet UIImageView *mapImageView;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet YSMarkLabelsView *markLabelsView;
@property (nonatomic, weak) IBOutlet YSHeartRateScopeTipView *heartRateScopeTipView;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *labelsViewHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *labelsViewBottomToTipViewConstraint;

@property (nonatomic, strong) YSDataRecordModel *dataRecordModel;
@property (nonatomic, strong) YSMapScreenshotPaint *screenshotPaint;

@end

@implementation YSRunDataRecordViewController

- (id)initWithDataRecordModel:(YSDataRecordModel *)dataRecordModel
{
    self = [super init];
    if (self)
    {
        self.dataRecordModel = dataRecordModel;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.bar setBarTitle:@"跑步数据"];
    self.bar.delegate = self;
    
    NSString *tipText = @"心率保持在140-160之间，减肥效果最佳";
    [self.heartRateScopeTipView setTIpLabelText:tipText];
    
    [self setupMarkLabels];
    [self setupDateLabel];
    
    [self resetWithDataModel:self.dataRecordModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setupDateLabel
{
    self.dateLabel.textColor = [UIColor whiteColor];
    self.dateLabel.font = [UIFont systemFontOfSize:10];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    
    self.dateLabel.backgroundColor = RGBA(4, 181, 108, 0.25);
    self.dateLabel.layer.cornerRadius = 3;
    self.dateLabel.clipsToBounds = YES;
}


- (void)setupMarkLabels
{
    CGFloat contentFontSize = 16;
    CGFloat markFontSize = 10;
    
    // 6plus界面的适配
    if ([YSDevice isPhone6Plus])
    {
        contentFontSize = 18;
        markFontSize = 12;
        
        self.labelsViewHeightConstraint.constant = 48;
        self.labelsViewBottomToTipViewConstraint.constant = 36;
    }
    
    [self.markLabelsView setContentTextBoldWithFontSize:contentFontSize];
    [self.markLabelsView setMarkTextFontSize:markFontSize];
    
    UIColor *contentTextColor = RGB(38, 38, 38);
    [self.markLabelsView setContentTextColor:contentTextColor];
    
    UIColor *markTextColor = RGB(136, 136, 136);
    [self.markLabelsView setMarkTextColor:markTextColor];
    
    [self.markLabelsView setLeftLabelContentText:@"0.00"];
    [self.markLabelsView setLeftLabelMarkText:@"距离(公里)"];
    
    [self.markLabelsView setCenterLabelContentText:@"00:00:00"];
    [self.markLabelsView setCenterLabelMarkText:@"时长"];
    
    [self.markLabelsView setRightLabelContentText:@"888"];
    [self.markLabelsView setRightLabelMarkText:@"大卡"];
}

- (void)resetWithDataModel:(YSDataRecordModel *)dataModel
{
    // 地图图片，时间标签
    [self setMapScreenshotWithLocationArray:dataModel.locationArray];
    self.dateLabel.text = [YSTimeFunc dateStrFromTimestamp:dataModel.endTime];
    
    [self setupMarkLabelsWith:dataModel];
}

- (void)setMapScreenshotWithLocationArray:(NSArray *)locationArray
{
    CGSize size = self.mapImageView.bounds.size;
    self.screenshotPaint = [YSMapScreenshotPaint new];
    
    UIImage *image = [self.screenshotPaint screenshotPaintWithAnnotationArray:locationArray size:size];
    self.mapImageView.image = image;
}

- (void)setupMarkLabelsWith:(YSDataRecordModel *)dataModel
{
    // 距离、时间、卡路里消耗数据
    [self.markLabelsView setLeftLabelContentText:[NSString stringWithFormat:@"%.2f", dataModel.distance / 1000]];
    
    NSInteger useTime = dataModel.endTime - dataModel.startTime;
    NSString *timeStr = [YSTimeFunc timeStrFromUseTime:useTime];
    
    [self.markLabelsView setCenterLabelContentText:timeStr];
    [self.markLabelsView setRightLabelContentText:[NSString stringWithFormat:@"%@", @(dataModel.calorie)]];
}

#pragma mark - YSDataRecordBarDelegate

- (void)viewBack
{
    if (self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
