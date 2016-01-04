//
//  YSBLEConnectFailureHintView.h
//  YSRun
//
//  Created by moshuqi on 15/11/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSBLEConnectFailureHintViewDelegate <NSObject>

- (void)connectFailureHintBack;
- (void)connectFailureHintClose;
- (void)reConnect;

@end

@interface YSBLEConnectFailureHintView : UIView

@property (nonatomic, weak) id<YSBLEConnectFailureHintViewDelegate> delegate;

@end
