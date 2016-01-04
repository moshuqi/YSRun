//
//  YSBLEConnectHintView.h
//  YSRun
//
//  Created by moshuqi on 15/11/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSBLEConnectHintViewDelegate <NSObject>

- (void)connectHintClose;
- (void)connectDevice;
- (void)startRun;
- (void)setConnectHintHidden:(BOOL)hidden;

@end

@interface YSBLEConnectHintView : UIView

@property (nonatomic, weak) id<YSBLEConnectHintViewDelegate> delegate;

@end
