//
//  YSSubscriptLabel.m
//  YSRun
//
//  Created by moshuqi on 15/10/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSSubscriptLabel.h"

@interface YSSubscriptLabel ()

@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UILabel *subscriptNameLabel;

@end

@implementation YSSubscriptLabel


- (void)setContentText:(NSString *)text
{
    self.contentLabel.text = text;
}

- (void)setSubscriptText:(NSString *)text
{
    self.subscriptNameLabel.text = text;
}



@end
