//
//  YSNoHeartRateDataView.m
//  YSRun
//
//  Created by moshuqi on 16/1/27.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSNoHeartRateDataView.h"
#import "YSAppMacro.h"
#import "YSDevice.h"

@interface YSNoHeartRateDataView ()

@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *topConstraint;   // 图片距上边缘的距离

@end

@implementation YSNoHeartRateDataView

- (void)awakeFromNib
{
    self.topConstraint.constant = [self topConstant];
    
    // 提示标签设置
    self.label.text = @"您本次运动没有连接心率设备";
    self.label.textColor = RGB(138, 138, 138);
    self.label.adjustsFontSizeToFitWidth = YES;
    
    CGFloat fontSize = 18;
    if ([YSDevice isPhone6Plus])
    {
        fontSize = 22;
    }
    self.label.font = [UIFont systemFontOfSize:fontSize];
}

- (CGFloat)topConstant
{
    CGSize screenSize = [UIApplication sharedApplication].keyWindow.frame.size;
    
    CGFloat constant = screenSize.height / 6;
    return constant;
}

@end
