//
//  YSBluetoothConnect.m
//  YSRun
//
//  Created by moshuqi on 15/11/9.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSBluetoothConnect.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "YSUtilsMacro.h"

#define YSBluetoothConnectScanTime      5      // 扫描一定时间后若无设备则中断扫描

@interface YSBluetoothConnect () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, assign) NSInteger heartRate;

@property (nonatomic, strong) NSMutableArray *heartRateArray;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) YSBLEConnectPeripheralStateBlock connectStateCallback;
@property (nonatomic, copy) YSExameBluetoothStateBlock examBLECallback;

@property (nonatomic, strong) NSTimer *simulationTimer;

@end

@implementation YSBluetoothConnect

static NSString *ServiceHeartRateUUIDStr = @"180D";
static NSString *CharacteristicHeartRateUUIDStr = @"2A37";

// 设为YES时模拟生成心率
static BOOL simulationMode = YES;

static YSBluetoothConnect *_instance;

+ (id)allocWithZone:(struct _NSZone *)zone
{
    //调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)shareBluetoothConnect
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YSBluetoothConnect alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (void)addHeartRateObserver:(id)observer
{
    [self addObserver:observer forKeyPath:YSBluetoothConnectHeartRateKey options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)removeHeartRateObserver:(id)observer
{
    [self removeObserver:observer forKeyPath:YSBluetoothConnectHeartRateKey];
}

- (void)connectPeripheral
{
    // 扫描连接设备
    [self stopScan];
    
    self.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:self.queue];
}

- (void)connectPeripheralWithStateCallback:(YSBLEConnectPeripheralStateBlock)connectStateCallback
                           examBLECallback:(YSExameBluetoothStateBlock)examCallback
{
    self.connectStateCallback = connectStateCallback;
    self.examBLECallback = examCallback;
    
    if (simulationMode)
    {
        [self simulation];
        return;
    }
    
    [self connectPeripheral];
}

- (BOOL)hasConnectPeripheral
{
    NSArray *serviceUUIDs = @[[CBUUID UUIDWithString:ServiceHeartRateUUIDStr]];
    NSArray *peripheralArray = [self.manager retrieveConnectedPeripheralsWithServices:serviceUUIDs];
    
    if ([peripheralArray count] > 0)
    {
        return YES;
    }
    
    return NO;
}

- (void)reScanPeripheral
{
    [self connectPeripheral];
}

- (void)stopScan
{
    if (self.manager)
    {
        [self.manager stopScan];
        
        // self.peripheral必须保证不为空，否则会崩溃
        if (self.peripheral)
        {
            [self.manager cancelPeripheralConnection:self.peripheral];
        }
        
        self.manager = nil;
    }
}

- (void)scanTimerStart
{
    // 开始计时，一定时间和中断扫描
    
    // 调用scanTimerStart的地方为子线程，NSTimer在主线程中处理
    dispatch_async(dispatch_get_main_queue(), ^(){
        self.timer = [NSTimer scheduledTimerWithTimeInterval:YSBluetoothConnectScanTime target:self selector:@selector(interruptScan) userInfo:nil repeats:NO];
    });
}

- (void)interruptScan
{
    [self.timer invalidate];
    self.timer = nil;
    
    [self stopScan];
    
    if (self.connectStateCallback)
    {
        self.connectStateCallback(NO);
    }
    
    YSLog(@"超时扫描外设中断");
}

- (void)scanPeripheralFinish
{
    // 扫描到外设
    [self.timer invalidate];
    self.timer = nil;
}

- (void)connectSuccess
{
    // 连接成功
    if (self.connectStateCallback)
    {
        self.connectStateCallback(YES);
    }
}

- (void)connectFailure
{
    // 连接成功
    if (self.connectStateCallback)
    {
        self.connectStateCallback(NO);
    }
}

- (BOOL)examHeartRateServiceWithAdvertisementData:(NSDictionary *)advertisementData
{
    NSArray *serviceUUIDs = [advertisementData valueForKey:@"kCBAdvDataServiceUUIDs"];
    if (serviceUUIDs && [serviceUUIDs isKindOfClass:[NSArray class]])
    {
        CBUUID *uuid = [CBUUID UUIDWithString:ServiceHeartRateUUIDStr];
        if ([serviceUUIDs containsObject:uuid])
        {
            return YES;
        }
    }
    
    return NO;
}

- (NSArray *)getHeartRateData
{
    return self.heartRateArray;
}

- (void)clearHeartRateData
{
    // 清空数据
    [self.heartRateArray removeAllObjects];
    self.heartRateArray = nil;
}

- (void)simulation
{
    // 模拟连接蓝牙设备，生成随机的心率数据
    if (self.connectStateCallback)
    {
        self.connectStateCallback(YES);
    }
    
    self.heartRateArray = [NSMutableArray array];
    
    self.simulationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(simulateHeartRate) userInfo:nil repeats:YES];
}

- (void)simulateHeartRate
{
    // 随机生成心率
    NSInteger minHeartRate = 90;
    NSInteger maxHeartRate = 190;
    
    NSInteger heartRate = (NSInteger)(minHeartRate + (arc4random() % (maxHeartRate - minHeartRate + 1)));
    self.heartRate = heartRate;
    
    [self.delegate updateWithHeartRate:self.heartRate];
    [self.heartRateArray addObject:[NSNumber numberWithInteger:self.heartRate]];
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    //主设备状态改变的委托，在初始化CBCentralManager的时候会打开设备，只有当设备正确打开后才能使用
    
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            YSLog(@">>>CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateResetting:
            YSLog(@">>>CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnsupported:
            YSLog(@">>>CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateUnauthorized:
            YSLog(@">>>CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStatePoweredOff:
            YSLog(@">>>CBCentralManagerStatePoweredOff 设备蓝牙开关未打开");
            if (self.examBLECallback)
            {
                self.examBLECallback(NO);
            }
            break;
        case CBCentralManagerStatePoweredOn:
            YSLog(@">>>CBCentralManagerStatePoweredOn");
            [self.manager scanForPeripheralsWithServices:nil options:nil];
            [self scanTimerStart];
            
            break;
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    // 发现设备，设备UUID拿不到，直接拿设备名称作为筛选判断，心率设备的命名统一都为"Heart Rate Sensor"
    
//    NSString *targetPeripheralName = @"HRM";
    BOOL isHeartRateService = [self examHeartRateServiceWithAdvertisementData:advertisementData];
    
//    NSLog(@"当扫描到设备:%@", peripheral);
    if (isHeartRateService /*&& [peripheral.name hasPrefix:targetPeripheralName]*/)
    {
        YSLog(@"当扫描到设备:%@", peripheral);
        
        // 该设备未有连接
        if (peripheral.state == CBPeripheralStateDisconnected)
        {
            // 扫描到外设，把连接超时的计时器取消掉
            [self scanPeripheralFinish];
            
            // 通过这种方式保留引用，否则peripheral会被释放掉不会有后续的回调
            self.peripheral = peripheral;
            self.peripheral.delegate = self;
            
            // 扫描到相关设备后连接设备，停止扫描以省电。
            [self.manager connectPeripheral:self.peripheral options:nil];
            [self.manager stopScan];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    //连接外设成功的委托
    
    YSLog(@">>>连接设备（%@）成功",peripheral.name);
    
    // 搜索UUID = Heart Rate的心率服务
    CBUUID *uuid = [CBUUID UUIDWithString:ServiceHeartRateUUIDStr];
    NSArray *serviceUUIDs = @[uuid];
    [self.peripheral discoverServices:serviceUUIDs];
    
    [self connectSuccess];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    //外设连接失败的委托
    
    YSLog(@">>>连接设备（%@）失败,原因:%@",[peripheral name],[error localizedDescription]);
    [self reScanPeripheral];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    //断开外设的委托
    
    YSLog(@">>>外设断开连接 %@: %@\n", [peripheral name], [error localizedDescription]);
    
    self.heartRate = 0;
    [self reScanPeripheral];
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    //    YSLog(@"Discovered service %@", service);
    for (CBService *service in peripheral.services)
    {
        YSLog(@"Discovering characteristics for service %@", service);
        
        CBUUID *uuid = [CBUUID UUIDWithString:CharacteristicHeartRateUUIDStr];
        NSArray *characteristicUUIDs = @[uuid];
        
        [peripheral discoverCharacteristics:characteristicUUIDs forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        YSLog(@"Discovered characteristic %@", characteristic);
        
        // 订阅characteristic
        [self.peripheral setNotifyValue:YES forCharacteristic:characteristic];
        
        self.heartRateArray = [NSMutableArray array];
    }
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        YSLog(@"Error changing notification state: %@", [error localizedDescription]);
        return;
    }
    
    //    NSData *data = characteristic.value;
    // parse the data as needed
    
    self.heartRate = [self getHeartBPMData:characteristic error:error];
    [self.delegate updateWithHeartRate:self.heartRate];
    
    // 记录心率数据
    [self.heartRateArray addObject:[NSNumber numberWithInteger:self.heartRate]];
}

- (NSInteger)getHeartBPMData:(CBCharacteristic *)characteristic error:(NSError *)error
{
    // Get the Heart Rate Monitor BPM
    NSData *data = [characteristic value];      // 1
    const uint8_t *reportData = [data bytes];
    uint16_t bpm = 0;
    
    if ((reportData[0] & 0x01) == 0) {          // 2
        // Retrieve the BPM value for the Heart Rate Monitor
        bpm = reportData[1];
    }
    else {
        bpm = CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[1]));  // 3
    }
    // Display the heart rate value to the UI if no error occurred
    if( (characteristic.value)  || !error ) {   // 4
        NSString *string = [NSString stringWithFormat:@"%i bpm", bpm];
        YSLog(@"看我的心跳！！！========%@", string);
    }
    
    return (NSInteger)bpm;
}

@end
