//
//  YSContentHelp.m
//  YSRun
//
//  Created by moshuqi on 15/11/24.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSContentHelp.h"
#import "YSContentHelpView.h"

@interface YSContentHelp ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) YSContentHelpView *helpView;

@end

@implementation YSContentHelp

- (void)showHelpFromPoint:(CGPoint)point
{
    self.helpView = [[[UINib nibWithNibName:@"YSContentHelpView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.helpView.layer.cornerRadius = 5;
    [self.helpView setupComponents];
    
    [self addBackground];
    [self.backgroundView addSubview:self.helpView];
    
    CGSize size = [self helpViewSize];
    CGRect frame = CGRectMake(point.x, point.y, size.width, size.height);
    self.helpView.frame = frame;
}

- (void)addBackground
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.backgroundView = [[UIView alloc] initWithFrame:window.bounds];
    self.backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    [window addSubview:self.backgroundView];
    [window bringSubviewToFront:self.backgroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground:)];
    [self.backgroundView addGestureRecognizer:tap];
}

- (void)tapBackground:(id)UITapGestureRecognizer
{
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

- (CGSize)helpViewSize
{
    CGFloat width = 220;
    CGFloat height = 180;
    
    CGSize size = CGSizeMake(width, height);
    return size;
}

@end
