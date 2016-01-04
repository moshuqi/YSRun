//
//  YSUserRecordView.h
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YSBLEContentViewState) {
    YSBLEContentViewStateNone = -1,
    YSBLEContentViewStateDeviceConnect = 0,
    YSBLEContentViewStateConnecting = 1,
    YSBLEContentViewStateHeartRateCounting = 2,
};

@protocol YSUserRecordViewDelegate <NSObject>

@required
- (void)tapUserHead;
- (void)touchBLEConnectButton;

@end

@interface YSUserRecordView : UIView

@property (nonatomic, weak) id<YSUserRecordViewDelegate> delegate;

- (void)setUserName:(NSString *)userName
          headPhoto:(UIImage *)headPhoto
      totalDistance:(CGFloat)distance
      totalRunTimes:(NSInteger)runTimes
          totalTime:(NSInteger)time;

- (void)updateHeartRateWithValue:(NSInteger)heartRate;
- (void)setBLEContentWithState:(YSBLEContentViewState)state;
- (void)setBLEContentViewHidden:(BOOL)hidden;

@end
