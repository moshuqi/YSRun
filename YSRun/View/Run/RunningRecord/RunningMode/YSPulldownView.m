//
//  YSPulldownView.m
//  YSRun
//
//  Created by moshuqi on 15/10/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSPulldownView.h"
#import "YSAppMacro.h"

@interface YSPulldownView ()

@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *arrow;

@end

const CGFloat arrowHeight = 56;

@implementation YSPulldownView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initSubviews];
    }
    
    return self;
}

+ (instancetype)defaultPulldownViewWithRadius:(CGFloat)radius
{
    CGFloat width = radius * 2;
    CGFloat height = radius * 2 + arrowHeight;
    CGRect frame = CGRectMake(0, 0, width, height);
    
    YSPulldownView *pulldownView = [[YSPulldownView alloc] initWithFrame:frame];
    return pulldownView;
}

- (void)initSubviews
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat radius = width / 2;
    CGRect circleFrame = CGRectMake(0, 0, radius * 2, radius * 2);
    
    self.circleView = [[UIView alloc] initWithFrame:circleFrame];
    [self addSubview:self.circleView];
    
    self.label = [[UILabel alloc] initWithFrame:self.circleView.bounds];
    [self.circleView addSubview:self.label];
    
    self.label.numberOfLines = 0;
    self.label.text = @"下拉\n暂停";
    self.label.textAlignment = NSTextAlignmentCenter;
    
    CGRect arrowFrame = CGRectMake(0, height - arrowHeight, width, arrowHeight);
    self.arrow = [[UIView alloc] initWithFrame:arrowFrame];
    [self addSubview:self.arrow];
}

- (void)setAppearanceWithType:(YSPulldownType)type
{
    // 普通模式和地图模式下界面不一样
    
    UIColor *greenColor = RGB(33, 221, 143);
    
    if (type == YSPulldownTypeGeneralMode)
    {
        self.circleView.layer.borderWidth = 3;
        self.circleView.layer.borderColor = greenColor.CGColor;
        self.circleView.backgroundColor = [UIColor clearColor];
        
        UIColor *textColor = RGB(107, 226, 177);
        self.label.textColor = textColor;
    }
    else
    {
        self.circleView.backgroundColor = greenColor;
        self.label.textColor = [UIColor whiteColor];
    }
    
    CGFloat radius = CGRectGetWidth(self.circleView.frame) / 2;
    self.circleView.layer.cornerRadius = radius;
}

@end
