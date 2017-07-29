//
//  YSContentHelpView.m
//  YSRun
//
//  Created by moshuqi on 15/11/24.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSContentHelpView.h"
#import "YSHelpDetailComponent.h"
#import "YSStatisticsDefine.h"
#import "YSAppMacro.h"

@interface YSContentHelpView ()

@property (nonatomic, weak) IBOutlet YSHelpDetailComponent *detailComponet1;
@property (nonatomic, weak) IBOutlet YSHelpDetailComponent *detailComponet2;
@property (nonatomic, weak) IBOutlet YSHelpDetailComponent *detailComponet3;

@end

@implementation YSContentHelpView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.backgroundColor = RGB(245, 245, 245);
    }
    
    return self;
}

- (void)setupComponents
{
    NSString *detailStr1 = @"代表心率不能达到快速减脂效果，需要加快运动";
    [self.detailComponet1 setDetailWithText:detailStr1 color:JoggingColor];
    
    NSString *detailStr2 = @"代表心率已到达快速减脂效果";
    [self.detailComponet2 setDetailWithText:detailStr2 color:EfficientReduceFatColor];
    
    NSString *detailStr3 = @"代表心率过快，导致无氧呼吸，不能有效减脂";
    [self.detailComponet3 setDetailWithText:detailStr3 color:AnaerobicExerciseColor];
}

- (void)setColor:(UIColor *)color
{
    // 设置背景颜色
    self.backgroundColor = color;
}

@end
