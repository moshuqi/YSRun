//
//  YSTimeFunc.h
//  YSRun
//
//  Created by moshuqi on 15/11/25.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSTimeFunc : NSObject

+ (NSString *)timeStrFromUseTime:(NSInteger)useTime;
+ (NSString *)dateStrFromTimestamp:(NSInteger)timestamp;

@end
