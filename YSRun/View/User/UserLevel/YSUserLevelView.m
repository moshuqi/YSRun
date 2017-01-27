//
//  YSUserLevelView.m
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSUserLevelView.h"
#import "YSCicularProgressView.h"
#import "YSAppMacro.h"
#import "YSUserInfoModel.h"
#import "YSDevice.h"
#import "YSWaveProgressView.h"
#import "YSMedalView.h"

@interface YSUserLevelView ()

@property (nonatomic, weak) IBOutlet UIImageView *userPhoto;
@property (nonatomic, weak) IBOutlet UILabel *userName;
@property (nonatomic, weak) IBOutlet UIButton *setButton;

@property (nonatomic, weak) IBOutlet UILabel *encourageLabel;
@property (nonatomic, weak) IBOutlet UIView *progressContentView;
//@property (nonatomic, weak) IBOutlet UILabel *levelLabel;

@property (nonatomic, weak) IBOutlet YSWaveProgressView *waveProgressView;
@property (nonatomic, weak) IBOutlet YSMedalView *medalView;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *progressTopToSuperViewConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *progressBottomToEncourageLabelConstraint;

//@property (nonatomic, strong) UILabel *achieveLabel;

@property (nonatomic, strong) UIImageView *backgroundImageView;
//@property (nonatomic, strong) YSCicularProgressView *cicularProgress;
@property (nonatomic, assign) CGFloat progress;

@end

@implementation YSUserLevelView

- (void)awakeFromNib
{
    [self setupSubviewsBackgroundColor];
    [self addGesture];
//    [self addAchieveLabel];
    
    // 头像设置成圆形
    CGFloat cornerRadius = CGRectGetWidth(self.userPhoto.frame) / 2;
    self.userPhoto.layer.cornerRadius = cornerRadius;
    self.userPhoto.clipsToBounds = YES;
    
    self.encourageLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)layoutSubviews
{
    [self addBackgroundView];
//    [self addProgress];
//    [self resetAchieveLabelFrame];
    
    [self.waveProgressView resetWaterWaveView];
    [self.waveProgressView resetProgress:self.progress];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSUserLevelView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        containerView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:containerView];
    }
    
    return self;
}


- (void)setupSubviewsBackgroundColor
{
    // 设置子视图的背景色
    
//    self.userPhoto.layer.borderWidth = 1;
//    self.userPhoto.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.userPhoto.layer.cornerRadius = 34 / 2;
//    self.userPhoto.clipsToBounds = YES;
    
    self.userName.backgroundColor = [UIColor clearColor];
    self.progressContentView.backgroundColor = [UIColor clearColor];
//    self.cicularProgress.backgroundColor = [UIColor clearColor];
//    self.levelLabel.backgroundColor = [UIColor clearColor];
    self.encourageLabel.backgroundColor = RGBA(4, 181, 108, 0.7);
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

- (void)addGesture
{
    // 头像和标签添加手势响应
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadPhoto:)];
    tapGesture1.numberOfTapsRequired = 1;
    
    self.userPhoto.userInteractionEnabled = YES;
    [self.userPhoto addGestureRecognizer:tapGesture1];
    
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadPhoto:)];
    tapGesture2.numberOfTapsRequired = 1;
    
    self.userName.userInteractionEnabled = YES;
    [self.userName addGestureRecognizer:tapGesture2];
}

- (void)tapHeadPhoto:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        // 点击头像，未登录时跳转到登录页面，已登录时则设置头像。
        if ([self.delegate loginState])
        {
            [self.delegate headPhotoChange];
        }
        else
        {
            [self.delegate toLogin];
        }
    }
}

/*
- (void)addProgress
{
    if ([self.cicularProgress superview])
    {
        [self.cicularProgress removeFromSuperview];
    }
    
    CGRect frame = self.progressContentView.bounds;
    CGFloat lineWidth = 15;
    if ([YSDevice isPhone6Plus])
    {
        lineWidth = 20;
        self.progressBottomToEncourageLabelConstraint.constant = 30;
        self.progressTopToSuperViewConstraint.constant = 60;
    }
    
    self.cicularProgress = [[YSCicularProgressView alloc] initWithFrame:frame lineWidth:lineWidth];
    self.cicularProgress.backgroundColor = [UIColor clearColor];
    
    [self.progressContentView addSubview:self.cicularProgress];
    [self.progressContentView sendSubviewToBack:self.cicularProgress];
    
    [self.cicularProgress animationToProgress:self.progress];
}

- (void)addAchieveLabel
{
    CGFloat labelWidth = 88;
    CGFloat labelHeight = 22;
    
    CGRect frame = CGRectMake(0, 0, labelWidth, labelHeight);
    self.achieveLabel = [[UILabel alloc] initWithFrame:frame];
    
    self.achieveLabel.textColor = [UIColor whiteColor];
    self.achieveLabel.backgroundColor = [UIColor redColor];
    self.achieveLabel.font = [UIFont systemFontOfSize:15];
    self.achieveLabel.textAlignment = NSTextAlignmentCenter;
    
    self.achieveLabel.layer.cornerRadius = 8;
    self.achieveLabel.clipsToBounds = YES;
    [self addSubview:self.achieveLabel];
}

- (void)resetAchieveLabelFrame
{
    CGPoint point = [self.cicularProgress getGapPoint];
    point = [self convertPoint:point fromView:self.cicularProgress];
    
    // 微调一下
    point.y -= 3;
    
    self.achieveLabel.center = point;
}
 */

- (void)setUserName:(NSString *)userName
          headPhoto:(UIImage *)headPhoto
              grade:(NSInteger)grade
       achieveTitle:(NSString *)achieveTitle
           progress:(CGFloat)progress
upgradeRequireTimes:(NSInteger)upgradeRequireTimes
{
    self.userName.text = userName;
    self.userPhoto.image = headPhoto;
//    self.levelLabel.text = [NSString stringWithFormat:@"%@", @(grade)];
    
    NSString *encourageText = [NSString stringWithFormat:@"%@坚持一定会有收获", (upgradeRequireTimes > 0) ? [NSString stringWithFormat:@"还需%@次跑步记录即可升级，", @(upgradeRequireTimes)] : @""];
    self.encourageLabel.text = encourageText;
    
//    self.achieveLabel.text = achieveTitle;
//
//    [self.cicularProgress animationToProgress:self.progress];
    
    self.progress = progress;
    [self.waveProgressView setupWithLevel:grade title:achieveTitle grogressPercent:self.progress];
    
    [self.medalView setMedalLevel:2];
}

- (void)setHeadPhoto:(UIImage *)photo
{
    self.userPhoto.image = photo;
}

@end
