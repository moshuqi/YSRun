//
//  YSShareInfo.h
//  YSRun
//
//  Created by moshuqi on 15/12/5.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSShareInfo : NSObject

@property (nonatomic, copy) NSString *contentText;      // 分享内容
@property (nonatomic, copy) NSArray *imageArray;
@property (nonatomic, copy) NSURL *url;
@property (nonatomic, copy) NSString *title;

+ (instancetype)defaultShareInfoWithImages:(NSArray *)images;

@end
