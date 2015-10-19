//
//  YSRunningModeStatusView.h
//  YSRun
//
//  Created by moshuqi on 15/10/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSInteger, YSRunningModeType)
//{
//    YSRunningModeTypeGeneral = 1,   // 地图模式
//    YSRunningModeTypeMap            // 普通模式
//};

@protocol YSRunningModeStatusViewDelegate <NSObject>

- (void)modeStatusChange;

@end

@interface YSRunningModeStatusView : UIView

@property (nonatomic, weak) id<YSRunningModeStatusViewDelegate> delegate;

- (void)setModeIconWithImage:(UIImage *)image modeName:(NSString *)name;

@end
