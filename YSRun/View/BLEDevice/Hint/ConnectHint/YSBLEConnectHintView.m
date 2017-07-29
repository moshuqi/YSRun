//
//  YSBLEConnectHintView.m
//  YSRun
//
//  Created by moshuqi on 15/11/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSBLEConnectHintView.h"
#import "YSAppMacro.h"

@interface YSBLEConnectHintView ()

@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@property (nonatomic, weak) IBOutlet UIButton *connectDeviceButton;
@property (nonatomic, weak) IBOutlet UIButton *directRunButton;
@property (nonatomic, weak) IBOutlet UIButton *noPromptButton;

@property (nonatomic, weak) IBOutlet UILabel *promptLabel;
@property (nonatomic, weak) IBOutlet UILabel *checkboxLabel;

@end

@implementation YSBLEConnectHintView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // 设置控件参数
    
    UIImage *closeImage = [UIImage imageNamed:@"close"];
    [self.closeButton setImage:closeImage forState:UIControlStateNormal];
    
    UIColor *greenColor = GreenBackgroundColor;
    CGFloat cornerRadius = 5;
    
    // ”连接设备“按钮
    [self.connectDeviceButton setTitle:@"连接设备" forState:UIControlStateNormal];
    [self.connectDeviceButton setTitleColor:greenColor forState:UIControlStateNormal];
    
    self.connectDeviceButton.layer.cornerRadius = cornerRadius;
    self.connectDeviceButton.clipsToBounds = YES;
    self.connectDeviceButton.layer.borderWidth = 1;
    self.connectDeviceButton.layer.borderColor = greenColor.CGColor;
    
    // ”直接跑步“按钮
    [self.directRunButton setTitle:@"直接跑步" forState:UIControlStateNormal];
    [self.directRunButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.directRunButton.backgroundColor = greenColor;
    
    self.directRunButton.layer.cornerRadius = cornerRadius;
    self.directRunButton.clipsToBounds = YES;
    
    // 不再提示的复选框用按钮展示
    UIImage *image = [UIImage imageNamed:@"prompt_checkbox"];
    UIImage *selectedImage = [UIImage imageNamed:@"prompt_checkbox_selected"];
    
    [self.noPromptButton setImage:image forState:UIControlStateNormal];
    [self.noPromptButton setImage:selectedImage forState:UIControlStateSelected];
    
    // 标签设置
    UIColor *textColor = RGB(100, 100, 100);
    
    self.promptLabel.text = @"您还没有连接任何设备，确认不连接直接开始跑步吗？";
    self.promptLabel.numberOfLines = 0;
    self.promptLabel.textColor = textColor;
    self.promptLabel.font = [UIFont systemFontOfSize:12];
    
    self.checkboxLabel.text = @"不再提示";
    self.checkboxLabel.textColor = textColor;
    self.checkboxLabel.font = [UIFont systemFontOfSize:10];
}

- (IBAction)close:(id)sender
{
    [self.delegate connectHintClose];
}

- (IBAction)connect:(id)sender
{
    [self.delegate connectDevice];
}

- (IBAction)run:(id)sender
{
    [self.delegate startRun];
}

- (IBAction)noPrompt:(id)sender
{
    self.noPromptButton.selected = !self.noPromptButton.selected;
    [self.delegate setConnectHintHidden:self.noPromptButton.selected];
}

@end
