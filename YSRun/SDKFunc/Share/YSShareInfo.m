//
//  YSShareInfo.m
//  YSRun
//
//  Created by moshuqi on 15/12/5.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSShareInfo.h"

@implementation YSShareInfo

+ (instancetype)defaultShareInfoWithImages:(NSArray *)images
{
    YSShareInfo *shareInfo = [YSShareInfo new];
    shareInfo.imageArray = images;
    shareInfo.contentText = @"分享内容";
    
    // 其他参数为默认值
    shareInfo.url = [NSURL URLWithString:@"http://mob.com"];
    shareInfo.title = @"分享标题";
    
    return shareInfo;
}

@end
