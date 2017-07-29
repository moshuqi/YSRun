//
//  YSVoicePrompt.m
//  YSRun
//
//  Created by moshuqi on 15/12/2.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSVoicePrompt.h"
//#import "YSGraphData.h"
#import "YSStatisticsDefine.h"
#import <AVFoundation/AVFoundation.h>
#import "YSUtilsMacro.h"

typedef NS_ENUM(NSInteger, YSHeartRateChangeType)
{
    YSHeartRateChangeTypeNoChange = 0,
    YSHeartRateChangeTypeIncreaseToEfficientReduceFat = 1,      // 从慢跑提高到减脂
    YSHeartRateChangeTypeReduceToJogging,                       // 从减脂降低到慢跑
    YSHeartRateChangeTypeIncreaseToAnaerobicExercise,           // 从减脂提高到无氧
    YSHeartRateChangeTypeReduceToEfficientReduceFat             // 从无氧降低到减脂
};

// 心率所处在的区间类型
typedef NS_ENUM(NSInteger, YSHeartRateIntervalType)
{
    YSHeartRateIntervalTypeJogging = 1,              // 慢跑
    YSHeartRateIntervalTypeEfficientReduceFat,       // 减脂
    YSHeartRateIntervalTypeAnaerobicExercise         // 无氧
};

// 时间累积所对应的心率类型
typedef NS_ENUM(NSInteger, YSTimestampAccumulateType)
{
    YSTimestampAccumulateTypeJogging = 1,              // 慢跑
    YSTimestampAccumulateTypeEfficientReduceFat,       // 减脂
    YSTimestampAccumulateTypeAnaerobicExercise         // 无氧
};

@interface YSVoicePrompt ()

@property (nonatomic, assign) YSVoicePromptType voicePromptType;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, assign) BOOL isConnectPeripherals;    // 是否有连接外设

@property (nonatomic, strong) NSMutableArray *perKmPromptRecord;
@property (nonatomic, assign) NSInteger lastHeartRate;

// 用来记录各个心率区间内的持续时间，当心率所在区间改变时，所有时间从新计算。
@property (nonatomic, assign) double joggingTimestamp;                   // 慢跑累计时间
@property (nonatomic, assign) double efficientReduceFatTimestamp;        // 高效减脂
@property (nonatomic, assign) double anaerobicExerciseTimestamp;         // 无氧运动

@property (nonatomic, assign) YSTimestampAccumulateType timestampAccumlateType;

@end

const NSInteger kMaxKilometerPrompt = 20;   // 最大支持的公里提示

@implementation YSVoicePrompt

- (id)init
{
    self = [super init];
    if (self)
    {
        self.isConnectPeripherals = NO;
        self.lastHeartRate = 0;
        self.voicePromptType = YSVoicePromptTypeMan;
        
        self.timestampAccumlateType = YSTimestampAccumulateTypeJogging;
        self.joggingTimestamp = CFAbsoluteTimeGetCurrent();
        
        [self setupPerKmPromptRecord];
        
        // 音频的后台播放
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
    }
    
    return self;
}

- (void)setupPerKmPromptRecord
{
    // 记录每公里是否已经进行过提示
    self.perKmPromptRecord = [NSMutableArray array];
    for (NSInteger i = 0; i < kMaxKilometerPrompt; i++)
    {
        NSNumber *state = [NSNumber numberWithBool:NO];
        [self.perKmPromptRecord addObject:state];
    }
}

- (void)updateWithHeartRate:(NSInteger)heartRate distance:(CGFloat)distance time:(NSInteger)time
{
    if (self.voicePromptType == YSVoicePromptClose)
    {
        // 声音提示关闭
        return;
    }
    
    [self promptWithDistance:distance];
    
    if (self.isConnectPeripherals)
    {
        [self promptWithHeartRate:heartRate];
    }
}

- (void)promptWithDistance:(CGFloat)distance
{
    NSInteger km = distance;
    if (km < 1 || km > kMaxKilometerPrompt)
    {
        return;
    }
    
    BOOL hasPrompt = [self.perKmPromptRecord[km - 1] boolValue];
    if (!hasPrompt)
    {
        [self.perKmPromptRecord replaceObjectAtIndex:(km - 1) withObject:[NSNumber numberWithBool:YES]];
        [self perKilometerPromptWithDistance:distance];
    }
}

- (void)promptWithHeartRate:(NSInteger)heartRate
{
    YSHeartRateChangeType changeType = [self getHeartRateChangeTypeWithLastHeartRate:self.lastHeartRate currentHeartRate:heartRate];
    
    if (changeType != YSHeartRateChangeTypeNoChange)
    {
        // 心率区间有改变,重置累积的时间
        [self resetTimestampAccumlateTypeWithHeartRate:heartRate];
    }
    else
    {
        // 根据规则进行相应的提示
        [self promptStrategy];
    }
    
    [self heartRateIntervalChangePromptWithCurrentHeartRate:heartRate changeType:changeType];
    self.lastHeartRate = heartRate;
}

- (void)resetTimestampAccumlateTypeWithHeartRate:(NSInteger)heartRate
{
    // 心率所在区间改变时，重置时间戳
    self.timestampAccumlateType = [self getTimestampAccumulateTypeWithHeartRate:heartRate];
    if (self.timestampAccumlateType == YSTimestampAccumulateTypeJogging)
    {
        self.joggingTimestamp = CFAbsoluteTimeGetCurrent();
    }
    else if (self.timestampAccumlateType == YSTimestampAccumulateTypeEfficientReduceFat)
    {
        self.efficientReduceFatTimestamp = CFAbsoluteTimeGetCurrent();
    }
    else
    {
        self.anaerobicExerciseTimestamp = CFAbsoluteTimeGetCurrent();
    }
}

- (double)getTimestampAccumlateWithType:(YSTimestampAccumulateType)type
{
    if (type == YSTimestampAccumulateTypeJogging)
    {
        return self.joggingTimestamp;
    }
    else if (type == YSTimestampAccumulateTypeEfficientReduceFat)
    {
        return self.efficientReduceFatTimestamp;
    }
    else
    {
        return self.anaerobicExerciseTimestamp;
    }
}

- (YSTimestampAccumulateType)getTimestampAccumulateTypeWithHeartRate:(NSInteger)heartRate
{
    // 根据心率获取需要累积的时间类型
    if (heartRate < YSGraphDataMiddleSectionMin)
    {
        return YSTimestampAccumulateTypeJogging;
    }
    else if (heartRate > YSGraphDataMiddleSectionMax)
    {
        return YSTimestampAccumulateTypeAnaerobicExercise;
    }
    else
    {
        return YSTimestampAccumulateTypeEfficientReduceFat;
    }
}

- (void)heartRateIntervalChangePromptWithCurrentHeartRate:(NSInteger)heartRate changeType:(YSHeartRateChangeType)changeType
{
    // 心率区间变化提示
    switch (changeType) {
        case YSHeartRateChangeTypeIncreaseToEfficientReduceFat:
            [self keepBurningFatPrompt];
            break;
            
        case YSHeartRateChangeTypeReduceToJogging:
            [self speedUpPrompt];
            break;
            
        case YSHeartRateChangeTypeIncreaseToAnaerobicExercise:
            [self anaerobicExerciseSlowdownPrompt];
            break;
            
        case YSHeartRateChangeTypeReduceToEfficientReduceFat:
            [self enterBurningFatHRIntervalPrompt];
            break;
            
        default:
            // 无提示
            break;
    }
}

- (void)promptStrategy
{
    double timestampAccumlate = [self getTimestampAccumlateWithType:self.timestampAccumlateType];
    double totalTime = CFAbsoluteTimeGetCurrent() - timestampAccumlate;
    double min = totalTime / 60;
    
    if (self.timestampAccumlateType == YSTimestampAccumulateTypeAnaerobicExercise)
    {
        // 当用户心率超过160时并且五分钟还没有把心率降下来时，语音提示：“强度过高,请减速”
        if (min >= 5)
        {
            [self strengthTooHighSlowdownPrompt];
            self.anaerobicExerciseTimestamp = CFAbsoluteTimeGetCurrent();
        }
    }
    else if (self.timestampAccumlateType == YSTimestampAccumulateTypeJogging)
    {
        // 当用户跑步十五分钟心率还是很低的时候，语音提示：“强度过低,请加速”
        if (min >= 15)
        {
            [self strengthTooLowSpeedUpPrompt];
            self.joggingTimestamp = CFAbsoluteTimeGetCurrent();
        }
    }
}

- (void)setVoicePromptType:(YSVoicePromptType)type
{
    _voicePromptType = type;
}

- (void)setPeripheralsConnectState:(BOOL)state
{
    self.isConnectPeripherals = state;
}

- (YSHeartRateChangeType)getHeartRateChangeTypeWithLastHeartRate:(NSInteger)lastHeartRate currentHeartRate:(NSInteger)currentHeartRate
{
    // 通过当前心率和上一次心率来判断心率变化类型
    YSHeartRateIntervalType lastIntervalType = [self getIntervalTypeWithHeartRate:lastHeartRate];
    YSHeartRateIntervalType curentIntervalType = [self getIntervalTypeWithHeartRate:currentHeartRate];
    
    if (lastIntervalType == curentIntervalType)
    {
        // 心率在同一区间没有变化
        return YSHeartRateChangeTypeNoChange;
    }
    
    YSHeartRateChangeType type;
    if (lastHeartRate < currentHeartRate)
    {
        // 心率提高
        if (curentIntervalType == YSHeartRateIntervalTypeEfficientReduceFat)
        {
            type = YSHeartRateChangeTypeIncreaseToEfficientReduceFat;
        }
        else
        {
            type = YSHeartRateChangeTypeIncreaseToAnaerobicExercise;
        }
    }
    else
    {
        // 心率降低
        if (curentIntervalType == YSHeartRateIntervalTypeEfficientReduceFat)
        {
            type = YSHeartRateChangeTypeReduceToEfficientReduceFat;
        }
        else
        {
            type = YSHeartRateChangeTypeReduceToJogging;
        }
    }
    
    return type;
}

- (YSHeartRateIntervalType)getIntervalTypeWithHeartRate:(NSInteger)heartRate
{
    // 心率所在区间
    if (heartRate < YSGraphDataMiddleSectionMin)
    {
        return YSHeartRateIntervalTypeJogging;
    }
    else if (heartRate > YSGraphDataMiddleSectionMax)
    {
        return YSHeartRateIntervalTypeAnaerobicExercise;
    }
    else
    {
        return YSHeartRateIntervalTypeEfficientReduceFat;
    }
}

#pragma mark - Voice prompt

- (void)voicePromptWithAudioFilePath:(NSString *)audioFilePath
{
    if (audioFilePath)
    {
        NSURL *url = [NSURL fileURLWithPath:audioFilePath];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
    }
}

- (void)perKilometerPromptWithDistance:(CGFloat)distance
{
    // 每公里提示
    NSString *audioFilePath = [self perKilometerPromptFilePathWithDistance:distance];
    [self voicePromptWithAudioFilePath:audioFilePath];
    
    YSLog(@"每公里提示");
}

- (void)enterBurningFatHRIntervalPrompt
{
    // 进入高效燃脂区间提示
    NSString *audioFilePath = [self enterBurningFatHRIntervalPromptFilePath];
    [self voicePromptWithAudioFilePath:audioFilePath];
}

- (void)keepBurningFatPrompt
{
    // 燃脂中，请保持
    NSString *audioFilePath = [self keepBurningFatPromptFilePath];
    [self voicePromptWithAudioFilePath:audioFilePath];
}

- (void)speedUpPrompt
{
    // 请加速
    NSString *audioFilePath = [self speedUpPromptFilePath];
    [self voicePromptWithAudioFilePath:audioFilePath];
}

- (void)strengthTooHighSlowdownPrompt
{
    // 运动强度太高，请减速
    NSString *audioFilePath = [self strengthTooHighSlowdownPromptFilePath];
    [self voicePromptWithAudioFilePath:audioFilePath];
}

- (void)strengthTooLowSpeedUpPrompt
{
    // 运动强度太低，请加速
    NSString *audioFilePath = [self strengthTooLowSpeedUpPromptFilePath];
    [self voicePromptWithAudioFilePath:audioFilePath];
}

- (void)anaerobicExerciseSlowdownPrompt
{
    // 无氧运动中，请减速
    NSString *audioFilePath = [self anaerobicExerciseSlowdownPromptFilePath];
    [self voicePromptWithAudioFilePath:audioFilePath];
}

- (void)enterAnaerobicPrompt
{
    // 进入无氧运动
    NSString *audioFilePath = [self enterAnaerobicPromptFilePath];
    [self voicePromptWithAudioFilePath:audioFilePath];
}

- (void)enterBurningFatPrompt
{
    // 进入高效减脂
    NSString *audioFilePath = [self enterBurningFatPromptFilePath];
    [self voicePromptWithAudioFilePath:audioFilePath];
}

#pragma mark - Audio file name

- (NSString *)versionFileNamePrefix
{
    // 默认为男声
    NSString *prefix = @"man_";
    if (self.voicePromptType == YSVoicePromptTypeGirl)
    {
        prefix = @"girl_";
    }
    
    return prefix;
}

- (NSString *)perKilometerPromptFilePathWithDistance:(CGFloat)distance
{
    // 每公里语音提示的音频文件名
    
    NSInteger km = (NSInteger)distance;
    if (km < 1 || km > kMaxKilometerPrompt)
    {
        return nil;
    }
    
    NSString *name = [NSString stringWithFormat:@"%@km", @(km)];
    return [self filePathWithName:name];
}

- (NSString *)enterBurningFatHRIntervalPromptFilePath
{
    NSString *name = @"enter_burning_fat";
    return [self filePathWithName:name];
}

- (NSString *)keepBurningFatPromptFilePath
{
    NSString *name = @"keep_burning_fat";
    return [self filePathWithName:name];
}

- (NSString *)speedUpPromptFilePath
{
    NSString *name = @"speed_up_prompt";
    return [self filePathWithName:name];
}

- (NSString *)strengthTooHighSlowdownPromptFilePath
{
    NSString *name = @"strength_too_high_slowdown_prompt";
    return [self filePathWithName:name];
}

- (NSString *)strengthTooLowSpeedUpPromptFilePath
{
    NSString *name = @"strength_too_low_speed_up_prompt";
    return [self filePathWithName:name];
}

- (NSString *)anaerobicExerciseSlowdownPromptFilePath
{
    NSString *name = @"anaerobic_slowdown_prompt";
    return [self filePathWithName:name];
}

- (NSString *)enterAnaerobicPromptFilePath
{
    NSString *name = @"enter_anaerobic";
    return [self filePathWithName:name];
}

- (NSString *)enterBurningFatPromptFilePath
{
    NSString *name = @"enter_burning_fat";
    return [self filePathWithName:name];
}

- (NSString *)filePathWithName:(NSString *)name
{
    NSString *prefix = [self versionFileNamePrefix];
    NSString *fileName = [NSString stringWithFormat:@"%@%@", prefix, name];
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"mp3"];
    
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"Audio.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    NSString *filePath = [bundle pathForResource:fileName ofType:@"mp3"];
    
    return filePath;
}

@end
