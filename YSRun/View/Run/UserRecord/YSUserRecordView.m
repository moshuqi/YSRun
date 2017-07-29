//
//  YSUserRecordView.m
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSUserRecordView.h"
#import "YSDataRecordLabelsView.h"
#import "YSAppMacro.h"
#import "YSBLEDeviceConnectView.h"
#import "YSBLEConnectingView.h"
#import "YSBLEHeartRateCountingView.h"
#import "YSBluetoothConnect.h"
#import "YSAppUIDefine.h"
#import "YSDevice.h"

@interface YSUserRecordView () <YSBLEDeviceConnectViewDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, weak) IBOutlet UIImageView *headPhoto;    // 头像
@property (nonatomic, weak) IBOutlet UILabel *userName;         // 用户名
@property (nonatomic, weak) IBOutlet UILabel *totalDistance;    // 距离

@property (nonatomic, weak) IBOutlet YSDataRecordLabelsView *labelsView;
@property (nonatomic, weak) IBOutlet UIView *bleContentView;

@property (nonatomic, strong) YSBLEHeartRateCountingView *heartRateCountingView;
@property (nonatomic, strong) YSBLEConnectingView *connectingView;
@property (nonatomic, strong) YSBLEDeviceConnectView *deviceConnectView;

@property (nonatomic, assign) YSBLEContentViewState bleContentViewState;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *labelsViewBottomToSuperViewConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *labelsViewBottomToConnectViewConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *bleContentHeightConstraint;

@end

@implementation YSUserRecordView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSUserRecordView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
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
    
    // 头像设置成圆形
    CGFloat cornerRadius = CGRectGetWidth(self.headPhoto.frame) / 2;
    self.headPhoto.layer.cornerRadius = cornerRadius;
    self.headPhoto.clipsToBounds = YES;
    
    [self addGesture];
    
    // 设置字体
    self.totalDistance.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:ActualFontSize(130)];
    self.totalDistance.adjustsFontSizeToFitWidth = YES;
    
    [self setBLEContentWithState:YSBLEContentViewStateDeviceConnect];
    
    if ([YSDevice isPhone6Plus])
    {
        self.bleContentHeightConstraint.constant = 52;
    }
}

- (void)layoutSubviews
{
    [self addBackgroundView];
}

- (void)setUserName:(NSString *)userName
          headPhoto:(UIImage *)headPhoto
      totalDistance:(CGFloat)distance
      totalRunTimes:(NSInteger)runTimes
          totalTime:(NSInteger)time
{
    self.userName.text = userName;
    self.headPhoto.image = headPhoto;
    
    NSString *countText = [NSString stringWithFormat:@"%@", @(runTimes)];
    [self.labelsView setCountLabelWithText:countText];
    
    NSString *timeText = [NSString stringWithFormat:@"%@", @(time)];
    [self.labelsView setTimeLabelWithText:timeText];
    
    self.totalDistance.text = [NSString stringWithFormat:@"%.2f", distance];
}

- (void)addGesture
{
    // 加上点击手势，点击头像和昵称区域为用户登录或设置用户头像
    
    self.headPhoto.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.headPhoto addGestureRecognizer:tap1];
    
    self.userName.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.userName addGestureRecognizer:tap2];
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    [self.delegate tapUserHead];
}

- (void)addBackgroundView
{
    // 添加背景图片
    
    if ([self.backgroundImageView superview])
    {
        [self.backgroundImageView removeFromSuperview];
    }
    
    CGRect frame = self.bounds;
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:frame];
    
    UIImage *image = [UIImage imageNamed:@"background_image2.png"];
    
    // 重绘图片，确保图片能至上而下显示。
//    CGSize size = frame.size;
//    UIGraphicsBeginImageContext(size);
//    
//    CGFloat originWidth = image.size.width;
//    CGFloat originHeight = image.size.height;
//    CGFloat scale = size.width / originWidth;
//    
//    [image drawInRect:CGRectMake(0, 0, originWidth * scale, originHeight * scale)];
//    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    self.backgroundImageView.image = image;
    self.backgroundImageView.contentMode = UIViewContentModeTop;
    self.backgroundImageView.clipsToBounds = YES;
    
    [self addSubview:self.backgroundImageView];
    [self sendSubviewToBack:self.backgroundImageView];
}

- (void)updateHeartRateWithValue:(NSInteger)heartRate
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        NSString *text = (heartRate > 0) ? [NSString stringWithFormat:@"%@", @(heartRate)] : @"-";
        [self.labelsView setHeartRateLabelWithText:text];
        [self.heartRateCountingView updateWithHeartRate:heartRate];
    });
}

- (void)setBLEContentWithState:(YSBLEContentViewState)state
{
    self.bleContentViewState = state;
    for (UIView *view in [self.bleContentView subviews])
    {
        [view removeFromSuperview];
    }
    
    if ((state != YSBLEContentViewStateConnecting) && self.connectingView)
    {
        [self.connectingView connectingEnd];
    }
    
    switch (state)
    {
        case YSBLEContentViewStateDeviceConnect:
        {
            if (!self.deviceConnectView)
            {
                self.deviceConnectView = [[[UINib nibWithNibName:@"YSBLEDeviceConnectView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
                self.deviceConnectView.delegate = self;
            }
            self.deviceConnectView.frame = self.bleContentView.bounds;
            [self.bleContentView addSubview:self.deviceConnectView];
        }
            break;
            
        case YSBLEContentViewStateConnecting:
        {
            if (!self.connectingView)
            {
                self.connectingView = [[[UINib nibWithNibName:@"YSBLEConnectingView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
            }
            self.connectingView.frame = self.bleContentView.bounds;
            [self.connectingView showConnecting];
            [self.bleContentView addSubview:self.connectingView];
        }
            break;
            
        case YSBLEContentViewStateHeartRateCounting:
        {
            if (!self.heartRateCountingView)
            {
                self.heartRateCountingView = [[[UINib nibWithNibName:@"YSBLEHeartRateCountingView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
            }
            self.heartRateCountingView.frame = self.bleContentView.bounds;
            [self.bleContentView addSubview:self.heartRateCountingView];
        }
            break;
            
        default:
            break;
    }
}

- (void)setBLEContentViewHidden:(BOOL)hidden
{
    self.bleContentView.hidden = hidden;
    if (hidden)
    {
        self.labelsViewBottomToConnectViewConstraint.active = NO;
        self.labelsViewBottomToSuperViewConstraint.active = YES;
    }
    else
    {
        self.labelsViewBottomToSuperViewConstraint.active = NO;
        self.labelsViewBottomToConnectViewConstraint.active = YES;
    }
}

#pragma mark - YSBLEDeviceConnectViewDelegate

- (void)BLEDeviceConnect
{
    [self.delegate touchBLEConnectButton];
}

@end
