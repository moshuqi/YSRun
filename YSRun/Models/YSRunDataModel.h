//
//  YSRunDataModel.h
//  YSRun
//
//  Created by moshuqi on 15/10/22.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YSRunDataModel : NSObject

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) CGFloat pace;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, assign) NSInteger usetime;
@property (nonatomic, assign) NSInteger cost;
@property (nonatomic, assign) NSInteger star;
@property (nonatomic, assign) NSInteger h_speed;
@property (nonatomic, assign) NSInteger l_speed;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, assign) NSInteger bdate;
@property (nonatomic, assign) NSInteger edate;
@property (nonatomic, assign) NSInteger speed;

@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *ctime;
@property (nonatomic, copy) NSString *utime;

@end
