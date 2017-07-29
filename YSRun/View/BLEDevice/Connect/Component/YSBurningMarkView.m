//
//  YSBurningMarkView.m
//  YSRun
//
//  Created by moshuqi on 15/11/20.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSBurningMarkView.h"
#import "YSAppMacro.h"

@interface YSBurningMarkView ()

@property (nonatomic, weak) IBOutlet UILabel *burningLabel;
@property (nonatomic, weak) IBOutlet UILabel *heartRateMinLabel;
@property (nonatomic, weak) IBOutlet UILabel *heartRateMaxLabel;

@end

@implementation YSBurningMarkView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSBurningMarkView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        containerView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // 设置字体字号颜色
    UIFont *font = [UIFont systemFontOfSize:11];
    UIColor *textColor = RGB(170, 201, 178);
    
    self.burningLabel.font = font;
    self.burningLabel.text = @"燃脂心率";
    self.burningLabel.textColor = textColor;
    
    self.heartRateMinLabel.font = font;
    self.heartRateMinLabel.text = @"140";
    self.heartRateMinLabel.textColor = textColor;
    
    self.heartRateMaxLabel.font = font;
    self.heartRateMaxLabel.text = @"160";
    self.heartRateMaxLabel.textColor = textColor;
    
    UIColor *backgroundColor = RGB(78, 149, 118);
    self.backgroundColor = backgroundColor;
}

@end
