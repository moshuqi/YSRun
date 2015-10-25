//
//  YSDatabaseManager.m
//  YSRun
//
//  Created by moshuqi on 15/10/23.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSDatabaseManager.h"
#import "YSDatabaseHandle.h"

@interface YSDatabaseManager ()

@property (nonatomic, strong) YSDatabaseHandle *databaseHandle;

@end

@implementation YSDatabaseManager

- (id)init
{
    self = [super init];
    if (self)
    {
        self.databaseHandle = [YSDatabaseHandle shareDatabaseHandle];
    }
    
    return self;
}

- (void)databaseTest
{
    
}

@end
