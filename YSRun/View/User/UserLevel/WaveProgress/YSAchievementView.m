//
//  YSAchievementView.m
//  YSRun
//
//  Created by moshuqi on 16/1/11.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSAchievementView.h"

@interface YSAchievementView ()

@property (nonatomic, weak) IBOutlet UILabel *levelLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger level;

@end

@implementation YSAchievementView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSAchievementView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        containerView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:containerView];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setupWithLevel:(NSInteger)level title:(NSString *)title
{
    if ((self.level == level) && ([self.title compare:title] == NSOrderedSame))
    {
        return;
    }
    
    self.level = level;
    self.title = title;
    
    CGFloat prefixFont = 15;
    CGFloat levelFont = 45;
    
    NSString *prefixStr = [self levelPrefixStr];
    NSInteger prefixLength = [prefixStr length];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", prefixStr, @(level)]];
    NSInteger length = [str length];
    
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:prefixFont] range:NSMakeRange(0, prefixLength)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:levelFont] range:NSMakeRange(prefixLength, length - prefixLength)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,length)];
    
    self.levelLabel.attributedText = str;
    self.levelLabel.adjustsFontSizeToFitWidth = YES;
    
    self.titleLabel.text = title;
}

- (NSString *)levelPrefixStr
{
    return @"Lv.";
}

@end
