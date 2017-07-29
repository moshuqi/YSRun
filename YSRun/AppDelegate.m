//
//  AppDelegate.m
//  YSRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "AppDelegate.h"
#import "YSMainTabBarViewController.h"
#import "UMFeedback.h"
#import "MobClick.h"
#import "YSShareFunc.h"
#import "YSLaunchAnimation.h"
#import <MAMapKit/MAMapKit.h>
#import "YSAppMacro.h"

#define UMAppKey        @"561cbb08e0f55a33f0004c54"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    YSMainTabBarViewController *viewController = [[YSMainTabBarViewController alloc] init];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:viewController];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    YSLaunchAnimation *launchAnimation = [YSLaunchAnimation new];
//    [launchAnimation launch];
    
    [self SDKConfig];
    
//    // bundle ID
//    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
//    NSLog(@"%@", bundleID);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)SDKConfig
{
    // 第三方库的设置
    [self UMConfig];
    
    // 分享
    [YSShareFunc shareConfig];
    
    // 高德地图SDK
    [MAMapServices sharedServices].apiKey = (NSString *)MapAPIKey;
}

- (void)UMConfig
{
    // 友盟用户反馈，数据统计
    
    [UMFeedback setAppkey:UMAppKey];
    
    [MobClick startWithAppkey:UMAppKey reportPolicy:BATCH channelId:nil];
    [MobClick setLogEnabled:YES];
}

@end
