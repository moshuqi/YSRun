//
//  YSSuperscriptLabel.m
//  YSRun
//
//  Created by moshuqi on 16/1/25.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSSuperscriptLabel.h"
#import "YSDevice.h"
#import "YSAppMacro.h"

@interface YSSuperscriptLabel ()

@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UILabel *scriptLabel;

@end

@implementation YSSuperscriptLabel

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSSuperscriptLabel" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)awakeFromNib
{
    // 字体颜色，大小
    self.contentLabel.font = [UIFont systemFontOfSize:[self contentFontSize]];
    self.scriptLabel.font = [UIFont systemFontOfSize:[self scriptFontSize]];
    
    self.contentLabel.adjustsFontSizeToFitWidth = YES;
    self.scriptLabel.adjustsFontSizeToFitWidth = YES;
    
    self.scriptLabel.textColor = RGB(154, 154, 154);
    self.contentLabel.textColor = RGB(81, 81, 81);
}

- (void)setContentText:(NSString *)contentText
{
    self.contentLabel.text = contentText;
}

- (void)setScriptText:(NSString *)scriptText
{
    self.scriptLabel.text = scriptText;
}

- (CGFloat)contentFontSize
{
    CGFloat fontSize = 28;
    if ([YSDevice isPhone6Plus])
    {
        fontSize = 36;
    }
    
    return fontSize;
}

- (CGFloat)scriptFontSize
{
    CGFloat fontSize = 11;
    if ([YSDevice isPhone6Plus])
    {
        fontSize = 15;
    }
    
    return fontSize;
}

@end
