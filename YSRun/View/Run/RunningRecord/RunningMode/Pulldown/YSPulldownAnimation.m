//
//  YSPulldownAnimation.m
//  YSRun
//
//  Created by moshuqi on 15/11/4.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSPulldownAnimation.h"

@interface YSPulldownAnimation ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) NSArray *imageArray;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger index;

@end

@implementation YSPulldownAnimation

const CGFloat kImageViewWidth = 12;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat originX = (CGRectGetWidth(frame) - kImageViewWidth) / 2;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, 0, kImageViewWidth, CGRectGetHeight(frame))];
        [self addSubview:self.imageView];
        
        [self initImages];
    }
    
    return self;
}

- (void)initImages
{
    UIImage *image1 = [UIImage imageNamed:@"dropdown_1.png"];
    UIImage *image2 = [UIImage imageNamed:@"dropdown_2.png"];
    UIImage *image3 = [UIImage imageNamed:@"dropdown_3.png"];
    UIImage *image4 = [UIImage imageNamed:@"dropdown_4.png"];
    
    self.imageArray = @[image1, image2, image3, image4];
    
    self.index = 0;
    self.imageView.image = self.imageArray[self.index];
}

- (void)starAnimation
{
    if (self.timer != nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    NSTimeInterval timeInterval = 0.2;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(imageChange) userInfo:nil repeats:YES];
}

- (void)imageChange
{
    self.index = (self.index + 1) % [self.imageArray count];
    self.imageView.image = self.imageArray[self.index];
}

@end
