//
//  YSDataRecordModel.h
//  YSRun
//
//  Created by moshuqi on 15/11/25.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YSDataRecordModel : NSObject

@property (nonatomic, assign) NSInteger startTime;
@property (nonatomic, assign) NSInteger endTime;
@property (nonatomic, assign) NSInteger calorie;
@property (nonatomic, assign) CGFloat distance;

@property (nonatomic, strong) UIImage *mapImage;
@property (nonatomic, strong) NSArray *heartRateArray;
@property (nonatomic, strong) NSArray *locationArray;

@end
