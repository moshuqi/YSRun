//
//  YSSubscriptLabel.m
//  YSRun
//
//  Created by moshuqi on 15/10/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSSubscriptLabel.h"

@interface YSSubscriptLabel ()

@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UILabel *subscriptNameLabel;

@end

@implementation YSSubscriptLabel

- (void)awakeFromNib
{
    self.contentLabel.adjustsFontSizeToFitWidth = YES;
    self.subscriptNameLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setContentText:(NSString *)text
{
    self.contentLabel.text = text;
}

- (void)setSubscriptText:(NSString *)text
{
    self.subscriptNameLabel.text = text;
}

- (void)setContentFontSize:(CGFloat)size
{
    self.contentLabel.font = [UIFont systemFontOfSize:size];
}

- (void)setSubscriptFontSize:(CGFloat)size
{
    self.subscriptNameLabel.font = [UIFont systemFontOfSize:size];
}

- (void)setTextColor:(UIColor *)color
{
    // 设置标签的字体颜色
    self.contentLabel.textColor = color;
    self.subscriptNameLabel.textColor = color;
}

- (void)setContentBoldWithFontSize:(CGFloat)size
{
    self.contentLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:size];
}

@end
