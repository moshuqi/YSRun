//
//  YSDetailLabelView.m
//  YSRun
//
//  Created by moshuqi on 16/1/25.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSDetailLabelView.h"
#import "YSSuperscriptLabel.h"
#import "YSAppMacro.h"

@interface YSDetailLabelView ()

@property (nonatomic, weak) IBOutlet YSSuperscriptLabel *leftSuperscriptLabel;
@property (nonatomic, weak) IBOutlet YSSuperscriptLabel *rightSuperscriptLabel;
@property (nonatomic, weak) IBOutlet UIView *colorView;

@end

@implementation YSDetailLabelView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSDetailLabelView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)awakeFromNib
{
    // 设置标签旁的圆默认颜色
    
    CGFloat cornerRadius = CGRectGetHeight(self.colorView.frame) / 2;
    self.colorView.layer.cornerRadius = cornerRadius;
    self.colorView.clipsToBounds = YES;
    self.colorView.backgroundColor = GreenBackgroundColor;
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)setLeftContentText:(NSString *)text
{
    [self.leftSuperscriptLabel setContentText:text];
}

- (void)setLeftScriptText:(NSString *)text
{
    [self.leftSuperscriptLabel setScriptText:text];
}

- (void)setRightContentText:(NSString *)text
{
    [self.rightSuperscriptLabel setContentText:text];
}

- (void)setRightScriptText:(NSString *)text
{
    [self.rightSuperscriptLabel setScriptText:text];
}

// 设置标签隐藏显示

- (void)setLeftHidden:(BOOL)hidden
{
    self.leftSuperscriptLabel.hidden = hidden;
}

- (void)setRightHidden:(BOOL)hidden
{
    self.rightSuperscriptLabel.hidden = hidden;
}

@end
