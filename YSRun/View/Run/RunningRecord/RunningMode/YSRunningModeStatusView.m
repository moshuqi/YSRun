//
//  YSRunningModeStatusView.m
//  YSRun
//
//  Created by moshuqi on 15/10/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSRunningModeStatusView.h"
#import "YSUtilsMacro.h"

@interface YSRunningModeStatusView ()

@property (nonatomic, weak) IBOutlet UIImageView *modeIcon;
@property (nonatomic, weak) IBOutlet UILabel *modeLabel;

@end

@implementation YSRunningModeStatusView

//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super initWithCoder:aDecoder])
//    {
//        UIView *containerView = [[[UINib nibWithNibName:@"YSRunningModeStatusView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
//        
//        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//        containerView.frame = newFrame;
//        containerView.backgroundColor = [UIColor clearColor];
//        
//        [self addSubview:containerView];
//    }
//    
//    return self;
//}

- (void)awakeFromNib
{
    [self addTapGesture];
    
    self.modeLabel.font = [UIFont systemFontOfSize:18];
}

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self)
//    {
//        [self initSubviews];
//        [self addTapGesture];
//    }
//    
//    return self;
//}
//
//- (void)initSubviews
//{
//    CGFloat width = CGRectGetWidth(self.frame);
//    CGFloat height = CGRectGetHeight(self.frame);
//    
//    if (width < height)
//    {
//        YSLog(@"宽高有问题。");
//    }
//    
//    // 模式图片
//    CGFloat iconHeight = height;
//    CGFloat iconWidth = iconHeight;
//    CGRect iconFrame = CGRectMake(0, 0, iconWidth, iconHeight);
//    
//    self.modeIcon = [[UIImageView alloc] initWithFrame:iconFrame];
//    [self addSubview:self.modeIcon];
//    
//    // 模式名称
//    CGFloat distance = 10;  // 标签和图片的间距
//    CGFloat labelWidth = width - iconWidth - distance;
//    CGFloat labelHeight = height;
//    CGRect labelFrame = CGRectMake(iconWidth + distance, 0, labelWidth, labelHeight);
//    
//    self.modeLabel = [[UILabel alloc] initWithFrame:labelFrame];
//    [self addSubview:self.modeLabel];
//}

- (void)addTapGesture
{
    // 点击事件，用来切换模式
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(runningModeChange:)];
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];
}

- (void)runningModeChange:(id)sender
{
    [self.delegate modeStatusChange];
}

- (void)setModeIconWithImage:(UIImage *)image modeName:(NSString *)name
{
    self.modeIcon.image = image;
    self.modeLabel.text = name;
}

@end
