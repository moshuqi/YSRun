//
//  YSBLEConnectFailureHintView.m
//  YSRun
//
//  Created by moshuqi on 15/11/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSBLEConnectFailureHintView.h"
#import "YSAppMacro.h"

@interface YSBLEConnectFailureHintView ()

@property (nonatomic, weak) IBOutlet UIButton *returnButton;
@property (nonatomic, weak) IBOutlet UIButton *reConnectButton;
@property (nonatomic, weak) IBOutlet UIButton *closeButton;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;

@end

@implementation YSBLEConnectFailureHintView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // 设置控件
    
    // 标签
    UIColor *textColor = RGB(100, 100, 100);
    
    self.titleLabel.text = @"连接失败";
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = textColor;
    
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.text = @"请确认配件电源已开启\n请确认配件在手机附近\n请确认手机蓝牙已开启";
    self.messageLabel.font = [UIFont systemFontOfSize:12];
    self.messageLabel.textColor = textColor;
    
    // 按钮
    UIImage *closeImage = [UIImage imageNamed:@"close"];
    [self.closeButton setImage:closeImage forState:UIControlStateNormal];
    
    UIColor *greenColor = GreenBackgroundColor;
    CGFloat cornerRadius = 5;
    
    // ”返回“按钮
    [self.returnButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.returnButton setTitleColor:greenColor forState:UIControlStateNormal];
    
    self.returnButton.layer.cornerRadius = cornerRadius;
    self.returnButton.clipsToBounds = YES;
    self.returnButton.layer.borderWidth = 1;
    self.returnButton.layer.borderColor = greenColor.CGColor;
    
    // ”重新连接“按钮
    [self.reConnectButton setTitle:@"重新连接" forState:UIControlStateNormal];
    [self.reConnectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.reConnectButton.backgroundColor = greenColor;
    
    self.reConnectButton.layer.cornerRadius = cornerRadius;
    self.reConnectButton.clipsToBounds = YES;
}

- (IBAction)close:(id)sender
{
    [self.delegate connectFailureHintClose];
}

- (IBAction)back:(id)sender
{
    [self.delegate connectFailureHintBack];
}

- (IBAction)reConnect:(id)sender
{
    [self.delegate reConnect];
}

@end
