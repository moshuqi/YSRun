//
//  YSCommentElement.m
//  YSRun
//
//  Created by moshuqi on 15/11/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSCommentElement.h"

@interface YSCommentElement ()

@property (nonatomic, strong) IBOutlet UIView *colorView;
@property (nonatomic, strong) IBOutlet UILabel *commentLabel;

@end

@implementation YSCommentElement

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSCommentElement" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        containerView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)awakeFromNib
{
    self.commentLabel.adjustsFontSizeToFitWidth = YES;
//    self.commentLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setCommentColor:(UIColor *)color
{
    self.colorView.backgroundColor = color;
}

- (void)setCommentText:(NSString *)text
{
    self.commentLabel.text = text;
}

- (void)setCommentTextFontSize:(CGFloat)fontSize
{
    self.commentLabel.font = [UIFont systemFontOfSize:fontSize];
}

@end
