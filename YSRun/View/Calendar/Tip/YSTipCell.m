//
//  YSTipCell.m
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSTipCell.h"
#import "YSAppMacro.h"

@interface YSTipCell ()

@property (nonatomic, weak) IBOutlet UILabel *tipLabel;
@property (nonatomic, weak) IBOutlet UILabel *tipDetailLabel;

@end

@implementation YSTipCell

- (void)awakeFromNib {
    // Initialization code
    
    [self setupLabels];
}

- (void)setupLabels
{
    // 设置标签字体颜色和大小
    
    self.tipLabel.textColor = RGB(56, 56, 56);
    self.tipDetailLabel.textColor = RGB(136, 136, 136);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithTip:(NSString *)tip tipDetail:(NSString *)detail
{
    self.tipLabel.text = tip;
    self.tipDetailLabel.text = detail;
}

@end
