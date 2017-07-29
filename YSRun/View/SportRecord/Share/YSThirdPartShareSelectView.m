//
//  YSThirdPartShareView.m
//  YSRun
//
//  Created by moshuqi on 16/1/29.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSThirdPartShareSelectView.h"
#import "YSAppMacro.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

@interface YSThirdPartShareSelectView ()

@property (nonatomic, strong) NSMutableArray *shareButtons;

@end

@implementation YSThirdPartShareSelectView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    UIColor *color = RGB(86, 86, 86);
    self.backgroundColor = color;
    
    self.shareButtons = [self shareButtons];
//    if ([self.shareButtons count] > 0)
//    {
//        for (UIButton *btn in self.shareButtons)
//        {
//            [self addSubview:btn];
//            NSLog(@"");
//        }
//    }
}

- (void)layoutSubviews
{
    [self resetButtonsFrame];
}

- (NSMutableArray *)shareButtons
{
    NSMutableArray *buttons = [NSMutableArray array];
    
    if ([ShareSDK isClientInstalled:SSDKPlatformTypeWechat])
    {
        // 微信朋友圈、好友
        UIImage *circleOfFriendsImage = [UIImage imageNamed:@"wxShareImage2"];
        UIButton *circleOfFriendsBtn = [self createButtonWithImage:circleOfFriendsImage action:@selector(shareToCircleOfFriends)];
        [buttons addObject:circleOfFriendsBtn];
        
        UIImage *weixinFriendsImage = [UIImage imageNamed:@"wxShareImage1"];
        UIButton *weixinFriendsBtn = [self createButtonWithImage:weixinFriendsImage action:@selector(shareToWeixinFriends)];
        [buttons addObject:weixinFriendsBtn];
    }
    
    if ([ShareSDK isClientInstalled:SSDKPlatformTypeSinaWeibo])
    {
        // 新浪微博
        UIImage *weiboImage = [UIImage imageNamed:@"weiboShareImage"];
        UIButton *weiboBtn = [self createButtonWithImage:weiboImage action:@selector(shareToWeibo)];
        [buttons addObject:weiboBtn];
    }
    
    if ([ShareSDK isClientInstalled:SSDKPlatformTypeQQ])
    {
        // QQ空间、好友
        UIImage *qZoneImage = [UIImage imageNamed:@"qzoneShareImage"];
        UIButton *qZoneBtn = [self createButtonWithImage:qZoneImage action:@selector(shareToQZone)];
        [buttons addObject:qZoneBtn];
        
        UIImage *qqFriendsImage = [UIImage imageNamed:@"qqShareImage"];
        UIButton *qqFriendsBtn = [self createButtonWithImage:qqFriendsImage action:@selector(shareToQQFrineds)];
        [buttons addObject:qqFriendsBtn];
    }
    
    return buttons;
}

- (UIButton *)createButtonWithImage:(UIImage *)image action:(SEL)action
{
    // 通过图标和对应方法创建按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)resetButtonsFrame
{
    // 重置按钮frame
    NSInteger count = [self.shareButtons count];
    if (count > 0)
    {
        CGFloat buttonHeight = CGRectGetHeight(self.frame);
        CGFloat buttonWidth = buttonHeight;
        
        CGFloat width = CGRectGetWidth(self.frame);
        CGFloat totalWidth = buttonWidth * count;
        if (totalWidth > width)
        {
            totalWidth = width;
            buttonWidth = totalWidth / count;
        }
        
        CGFloat distance = (CGRectGetWidth(self.frame) - totalWidth) / 2;   // 按钮距离两边边缘的间距
        
        CGFloat x = distance;
        for (NSInteger i = 0; i < count; i++)
        {
            CGRect btnFrame = CGRectMake(x + i * buttonWidth, 0, buttonWidth, buttonHeight);
            UIButton *btn = self.shareButtons[i];
            btn.frame = btnFrame;
            
            // self.shareButtons通过下标取出的值赋给btn貌似为深拷贝。将来有机会再研究了。。
            [self addSubview:btn];
        }
    }
}

// 暂时有5种分享方式

- (void)shareToCircleOfFriends
{
    // 微信朋友圈
    [self.delegate shareType:YSShareSelectTypeWXCircleOfFriends];
}

- (void)shareToWeixinFriends
{
    // 微信好友
    [self.delegate shareType:YSShareSelectTypeWXFriends];
}

- (void)shareToWeibo
{
    // 新浪微博
    [self.delegate shareType:YSShareSelectTypeSinaWeibo];
}

- (void)shareToQQFrineds
{
    // QQ好友
    [self.delegate shareType:YSShareSelectTypeQQFriends];
}

- (void)shareToQZone
{
    // QQ空间
    [self.delegate shareType:YSShareSelectTypeQQZone];
}


@end
