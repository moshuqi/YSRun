//
//  YSDayCellModel.h
//  YSRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIColor;

@interface YSDayCellModel : NSObject

@property (nonatomic, assign) NSInteger day;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) NSInteger starNumber;

@end
