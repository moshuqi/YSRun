//
//  YSBLEHint.m
//  YSRun
//
//  Created by moshuqi on 15/11/23.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSBLEHint.h"
#import "YSBLEConnectHintView.h"
#import "YSBLEConnectFailureHintView.h"
#import "YSAppSettingsDefine.h"
#import "YSConfigManager.h"

@interface YSBLEHint () <UIGestureRecognizerDelegate, YSBLEConnectHintViewDelegate, YSBLEConnectFailureHintViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *hintView;

@property (nonatomic, strong) UIAlertView *bleConnectHint;
@property (nonatomic, strong) UIAlertView *bleConnectFailureHint;

@end

@implementation YSBLEHint

- (void)dealloc
{
    
}

- (void)addBackground
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.backgroundView = [[UIView alloc] initWithFrame:window.bounds];
    self.backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
    
    [window addSubview:self.backgroundView];
    [window bringSubviewToFront:self.backgroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground:)];
    tap.delegate = self;
    [self.backgroundView addGestureRecognizer:tap];
}

- (void)tapBackground:(id)UITapGestureRecognizer
{
    [self hideHint];
}

- (void)showConnectHint
{
//    self.hintView = [[[UINib nibWithNibName:@"YSBLEConnectHintView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
//    ((YSBLEConnectHintView *)self.hintView).delegate = self;
//    
//    [self showHint];
    
    if (!self.bleConnectHint)
    {
        self.bleConnectHint = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"您还没有连接任何设备，\n确认不连接直接开始跑步吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"不再提示"
                                              otherButtonTitles:@"直接跑步", @"连接设备", nil];
    }
    [self.bleConnectHint show];
}

- (void)showConnectFailureHint
{
//    self.hintView = [[[UINib nibWithNibName:@"YSBLEConnectFailureHintView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
//    ((YSBLEConnectFailureHintView *)self.hintView).delegate = self;
//    
//    [self showHint];
    
    if (!self.bleConnectFailureHint)
    {
        self.bleConnectFailureHint = [[UIAlertView alloc] initWithTitle:@"连接失败"
                                                         message:@"请确认配件电源已开启\n请确认配件在手机附近\n请确认手机蓝牙已开启"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"重新连接", nil];
    }
    [self.bleConnectFailureHint show];
}

- (void)showHint
{
    [self addBackground];
    [self.backgroundView addSubview:self.hintView];
    
    self.hintView.frame = [self getHintFrame];
}

- (void)hideHint
{
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

- (CGRect)getHintFrame
{
    CGFloat width = 250;
    CGFloat height = 160;
    
    CGPoint center = self.backgroundView.center;
    CGRect frame = CGRectMake(center.x - width / 2, center.y - height / 2, width, height);
    
    return frame;
}

#pragma mark - YSBLEConnectHintViewDelegate

- (void)connectHintClose
{
    [self hideHint];
}

- (void)connectDevice
{
    // 提示面板消失，开始连接蓝牙设备
    [self hideHint];
    [self.delegate BLEConnect];
}

- (void)startRun
{
    [self hideHint];
    [self.delegate runDirectly];
}

- (void)setConnectHintHidden:(BOOL)hidden
{
    [YSConfigManager setBLEConnectHintHidden:hidden];
}

#pragma mark - YSBLEConnectFailureHintViewDelegate

- (void)connectFailureHintBack
{
    [self hideHint];
}

- (void)connectFailureHintClose
{
    [self hideHint];
}

- (void)reConnect
{
    // 重新连接
    [self hideHint];
    [self.delegate BLEConnect];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.backgroundView];
    if (CGRectContainsPoint([self getHintFrame], point))
    {
        return NO;
    }
    
    return YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.bleConnectHint)
    {
        // 不再提示、直接跑步、连接设备
        switch (buttonIndex)
        {
            case 0:
                // 不再提示
                [YSConfigManager setBLEConnectHintHidden:YES];
                [self.delegate runDirectly];
                break;
                
            case 1:
                // 直接跑步
                [self.delegate runDirectly];
                break;
                
            case 2:
                // 连接设备
                [self.delegate BLEConnect];
                break;
                
            default:
                break;
        }
    }
    else if (alertView == self.bleConnectFailureHint)
    {
        // 重新连接、取消
        switch (buttonIndex)
        {
            case 1:
                // 重新连接
                [self.delegate BLEConnect];
                break;
                
            default:
                break;
        }
    }
}

@end
