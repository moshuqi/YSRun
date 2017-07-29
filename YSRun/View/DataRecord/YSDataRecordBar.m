//
//  YSDataRecordBar.m
//  YSRun
//
//  Created by moshuqi on 15/11/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSDataRecordBar.h"
#import "YSAppMacro.h"

@interface YSDataRecordBar ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;

@end

@implementation YSDataRecordBar

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSDataRecordBar" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        containerView.backgroundColor = GreenBackgroundColor;
        
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.titleLabel.textColor = [UIColor whiteColor];
    
    // 这一版先屏蔽掉分享
    self.shareButton.hidden = YES;
}

- (void)setBarTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (IBAction)backButtonClicked:(id)sender
{
    [self.delegate viewBack];
}

@end
