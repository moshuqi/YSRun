//
//  YSNavigationBarView.m
//  YSRun
//
//  Created by moshuqi on 15/10/17.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSNavigationBarView.h"
#import "YSAppMacro.h"

@interface YSNavigationBarView ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *returnButton;
@property (nonatomic, weak) IBOutlet UIButton *rightButton;

@property (nonatomic, strong) UIView *containerView;

@end

@implementation YSNavigationBarView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSNavigationBarView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        
        containerView.backgroundColor = GreenBackgroundColor;
        
        [self addSubview:containerView];
        self.containerView = containerView;
        
        self.rightButton.hidden = YES;  // 默认设置为不可见
    }
    
    return self;
}

- (void)setupWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    self.titleLabel.text = title;
    [self.returnButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupWithTitle:(NSString *)title barBackgroundColor:(UIColor *)color target:(id)target action:(SEL)action
{
    [self setupWithTitle:title target:target action:action];
    
    self.backgroundColor = color;
    self.containerView.backgroundColor = color;
}

- (void)setRightButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    self.rightButton.hidden = NO;   // 默认隐藏，需要设置时设为显示
    [self.rightButton setTitle:title forState:UIControlStateNormal];
    [self.rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setRightButtonWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    self.rightButton.hidden = NO;   // 默认隐藏，需要设置时设为显示
    [self.rightButton setImage:image forState:UIControlStateNormal];
    [self.rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
