//
//  YSHeartRateScopeTipView.m
//  YSRun
//
//  Created by moshuqi on 15/12/10.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSHeartRateScopeTipView.h"
#import "YSAppMacro.h"

@interface YSHeartRateScopeTipView ()

@property (nonatomic, weak) IBOutlet UIView *topBackgroundView;
@property (nonatomic, weak) IBOutlet UIView *middleBackgroundView;
@property (nonatomic, weak) IBOutlet UIView *bottomBackgroundView;
@property (nonatomic, weak) IBOutlet UILabel *tipLabel;

@end

@implementation YSHeartRateScopeTipView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSHeartRateScopeTipView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        containerView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)awakeFromNib
{
    // 设置不同的背景颜色
    UIColor *topColor = RGB(238, 238, 238);
    UIColor *middleColor = RGB(221, 221, 221);
    UIColor *bottomColor = RGB(204, 204, 204);
    
    self.topBackgroundView.backgroundColor = topColor;
    self.middleBackgroundView.backgroundColor = middleColor;
    self.bottomBackgroundView.backgroundColor = bottomColor;
    
    UIColor *textColor = RGB(136, 136, 136);
    CGFloat fontSize = 12;
    
    self.tipLabel.textColor = textColor;
    self.tipLabel.font = [UIFont systemFontOfSize:fontSize];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setTIpLabelText:(NSString *)text
{
    self.tipLabel.text = text;
}

@end
