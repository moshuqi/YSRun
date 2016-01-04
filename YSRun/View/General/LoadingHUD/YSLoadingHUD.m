//
//  YSLoadingHUD.m
//  YSRun
//
//  Created by moshuqi on 15/12/14.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSLoadingHUD.h"
#import <UIKit/UIKit.h>
#import "ProgressHUD.h"

@interface YSLoadingHUD ()

@property (nonatomic, strong) UIView *maskView;     // 用来遮住整个界面的透明视图，为了不让其他视图接受点击事件

@end

@implementation YSLoadingHUD

static YSLoadingHUD *_instance;

+ (id)allocWithZone:(struct _NSZone *)zone
{
    //调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)shareLoadingHUD
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YSLoadingHUD alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (void)show
{
    // 显示加载动画，请求结果回调时记得取消加载动画
    UIView *window = [self getWindow];
    if (!self.maskView)
    {
        self.maskView = [UIView new];
        self.maskView.backgroundColor = [UIColor clearColor];
    }
    
    if ([self.maskView superview])
    {
        [self.maskView removeFromSuperview];
    }
    
    self.maskView.frame = window.bounds;
    [window addSubview:self.maskView];
    [window bringSubviewToFront:self.maskView];
    
    [ProgressHUD show:nil];
}

- (void)dismiss
{
    [self.maskView removeFromSuperview];
    
    [ProgressHUD dismiss];
}

- (UIView *)getWindow
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    return window;
}

@end
