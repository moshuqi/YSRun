//
//  YSRunDatabaseModel.h
//  YSRun
//
//  Created by moshuqi on 15/10/26.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YSRunDatabaseModel : NSObject

@property (nonatomic, assign) NSInteger rowid;  // 数据库用来唯一标识的主键，自动递增

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *date;

@property (nonatomic, assign) NSInteger bdate;
@property (nonatomic, assign) NSInteger edate;
@property (nonatomic, assign) NSInteger usetime;

@property (nonatomic, assign) CGFloat lSpeed;
@property (nonatomic, assign) CGFloat hSpeed;
@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, assign) CGFloat pace;

@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, assign) NSInteger star;
@property (nonatomic, assign) NSInteger cost;
@property (nonatomic, assign) NSInteger isUpdate;   // 标记本地数据是否同步到服务器，1为已上传，2为未上传

// 心率和位置坐标的数据转换成字符串格式保存到数据库中
@property (nonatomic, copy) NSString *locationDataString;
@property (nonatomic, copy) NSString *heartRateDataString;

@end
