//
//  YSUserSetCell.m
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSUserSetCell.h"
#import "YSAppMacro.h"

@interface YSUserSetCell () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UILabel *leftLabel;
@property (nonatomic, weak) IBOutlet UILabel *centerLabel;
@property (nonatomic, weak) IBOutlet UILabel *rightLabel;

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UISwitch *heartRateSwitch;
@property (nonatomic, copy) NSString *originalText;

@end

@implementation YSUserSetCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.leftLabel.textColor = RGB(56, 56, 56);
    self.centerLabel.textColor = RGB(56, 56, 56);
    self.rightLabel.textColor = RGB(136, 136, 136);
    
    self.textField.delegate = self;
    self.textField.textColor = GreenBackgroundColor;
    self.textField.returnKeyType = UIReturnKeyDone;
    
    [self.heartRateSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)switchAction:(UISwitch *)switchControl
{
    if ([self.delegate respondsToSelector:@selector(switchStateChanged:)])
    {
        [self.delegate switchStateChanged:switchControl];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCellWithLeftText:(NSString *)leftText
                   centerText:(NSString *)centerText
                    rightText:(NSString *)rightText
                textFieldText:(NSString *)fieldText
                switchVisible:(BOOL)switchVisible
{
    [self setupLabel:self.leftLabel text:leftText];
    [self setupLabel:self.centerLabel text:centerText];
    [self setupLabel:self.rightLabel text:rightText];
    
    self.textField.hidden = !fieldText;
    self.textField.text = fieldText;
    
    self.heartRateSwitch.hidden = !switchVisible;
}

- (void)setupLabel:(UILabel *)label text:(NSString *)text
{
    // 根据文本内容来设置标签，无内容则标签隐藏
    label.hidden = !text;
    label.text = text;
}

- (void)setSwitchOn:(BOOL)isOn
{
    self.heartRateSwitch.on = isOn;
}

#pragma mark UITextFieldDelegate 

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.originalText = textField.text;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *newName = textField.text;
    if (![self.originalText isEqualToString:newName])
    {
        if ([self.delegate respondsToSelector:@selector(textFieldTextChange:)])
        {
            [self.delegate textFieldTextChange:newName];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
