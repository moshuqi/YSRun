//
//  YSBLEDeviceConnectView.m
//  YSRun
//
//  Created by moshuqi on 15/11/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSBLEDeviceConnectView.h"
#import "YSAppMacro.h"

@interface YSBLEDeviceConnectView ()

@property (nonatomic, weak) IBOutlet UIButton *connectDeviceButton;

@end

@implementation YSBLEDeviceConnectView

- (void)awakeFromNib
{
    UIFont *font = [UIFont systemFontOfSize:11];
    UIColor *textColor = RGB(201, 233, 220);
    
    [self.connectDeviceButton setTitle:@"连接心率设备" forState:UIControlStateNormal];
    [self.connectDeviceButton setTitleColor:textColor forState:UIControlStateNormal];
//    self.connectDeviceButton.titleLabel.textColor = textColor;
    
    self.connectDeviceButton.titleLabel.font = font;
    self.connectDeviceButton.backgroundColor = RGB(53, 172, 130);
    
    self.connectDeviceButton.layer.borderWidth = 1;
    self.connectDeviceButton.layer.cornerRadius = 3;
    self.connectDeviceButton.layer.borderColor = RGB(106, 200, 163).CGColor;
    
    self.backgroundColor = RGB(89, 168, 137);
}

- (IBAction)connectButtonClicked:(id)sender
{
    [self.delegate BLEDeviceConnect];
}

@end
