//
//  YSTimeLabel.m
//  YSRun
//
//  Created by moshuqi on 15/10/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSTimeLabel.h"

@interface YSTimeLabel ()

@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;
@property (nonatomic, assign) NSInteger second;

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@end

@implementation YSTimeLabel


- (void)awakeFromNib
{
    
}

@end
