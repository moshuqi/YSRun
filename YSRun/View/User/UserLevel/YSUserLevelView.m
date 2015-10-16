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

@interface YSUserLevelView ()

@property (nonatomic, weak) IBOutlet UIImageView *userPhoto;
@property (nonatomic, weak) IBOutlet UILabel *userName;
@property (nonatomic, weak) IBOutlet UIButton *setButton;

@property (nonatomic, weak) IBOutlet UILabel *encourageLabel;
@property (nonatomic, weak) IBOutlet UIView *progressContentView;

@property (nonatomic, strong) UILabel *rankLabel;
@property (nonatomic, strong) UILabel *levelLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) YSCicularProgressView *cicularProgress;

@end

@implementation YSUserLevelView

- (void)awakeFromNib
{
    [self setupSubviewsBackgroundColor];
}

- (void)layoutSubviews
{
    [self addBackgroundView];
    [self addProgress];
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
    self.cicularProgress.backgroundColor = [UIColor clearColor];
    self.levelLabel.backgroundColor = [UIColor clearColor];
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
    
    UIImage *image = [UIImage imageNamed:@"backgound_image1.png"];
    self.backgroundImageView.image = image;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.clipsToBounds = YES;
    
    UIView *maskView = [[UIView alloc] initWithFrame:frame];
    maskView.backgroundColor = RGBA(4, 181, 108 ,0.6);
    [self.backgroundImageView addSubview:maskView];
    
    [self addSubview:self.backgroundImageView];
    [self sendSubviewToBack:self.backgroundImageView];
}

- (void)addProgress
{
    if ([self.cicularProgress superview])
    {
        [self.cicularProgress removeFromSuperview];
    }
    
    CGRect frame = self.progressContentView.bounds;
    self.cicularProgress = [[YSCicularProgressView alloc] initWithFrame:frame];
    self.cicularProgress.backgroundColor = [UIColor clearColor];
    
    [self.progressContentView addSubview:self.cicularProgress];
    [self.progressContentView sendSubviewToBack:self.cicularProgress];
    
    [self.cicularProgress animationToProgress:0.7];
}

- (void)setupWithUserInfo:(YSUserInfoModel *)userInfoModel
{
    
}

@end
