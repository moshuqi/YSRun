//
//  YSBluetoothConnect.h
//  YSRun
//
//  Created by moshuqi on 15/11/9.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

#define YSBluetoothConnectHeartRateKey  @"heartRate"

@protocol YSBluetoothConnectDelegate <NSObject>

@required
- (void)centralManagerNotPoweredOnWithMessage:(NSString *)message;
- (void)updateWithHeartRate:(NSInteger)heartRate;

@end

typedef void (^YSBLEConnectPeripheralStateBlock)(BOOL connectState);
typedef void (^YSExameBluetoothStateBlock)(BOOL isPowerOn);

@interface YSBluetoothConnect : NSObject

@property (nonatomic, weak) id<YSBluetoothConnectDelegate> delegate;

+ (instancetype)shareBluetoothConnect;
- (BOOL)hasConnectPeripheral;
- (void)connectPeripheralWithStateCallback:(YSBLEConnectPeripheralStateBlock)connectStateCallback
                           examBLECallback:(YSExameBluetoothStateBlock)examCallback;

- (void)addHeartRateObserver:(id)observer;
- (void)removeHeartRateObserver:(id)observer;

- (NSArray *)getHeartRateData;
- (void)clearHeartRateData;

@end
