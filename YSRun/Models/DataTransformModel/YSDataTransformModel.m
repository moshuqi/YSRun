//
//  YSDataTransformModel.m
//  YSRun
//
//  Created by moshuqi on 15/11/27.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSDataTransformModel.h"

@implementation YSDataTransformModel

- (id)initWithDataArray:(NSArray *)dataArray
{
    self = [super init];
    if (self)
    {
        self.dataArray = dataArray;
        self.dataString = [self getDataStringWithArray:dataArray];
    }
    
    return self;
}

- (id)initWithDataString:(NSString *)dataString
{
    self = [super init];
    if (self)
    {
        self.dataString = dataString;
        
        NSArray *components = [dataString componentsSeparatedByString:[self separatedString]];
        self.dataArray = [self getDataArrayWithComponents:components];
    }
    
    return self;
}

- (NSString *)separatedString
{
    // 子类重载
    return nil;
}

- (NSArray *)getDataArrayWithComponents:(NSArray *)components
{
    // 子类重载，将拆分成的字符串数组来初始化dataArray
    return nil;
}

- (NSString *)getDataStringWithArray:(NSArray *)array
{
    // 子类重载，将数组元素转化成特地格式的字符串
    return nil;
}

@end
