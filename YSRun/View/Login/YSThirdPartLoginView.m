//
//  YSThirdPartLoginView.m
//  YSRun
//
//  Created by moshuqi on 16/1/5.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSThirdPartLoginView.h"
#import "YSShareFunc.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

#import "YSAppMacro.h"

@interface YSThirdPartLoginView ()

@end

@implementation YSThirdPartLoginView

static const CGFloat kTitleHeight = 32.0;

//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super initWithCoder:aDecoder])
//    {
//        
//    }
//    
//    return self;
//}

- (void)setupSubViews
{
    // 按微信、QQ、新浪微博的顺序显示按钮，按钮数量不足3个时，居中显示，没有按钮时，该视图隐藏不显示。
    NSArray *buttons = [self loginButtons];
    NSInteger count = [buttons count];
    if (count < 1)
    {
        self.hidden = YES;
        return;
    }
    
    [self setupTitleLabel];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGSize size = [self loginButtonSize];
    if (count == 1)
    {
        UIButton *button = [buttons firstObject];
        
        CGFloat originX = (width - size.width) / 2;
        button.frame = CGRectMake(originX, kTitleHeight, size.width, size.height);
        
        [self addSubview:button];
    }
    else if (count == 2)
    {
        UIButton *button0 = buttons[0];
        UIButton *button1 = buttons[1];
        CGFloat distance = (width - size.width * 2) / 3;
        
        CGFloat originX0 = distance;
        CGFloat originX1 = distance * 2 + size.width;
        
        button0.frame = CGRectMake(originX0, kTitleHeight, size.width, size.height);
        button1.frame = CGRectMake(originX1, kTitleHeight, size.width, size.height);
        
        [self addSubview:button0];
        [self addSubview:button1];
    }
    else if (count == 3)
    {
        UIButton *button0 = buttons[0];
        UIButton *button1 = buttons[1];
        UIButton *button2 = buttons[2];
        CGFloat distance = (width - size.width * 3) / 2;
        
        CGFloat originX0 = 0;
        CGFloat originX1 = distance + size.width;
        CGFloat originX2 = (distance + size.width) * 2;
        
        button0.frame = CGRectMake(originX0, kTitleHeight, size.width, size.height);
        button1.frame = CGRectMake(originX1, kTitleHeight, size.width, size.height);
        button2.frame = CGRectMake(originX2, kTitleHeight, size.width, size.height);
        
        [self addSubview:button0];
        [self addSubview:button1];
        [self addSubview:button2];
    }
}

- (void)setupTitleLabel
{
    CGRect labelFrame = CGRectMake(0, 0, CGRectGetWidth(self.frame), kTitleHeight);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    
    label.text = @"其他账号登陆";
    label.textColor = GreenBackgroundColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    label.adjustsFontSizeToFitWidth = YES;
    
    [self addSubview:label];
}

- (NSArray *)loginButtons
{
    NSMutableArray *buttons = [NSMutableArray array];
    
    CGSize size = [self loginButtonSize];
    CGRect buttonFrame = CGRectMake(0, 0, size.width, size.height);
    
    if ([ShareSDK isClientInstalled:SSDKPlatformTypeWechat])
    {
        UIImage *wechatIcon = [UIImage imageNamed:@"wechat_login"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = buttonFrame;
        
        [button setImage:wechatIcon forState:UIControlStateNormal];
        [button addTarget:self action:@selector(wechatLogin) forControlEvents:UIControlEventTouchUpInside];
        
        [buttons addObject:button];
    }
    
    if ([ShareSDK isClientInstalled:SSDKPlatformTypeSinaWeibo])
    {
        UIImage *weiboIcon = [UIImage imageNamed:@"weibo_login"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = buttonFrame;
        
        [button setImage:weiboIcon forState:UIControlStateNormal];
        [button addTarget:self action:@selector(weiboLogin) forControlEvents:UIControlEventTouchUpInside];
        
        [buttons addObject:button];
    }
    
    if ([ShareSDK isClientInstalled:SSDKPlatformTypeQQ])
    {
        UIImage *qqIcon = [UIImage imageNamed:@"qq_login"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = buttonFrame;
        
        [button setImage:qqIcon forState:UIControlStateNormal];
        [button addTarget:self action:@selector(qqLogin) forControlEvents:UIControlEventTouchUpInside];
        
        [buttons addObject:button];
    }
    
    return buttons;
}

- (CGSize)loginButtonSize
{
    CGFloat buttonHeight = CGRectGetHeight(self.frame) - kTitleHeight;
    CGFloat buttonWidth = buttonHeight;
    
    CGSize size = CGSizeMake(buttonWidth, buttonHeight);
    return size;
}

- (void)qqLogin
{
    [self thirdPartLoginByPlatform:SSDKPlatformTypeQQ];
}

- (void)wechatLogin
{
    [self thirdPartLoginByPlatform:SSDKPlatformTypeWechat];
}

- (void)weiboLogin
{
    [self thirdPartLoginByPlatform:SSDKPlatformTypeSinaWeibo];
}

- (void)thirdPartLoginByPlatform:(SSDKPlatformType)platform
{
    // 登录之后的回调
    ThirdPartLoginCallbackBlock callback = ^(YSShareFuncResponseState state, YSThirdPartLoginResponseModel* responseModel)
    {
        if (state == YSShareFuncResponseStateSuccess)
        {
            // 登录成功
            [self.delegate thirdPartLoginSuccessWithResponseModel:responseModel];
        }
        else
        {
            // 登录失败
            [self.delegate thirdPartLoginFailureWithMessage:@"登录失败"];
        }
    };
    
    [YSShareFunc thirdPartLoginByPlatform:platform callbackBlock:callback];
}

@end
