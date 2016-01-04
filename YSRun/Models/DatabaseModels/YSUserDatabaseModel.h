//
//  YSUserDatabaseModel.h
//  YSRun
//
//  Created by moshuqi on 15/10/26.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSUserDatabaseModel : NSObject

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *lasttime;
@property (nonatomic, copy) NSString *headimg;

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) NSInteger height;

@end
