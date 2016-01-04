//
//  YSTimeShaftView.m
//  YSRun
//
//  Created by moshuqi on 15/11/25.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSTimeShaftView.h"

@interface YSTimeShaftView ()

@property (nonatomic, weak) IBOutlet UILabel *time1;
@property (nonatomic, weak) IBOutlet UILabel *time2;
@property (nonatomic, weak) IBOutlet UILabel *time3;
@property (nonatomic, weak) IBOutlet UILabel *time4;

@end

@implementation YSTimeShaftView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSTimeShaftView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        containerView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:containerView];
    }
    
    return self;
}

- (NSArray *)getLabels
{
    NSArray *labels = @[self.time1, self.time2, self.time3, self.time4];
    return labels;
}

- (void)setupWithStartTime:(NSInteger)startTime endTime:(NSInteger)endTime
{
    NSArray *labels = [self getLabels];
    NSInteger numberOfLabels = [labels count];
    NSInteger timeInterval = (endTime - startTime) / (numberOfLabels - 1);
    
    for (NSInteger i = 0; i < numberOfLabels; i++)
    {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:startTime + i * timeInterval];
        UILabel *label = labels[i];
        label.text = [self timeStrFromDate:date];
    }
}

- (void)setupLabelTextColor:(UIColor *)textColor fontSize:(CGFloat)fontSize
{
    NSArray *labels = [self getLabels];
    for (UILabel *label in labels)
    {
        label.textColor = textColor;
        label.font = [UIFont systemFontOfSize:fontSize];
    }
}

- (NSString *)timeStrFromDate:(NSDate *)date
{
    // 按“HH:MM”格式取出时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    NSInteger index = [destDateString length] - 8;
    NSRange range = NSMakeRange(index, 5);
    NSString *timeStr = [destDateString substringWithRange:range];
    
    return timeStr;
}

@end
