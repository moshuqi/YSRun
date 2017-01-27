//
//  YSMedalView.m
//  YSRun
//
//  Created by moshuqi on 16/1/11.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSMedalView.h"

@interface YSMedalView ()

@property (nonatomic, weak) IBOutlet UIImageView *leftImageView;
@property (nonatomic, weak) IBOutlet UIImageView *centerImageView;
@property (nonatomic, weak) IBOutlet UIImageView *rightImageView;

@end

@implementation YSMedalView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSMedalView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        containerView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:containerView];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)setMedalLevel:(NSInteger)level
{
    self.leftImageView.hidden = (level == 3) ? NO : YES;
    self.centerImageView.hidden = (level >= 2) ? NO : YES;
    self.rightImageView.hidden = (level >= 1) ? NO : YES;
}

@end
