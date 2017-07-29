//
//  YSRatingDetialView.m
//  YSRun
//
//  Created by moshuqi on 16/2/24.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSRatingDetailView.h"

@interface YSRatingDetailView ()

@property (nonatomic, weak) IBOutlet UILabel *label1;
@property (nonatomic, weak) IBOutlet UILabel *label2;

@end

@implementation YSRatingDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    CGFloat fontSize = 16;
    UIColor *color = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1.0];
    
    self.label1.font = [UIFont systemFontOfSize:fontSize];
    self.label1.textColor = color;
    
    self.label2.font = [UIFont systemFontOfSize:fontSize];
    self.label2.textColor = color;
    
    self.label1.adjustsFontSizeToFitWidth = YES;
    self.label2.adjustsFontSizeToFitWidth = YES;
}

- (void)setTextWithRating:(NSInteger)rating
{
    NSString *text1;
    NSString *text2;
    switch (rating)
    {
        case 2:
            text1 = @"1.跑步超过40分钟，脂肪得到充分燃烧";
            text2 = @"2.不要跑太快，心率保持在140-160之间";
            break;
            
        case 3:
            text1 = @"1.跑步超过40分钟，脂肪得到充分燃烧";
            text2 = @"2.心率保持在140-160之间，燃脂效果显著";
            break;
            
        default:
            text1 = @"1.跑步不足40分钟，脂肪得不到充分燃烧";
            text2 = @"2.不要跑太快，心率保持在140-160之间";
            break;
    }
    
    self.label1.text = text1;
    self.label2.text = text2;
}

@end
