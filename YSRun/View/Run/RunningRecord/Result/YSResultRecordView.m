//
//  YSResultRecordView.m
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSResultRecordView.h"
#import "YSTimeLabel.h"
#import "YSStarRatingView.h"

@interface YSResultRecordView ()

@property (nonatomic, weak) IBOutlet UILabel *kilometreLabel;   // 公里
@property (nonatomic, weak) IBOutlet UILabel *kilometrePerHour; // 公里/小时
@property (nonatomic, weak) IBOutlet UILabel *secondPerkilometre;    // 秒/公里

@property (nonatomic, weak) IBOutlet UILabel *effectLabel;
@property (nonatomic, weak) IBOutlet YSTimeLabel *timeLabel;
@property (nonatomic, weak) IBOutlet YSStarRatingView *starRattingView;
@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;

@end

@implementation YSResultRecordView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSResultRecordView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        containerView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)awakeFromNib
{
    
}

@end
