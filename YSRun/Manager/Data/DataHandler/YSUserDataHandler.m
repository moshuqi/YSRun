//
//  YSUserDataHandler.m
//  YSRun
//
//  Created by moshuqi on 15/12/14.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSUserDataHandler.h"
#import "YSNetworkManager.h"
#import "YSDataManager.h"
#import "YSDatabaseManager.h"
#import "YSUtilsMacro.h"

@interface YSUserDataHandler () <YSNetworkManagerDelegate>

@end

@implementation YSUserDataHandler

- (void)uploadHeadImage:(UIImage *)headImage
{
    YSNetworkManager *networkManager = [YSNetworkManager new];
    networkManager.delegate = self;
    
    NSString *uid = [[YSDataManager shareDataManager] getUid];
    [networkManager uploadHeadImage:headImage uid:uid];
}

#pragma mark - YSNetworkManagerDelegate

- (void)uploadHeadImageSuccessWithPath:(NSString *)path
{
    // 头像上传成功，修改数据库用户头像的路径，并更新界面。
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        NSString *uid = [[YSDataManager shareDataManager] getUid];
        
        YSDatabaseManager *databaseManager = [YSDatabaseManager new];
        [databaseManager setUser:uid withHeadImagePath:path];
        
        [[YSDataManager shareDataManager] resetData];
        
        if ([self.delegate respondsToSelector:@selector(uploadHeadImageFinish)])
        {
            [self.delegate uploadHeadImageFinish];
        }
    });
}

- (void)uploadHeadImageFailureWithMessage:(NSString *)message
{
    YSLog(@"%@", message);
}

@end
