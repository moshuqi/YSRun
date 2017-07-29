//
//  YSLoadingDotView.m
//  YSRun
//
//  Created by moshuqi on 15/11/20.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSLoadingDotView.h"

@interface YSLoadingDotView ()

@property (weak, nonatomic) IBOutlet UIImageView *dot0;
@property (weak, nonatomic) IBOutlet UIImageView *dot1;
@property (weak, nonatomic) IBOutlet UIImageView *dot2;
@property (weak, nonatomic) IBOutlet UIImageView *dot3;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YSLoadingDotView

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSLoadingDotView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
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
    
    self.dot0.image = [UIImage imageNamed:@"loading_dot_0"];
    self.dot1.image = [UIImage imageNamed:@"loading_dot_1"];
    self.dot2.image = [UIImage imageNamed:@"loading_dot_2"];
    self.dot3.image = [UIImage imageNamed:@"loading_dot_3"];
}

- (void)loading
{
    self.timer = [NSTimer timerWithTimeInterval:0.2
                                         target:self
                                       selector:@selector(iconChange)
                                       userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)loadingFinish
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)iconChange
{
    UIImage *image0 = self.dot0.image;
    UIImage *image1 = self.dot1.image;
    UIImage *image2 = self.dot2.image;
    UIImage *image3 = self.dot3.image;
    
    self.dot0.image = image3;
    self.dot1.image = image0;
    self.dot2.image = image1;
    self.dot3.image = image2;
}


@end
