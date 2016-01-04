//
//  YSDevice.m
//  YSRun
//
//  Created by moshuqi on 15/12/17.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSDevice.h"
#import <UIKit/UIKit.h>

@implementation YSDevice

+ (BOOL)isPhone6Plus
{
    if ([UIScreen mainScreen].scale > 2.1) {
        return YES;
    }
    else
    {
        return NO;
    }
}


@end
