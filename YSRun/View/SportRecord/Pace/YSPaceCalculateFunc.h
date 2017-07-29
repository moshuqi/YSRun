//
//  YSPaceCalculateFunc.h
//  YSRun
//
//  Created by moshuqi on 16/1/26.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YSTimeLocationArray;

@interface YSPaceCalculateFunc : NSObject

- (id)initWithTimeLocationArray:(YSTimeLocationArray *)timeLocationArray
                        useTime:(NSInteger)useTime;

- (NSArray *)getPaceSectionDataArray;

@end
