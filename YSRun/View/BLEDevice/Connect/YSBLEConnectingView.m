//
//  YSBLEConnectingView.m
//  YSRun
//
//  Created by moshuqi on 15/11/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSBLEConnectingView.h"
#import "YSLoadingDotView.h"
#import "YSAppMacro.h"

@interface YSBLEConnectingView ()

@property (nonatomic, weak) IBOutlet YSLoadingDotView *loadingDotView;
@property (nonatomic, weak) IBOutlet UILabel *label;

@end

@implementation YSBLEConnectingView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.label.text = @"正在连接";
    self.label.font = [UIFont systemFontOfSize:11];
    self.label.textColor = RGB(255, 255, 255);
    
    self.backgroundColor = RGB(89, 168, 137);
}

- (void)showConnecting
{
    [self.loadingDotView loading];
}

- (void)connectingEnd
{
    // 将NSTimer清除
    [self.loadingDotView loadingFinish];
}

@end
