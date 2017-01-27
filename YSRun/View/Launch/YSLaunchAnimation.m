//
//  YSLaunchAnimation.m
//  YSRun
//
//  Created by moshuqi on 16/1/6.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSLaunchAnimation.h"
#import <UIKit/UIKit.h>
#import "YSAppMacro.h"

@interface YSLaunchAnimation ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation YSLaunchAnimation

- (void)launch
{
    [self addSubviews];
    [self animation];
}

- (void)addSubviews
{
    [self addBackground];
    [self addLogo];
}

- (void)addBackground
{
    // 添加作为背景的白色视图
    UIView *screen = [self screen];
    
    self.backgroundView = [[UIView alloc] initWithFrame:screen.bounds];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    
    [screen addSubview:self.backgroundView];
}

- (void)addLogo
{
    // 添加logo
    UIImage *logoImage = [UIImage imageNamed:@"launch_logo"];
    self.logoImageView = [[UIImageView alloc] initWithImage:logoImage];
    
    if (!self.backgroundView || ![self.backgroundView superview])
    {
        [self addBackground];
    }
    [self.backgroundView addSubview:self.logoImageView];
    
    CGSize logoSize = [self logoSize];
    CGPoint center = [self logoBeginPosition];
    
    self.logoImageView.frame = CGRectMake(0, 0, logoSize.width, logoSize.height);
    self.logoImageView.center = center;
}

- (void)animation
{
    // logo先上升移动一段距离，然后整个界面淡出，显示出主界面
    CGPoint endPoint = [self logoEndPosition];
    
    [UIView animateWithDuration:1 animations:^(){
        self.logoImageView.center = endPoint;
    }completion:^(BOOL finished){
        // 淡出的动画
        [UIView animateWithDuration:2 animations:^(){
            self.backgroundView.alpha = 0.0;
        }completion:^(BOOL finished){
            [self.backgroundView removeFromSuperview];
        }];
    }];
}

- (CGSize)logoSize
{
    CGSize size = CGSizeMake(88, 88);
    return size;
}

- (UIView *)screen
{
    return [UIApplication sharedApplication].keyWindow;
}

// logo移动的起始位置，结束位置

- (CGPoint)logoBeginPosition
{
    CGPoint position = [self positionInScreenByScale:0.4];
    return position;
}

- (CGPoint)logoEndPosition
{
    CGPoint position = [self positionInScreenByScale:0.3];
    return position;
}

- (CGPoint)positionInScreenByScale:(CGFloat)scale
{
    // 通过比例计算在屏幕中的位置，，水平为居中，0时在顶端，1时在底端。
    
    if (scale < 0)
    {
        scale = 0;
    }
    else if (scale > 1.0)
    {
        scale = 1.0;
    }
    
    UIView *screen = [self screen];
    CGFloat screenWidth = CGRectGetWidth(screen.bounds);
    CGFloat screenHeight = CGRectGetHeight(screen.bounds);
    
    CGFloat x = screenWidth / 2;
    CGFloat y = screenHeight * scale;
    
    CGPoint position = CGPointMake(x, y);
    return position;
}

@end
