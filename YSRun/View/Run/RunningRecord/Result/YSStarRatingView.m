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
    
    UIImage *bigStar = [UIImage imageNamed:@"big_no_star.png"];
    UIImage *smallStar = [UIImage imageNamed:@"small_no_star.png"];
    
    self.leftStar.image = smallStar;
    self.centerStar.image = bigStar;
    self.rightStar.image = smallStar;
}

- (void)setRattingLevel:(NSInteger)level
{
    self.leftStar.image = (level >= 1) ? [UIImage imageNamed:@"small_star.png"] : [UIImage imageNamed:@"small_no_star.png"];
    self.centerStar.image = (level >= 2) ? [UIImage imageNamed:@"big_star.png"] : [UIImage imageNamed:@"big_no_star.png"];
    self.rightStar.image = (level >= 3) ? [UIImage imageNamed:@"small_star.png"] : [UIImage imageNamed:@"small_no_star.png"];
}

@end
