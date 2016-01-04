//
//  YSBLEDeviceConnectView.h
//  YSRun
//
//  Created by moshuqi on 15/11/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSBLEDeviceConnectViewDelegate <NSObject>

@required
- (void)BLEDeviceConnect;

@end

@interface YSBLEDeviceConnectView : UIView

@property (nonatomic, weak) id<YSBLEDeviceConnectViewDelegate> delegate;

@end
