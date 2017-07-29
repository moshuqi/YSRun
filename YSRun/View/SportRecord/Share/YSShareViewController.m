//
//  YSShareViewController.m
//  YSRun
//
//  Created by moshuqi on 16/1/29.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSShareViewController.h"
#import "YSMarkLabelsView.h"
#import "YSThirdPartShareSelectView.h"
#import "YSDataRecordModel.h"
#import "YSAppMacro.h"
#import "YSTimeFunc.h"
#import "YSDevice.h"
#import "YSShareFunc.h"

@interface YSShareViewController () <YSThirdPartShareSelectViewDelegate>

@property (nonatomic, weak) IBOutlet UIView *statusBarView;
@property (nonatomic, weak) IBOutlet UIView *barView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *resultLabel;  // 显示公里数和时间的标签
@property (nonatomic, weak) IBOutlet UIImageView *mapImageView;

@property (nonatomic, weak) IBOutlet YSMarkLabelsView *dataLabels;
@property (nonatomic, weak) IBOutlet YSThirdPartShareSelectView *shareSelectView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIView *shareContentView;  // 需要分享的内容视图的父视图
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *shareSelectViewHeightConstraint;

@property (nonatomic, strong) YSDataRecordModel *dataRecordModel;
@property (nonatomic, strong) UIImage *mapImage;

@end

@implementation YSShareViewController

- (id)initWithDataRecordModel:(YSDataRecordModel *)dataRecordModel mapImage:(UIImage *)mapImage
{
    self = [super init];
    if (self)
    {
        self.dataRecordModel = dataRecordModel;
        self.mapImage = mapImage;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = YES;
    
    [self setupBarView];
    [self setupMapView];
    [self setupResultView];
    [self setupDataLabel];
    [self setupBackground];
    
    if ([YSDevice isPhone6Plus])
    {
        self.shareSelectViewHeightConstraint.constant = 66;
    }
    
    self.shareSelectView.delegate = self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setupBarView
{
    self.barView.backgroundColor = GreenBackgroundColor;
    
    // 设置标题栏的标签
    self.titleLabel.text = @"易瘦跑步";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.dateLabel.textColor = [UIColor whiteColor];
    self.dateLabel.font = [UIFont systemFontOfSize:10];
    self.dateLabel.adjustsFontSizeToFitWidth = YES;
    
    self.dateLabel.text = [YSTimeFunc dateStrFromTimestamp:self.dataRecordModel.startTime];
}

- (void)setupResultView
{
    // 左下角显示公里数和时间的标签
    
    NSString *distanceStr = [NSString stringWithFormat:@"%.2f", (self.dataRecordModel.distance / 1000)];
    NSString *kmStr = @"公里  ";
    
    NSInteger useTime = self.dataRecordModel.endTime - self.dataRecordModel.startTime;
    NSString *timeStr = [YSTimeFunc timeStrFromUseTime:useTime];
    
    // 分别设置每段文本的属性
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", distanceStr, kmStr, timeStr]];
    
    // 字号大小
    CGFloat distanceFont = 20;
    CGFloat kmFont = 15;
    CGFloat timeFont = 12;
    
    // 每段文本的长度
    NSInteger distanceStrLength = [distanceStr length];
    NSInteger kmStrLength = [kmStr length];
    NSInteger length = [str length];
    
    [str addAttribute:NSForegroundColorAttributeName value:GreenBackgroundColor range:NSMakeRange(0,length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:distanceFont] range:NSMakeRange(0, distanceStrLength)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kmFont] range:NSMakeRange(distanceStrLength, kmStrLength)];
    
    NSInteger timeStrLength = length - (distanceStrLength + kmStrLength);
    NSRange timeStrRange = NSMakeRange(distanceStrLength + kmStrLength, timeStrLength);
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:timeFont] range:timeStrRange];
    
    self.resultLabel.attributedText = str;
    self.resultLabel.adjustsFontSizeToFitWidth = YES;
    self.resultLabel.layer.cornerRadius = CGRectGetHeight(self.resultLabel.frame) / 2;
    self.resultLabel.clipsToBounds = YES;
    self.resultLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.85];
}

- (void)setupMapView
{
    self.mapImageView.contentMode = UIViewContentModeCenter;
    self.mapImageView.clipsToBounds = YES;
    self.mapImageView.image = self.mapImage;
}

- (void)setupDataLabel
{
    // 设置时速、配速、热量标签数据
    
    // 设置下标
    [self.dataLabels setLeftLabelMarkText:@"平均时速"];
    [self.dataLabels setCenterLabelMarkText:@"平均配速"];
    [self.dataLabels setRightLabelMarkText:@"热量"];
    
    UIColor *textColor = [UIColor whiteColor];
    [self.dataLabels setMarkTextColor:textColor];
    
    CGFloat markFontSize = [YSDevice isPhone6Plus] ? 12 : 10;
    [self.dataLabels setMarkTextFontSize:markFontSize];
    
    // 设置attributedText
    UIFont *dataFont = [UIFont systemFontOfSize:16];
    UIFont *suffixFont = [UIFont systemFontOfSize:11];
    if ([YSDevice isPhone6Plus])
    {
        dataFont = [UIFont systemFontOfSize:18];
        suffixFont = [UIFont systemFontOfSize:13];
    }
    
    // 时速
    NSString *speedStr = [NSString stringWithFormat:@"%.2f", [self.dataRecordModel getSpeed]];
    NSString *speedSuffixStr = @"公里/小时";
    NSMutableAttributedString *speedAttributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", speedStr, speedSuffixStr]];
    
    [speedAttributedText addAttribute:NSFontAttributeName value:dataFont range:NSMakeRange(0, [speedStr length])];
    [speedAttributedText addAttribute:NSFontAttributeName value:suffixFont range:NSMakeRange([speedStr length], [speedSuffixStr length])];
    [speedAttributedText addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, [speedAttributedText length])];
    
    // 配速
    NSString *paceStr = [NSString stringWithFormat:@"%.1f", [self.dataRecordModel getPace]];
    NSString *paceSuffixStr = @"平均配速";
    NSMutableAttributedString *spaceAttributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", paceStr, paceSuffixStr]];
    
    [spaceAttributedText addAttribute:NSFontAttributeName value:dataFont range:NSMakeRange(0, [paceStr length])];
    [spaceAttributedText addAttribute:NSFontAttributeName value:suffixFont range:NSMakeRange([paceStr length], [paceSuffixStr length])];
    [spaceAttributedText addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, [spaceAttributedText length])];
    
    // 热量
    NSString *calorieStr = [NSString stringWithFormat:@"%@", @(self.dataRecordModel.calorie)];
    NSString *calorieSuffixStr = @"卡";
    NSMutableAttributedString *calorieAttributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", calorieStr, calorieSuffixStr]];
    
    [calorieAttributedText addAttribute:NSFontAttributeName value:dataFont range:NSMakeRange(0, [calorieStr length])];
    [calorieAttributedText addAttribute:NSFontAttributeName value:suffixFont range:NSMakeRange([calorieStr length], [calorieSuffixStr length])];
    [calorieAttributedText addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, [calorieAttributedText length])];
    
    [self.dataLabels setContentAttributedTextWithLeftStr:speedAttributedText centerStr:spaceAttributedText rightStr:calorieAttributedText];
    self.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
}

- (void)setupBackground
{
    // 设置状态栏、背景颜色
    self.statusBarView.backgroundColor = GreenBackgroundColor;
    
    self.view.backgroundColor = [UIColor grayColor];
}

- (IBAction)viewClose:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - YSThirdPartShareSelectViewDelegate

- (void)shareType:(YSShareSelectType)type
{
    UIImage *image = [self getShareImage];
    if (!image)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"截图失败"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    YSShareInfo *shareInfo = [YSShareInfo defaultShareInfoWithImages:@[image] contentText:[self getShareContentText]];
    
    SSDKPlatformType platformType = SSDKPlatformTypeUnknown;
    switch (type) {
        case YSShareSelectTypeWXCircleOfFriends:
            platformType = SSDKPlatformSubTypeWechatTimeline;
            break;
            
        case YSShareSelectTypeWXFriends:
            platformType = SSDKPlatformSubTypeWechatSession;
            break;
            
        case YSShareSelectTypeSinaWeibo:
            platformType = SSDKPlatformTypeSinaWeibo;
            break;
            
        case YSShareSelectTypeQQZone:
            platformType = SSDKPlatformSubTypeQZone;
            break;
            
        case YSShareSelectTypeQQFriends:
            platformType = SSDKPlatformSubTypeQQFriend;
            break;
            
        default:
            break;
    }
    
    // 分享的回调处理
    ShareFuncCallbackBlock callbackBlock = ^(YSShareFuncResponseState state)
    {
        // 分享成功则返回到主界面
        if (state == YSShareFuncResponseStateSuccess)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    };
    
    [YSShareFunc shareInfo:shareInfo byPlatform:platformType callbackBlock:callbackBlock];
}

- (UIImage *)getShareImage
{
    // 获取需要分享的截图
    CGFloat width = CGRectGetWidth(self.shareContentView.frame);
    CGFloat height = CGRectGetHeight(self.shareContentView.frame) - self.shareSelectViewHeightConstraint.constant;  // 不包含选择平台分享按钮视图
    CGSize size = CGSizeMake(width, height);
    
    // 分享的图片不显示导航条里的关闭按钮，先隐藏，生成截图后再显示。
    self.cancelButton.hidden = YES;
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    [self.shareContentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.cancelButton.hidden = NO;
    
    return image;
}

- (NSString *)getShareContentText
{
    NSInteger useTime = self.dataRecordModel.endTime - self.dataRecordModel.startTime;
    NSString *timeStr = [YSTimeFunc timeStrFromUseTime:useTime];
    
    NSString *distanceStr = [NSString stringWithFormat:@"%.2f", self.dataRecordModel.distance / 1000];
    NSString *paceStr = [NSString stringWithFormat:@"%.2f", [self.dataRecordModel getPace]];
    
    NSString *text = [NSString stringWithFormat:@"用时%@, 距离%@公里, 平均配速%@分钟/公里。 #易瘦跑步#", timeStr, distanceStr, paceStr];
    return text;
}

@end
