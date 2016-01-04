//
//  YSMarkLabelsView.m
//  YSRun
//
//  Created by moshuqi on 15/11/25.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSMarkLabelsView.h"
#import "YSMarkLabel.h"

@interface YSMarkLabelsView ()

@property (nonatomic, weak) IBOutlet YSMarkLabel *leftLabel;
@property (nonatomic, weak) IBOutlet YSMarkLabel *centerLabel;
@property (nonatomic, weak) IBOutlet YSMarkLabel *rightLabel;

@end

@implementation YSMarkLabelsView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSMarkLabelsView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        
        [self addSubview:containerView];
    }
    
    return self;
}

// left
- (void)setLeftLabelContentText:(NSString *)text
{
    [self.leftLabel setContentText:text];
}

- (void)setLeftLabelMarkText:(NSString *)text
{
    [self.leftLabel setMarkText:text];
}

- (void)setLeftLabelContentTextColor:(UIColor *)color
{
    [self.leftLabel setContentTextColor:color];
}

- (void)setLeftLabelMarkTextColor:(UIColor *)color
{
    [self.leftLabel setMarkTextColor:color];
}

- (void)setLeftLabelContentTextFontSize:(CGFloat)fontSize
{
    [self.leftLabel setContentFontSize:fontSize];
}

- (void)setLeftLabelMarkTextFontSize:(CGFloat)fontSize
{
    [self.leftLabel setMarkFontSize:fontSize];
}


// center
- (void)setCenterLabelContentText:(NSString *)text
{
    [self.centerLabel setContentText:text];
}

- (void)setCenterLabelMarkText:(NSString *)text
{
    [self.centerLabel setMarkText:text];
}

- (void)setCenterLabelContentTextColor:(UIColor *)color
{
    [self.centerLabel setContentTextColor:color];
}

- (void)setCenterLabelMarkTextColor:(UIColor *)color
{
    [self.centerLabel setMarkTextColor:color];
}

- (void)setCenterLabelContentTextFontSize:(CGFloat)fontSize
{
    [self.centerLabel setContentFontSize:fontSize];
}

- (void)setCenterLabelMarkTextFontSize:(CGFloat)fontSize
{
    [self.centerLabel setMarkFontSize:fontSize];
}

// right
- (void)setRightLabelContentText:(NSString *)text
{
    [self.rightLabel setContentText:text];
}

- (void)setRightLabelMarkText:(NSString *)text
{
    [self.rightLabel setMarkText:text];
}

- (void)setRightLabelContentTextColor:(UIColor *)color
{
    [self.rightLabel setContentTextColor:color];
}

- (void)setRightLabelMarkTextColor:(UIColor *)color
{
    [self.rightLabel setMarkTextColor:color];
}

- (void)setRightLabelContentTextFontSize:(CGFloat)fontSize
{
    [self.rightLabel setContentFontSize:fontSize];
}

- (void)setRightLabelMarkTextFontSize:(CGFloat)fontSize
{
    [self.rightLabel setMarkFontSize:fontSize];
}


- (void)setContentTextFontSize:(CGFloat)fontSize
{
    [self setLeftLabelContentTextFontSize:fontSize];
    [self setCenterLabelContentTextFontSize:fontSize];
    [self setRightLabelContentTextFontSize:fontSize];
}

- (void)setMarkTextFontSize:(CGFloat)fontSize
{
    [self setLeftLabelMarkTextFontSize:fontSize];
    [self setCenterLabelMarkTextFontSize:fontSize];
    [self setRightLabelMarkTextFontSize:fontSize];
}

- (void)setContentTextBoldWithFontSize:(CGFloat)fontSize
{
    [self.leftLabel setContentBoldWithFontSize:fontSize];
    [self.centerLabel setContentBoldWithFontSize:fontSize];
    [self.rightLabel setContentBoldWithFontSize:fontSize];
}

- (void)setContentTextColor:(UIColor *)color
{
    [self setLeftLabelContentTextColor:color];
    [self setCenterLabelContentTextColor:color];
    [self setRightLabelContentTextColor:color];
}

- (void)setMarkTextColor:(UIColor *)color
{
    [self setLeftLabelMarkTextColor:color];
    [self setCenterLabelMarkTextColor:color];
    [self setRightLabelMarkTextColor:color];
}


@end
