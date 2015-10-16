//
//  YSUserSetCell.m
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSUserSetCell.h"
#import "YSAppMacro.h"

@interface YSUserSetCell ()

@property (nonatomic, weak) IBOutlet UILabel *leftLabel;
@property (nonatomic, weak) IBOutlet UILabel *centerLabel;
@property (nonatomic, weak) IBOutlet UILabel *rightLabel;

@end

@implementation YSUserSetCell

- (void)awakeFromNib {
    // Initialization code
    
    self.leftLabel.textColor = RGB(56, 56, 56);
    self.centerLabel.textColor = RGB(56, 56, 56);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithType:(YSUserSetCellType)type
{
    [self resetLabelsHiddenStateWithType:type];
    
    switch (type) {
        case YSUserSetCellTypeNickname:
            self.leftLabel.text = @"我的昵称";
            self.rightLabel.text = [self getUserName];
            self.rightLabel.textColor = GreenBackgroundColor;
            break;
            
        case YSUserSetCellTypeModifyPassword:
            self.leftLabel.text = @"修改密码";
            break;
            
        case YSUserSetCellTypeMeasure:
            self.leftLabel.text = @"单位";
            self.rightLabel.text = @"公里，公斤，°C";
            self.rightLabel.textColor = RGB(136, 136, 136);
            break;
            
        case YSUserSetCellTypeLogout:
            self.centerLabel.text = @"退出登录";
            break;
            
        default:
            break;
    }
}

- (void)resetLabelsHiddenStateWithType:(YSUserSetCellType)type
{
    self.type = type;
    BOOL isLogoutType = (type == YSUserSetCellTypeLogout);
    
    self.leftLabel.hidden = isLogoutType;
    self.centerLabel.hidden = !isLogoutType;
    
    if (!isLogoutType && (type != YSUserSetCellTypeModifyPassword))
    {
        self.rightLabel.hidden = NO;
    }
    else
    {
        self.rightLabel.hidden = YES;
    }
}

- (NSString *)getUserName
{
    return @"moshuqi";
}

@end
