//
//  YSStarRatingView.m
//  YSRun
//
//  Created by moshuqi on 15/10/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSStarRatingView.h"

@interface YSStarRatingView ()

@property (nonatomic, weak) IBOutlet UIImageView *leftStar;
@property (nonatomic, weak) IBOutlet UIImageView *centerStar;
@property (nonatomic, weak) IBOutlet UIImageView *rightStar;

@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;

@end

@implementation YSStarRatingView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSStarRatingView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
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
    [self sendSubviewToBack:self.bgImageView];
    
    // 先设为透明，然后有个淡入的动画效果
    self.leftStar.alpha = 0;
    self.centerStar.alpha = 0;
    self.rightStar.alpha = 0;
}

- (void)setRattingLevel:(NSInteger)level
{
    if (level < 1)
    {
        return;
    }
    
    CGFloat leftAlpha = (level >= 1) ? 1 : 0;
    CGFloat centerAlpha = (level >= 2) ? 1 : 0;
    CGFloat rightAlpha = (level >= 3) ? 1 : 0;
    
    // 延迟，保证界面弹出完成后才进行动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSTimeInterval duration = 0.5;
        [UIView animateWithDuration:duration animations:^(){
            self.leftStar.alpha = leftAlpha;
        }completion:^(BOOL finished){
            [UIView animateWithDuration:duration animations:^(){
                self.centerStar.alpha = centerAlpha;
            }completion:^(BOOL finished){
                [UIView animateWithDuration:duration animations:^(){
                    self.rightStar.alpha = rightAlpha;
                }completion:^(BOOL finished){
                    
                }];
            }];
        }];
    });
}

@end
