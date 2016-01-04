//
//  YSMarkLabel.m
//  YSRun
//
//  Created by moshuqi on 15/11/24.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSMarkLabel.h"

@interface YSMarkLabel ()

@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UILabel *markLabel;

@end

@implementation YSMarkLabel

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSMarkLabel" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        
        self.contentLabel.adjustsFontSizeToFitWidth = YES;
        self.contentLabel.adjustsFontSizeToFitWidth = YES;
        
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)setContentText:(NSString *)text
{
    self.contentLabel.text = text;
}

- (void)setMarkText:(NSString *)text
{
    self.markLabel.text = text;
}

- (void)setContentFontSize:(CGFloat)size
{
    self.contentLabel.font = [UIFont systemFontOfSize:size];
}

- (void)setContentBoldWithFontSize:(CGFloat)fontSize
{
    self.contentLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:fontSize];
}

- (void)setMarkFontSize:(CGFloat)size
{
    self.markLabel.font = [UIFont systemFontOfSize:size];
}

- (void)setContentTextColor:(UIColor *)color
{
    self.contentLabel.textColor = color;
}

- (void)setMarkTextColor:(UIColor *)color
{
    self.markLabel.textColor = color;
}


@end
