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
    }
    
    return self;
}

- (void)setupWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    self.titleLabel.text = title;
    [self.returnButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
