//
//  YSUserRecordView.m
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSUserRecordView.h"
#import "YSAppMacro.h"

@interface YSUserRecordView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

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

- (void)layoutSubviews
{
    [self addBackgroundView];
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


@end
