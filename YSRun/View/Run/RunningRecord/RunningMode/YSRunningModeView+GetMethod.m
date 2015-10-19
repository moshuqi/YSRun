//
//  YSRunningModeView+GetMethod.m
//  YSRun
//
//  Created by moshuqi on 15/10/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSRunningModeView+GetMethod.h"

@implementation YSRunningModeView (GetMethod)

- (CGRect)getModeStatusViewFrame
{
    // 子类重载
    return CGRectZero;
}

- (CGRect)getTimeLabelFrame
{
    // 子类重载
    return CGRectZero;
}

- (CGRect)getDistanceLabelFrame
{
    // 子类重载
    return CGRectZero;
}

- (CGRect)getSpeedLabelFrame
{
    // 子类重载
    return CGRectZero;
}

- (CGRect)getFinishButtonAppearFrame
{
    CGFloat distance = 106;  // 与底边的间距
    CGFloat d = 40;    // 与边缘的间距
    CGSize buttonSize = [self getButtonSize];
    
    CGFloat originY = CGRectGetHeight(self.frame) - distance - buttonSize.height;
    CGRect frame = CGRectMake(d, originY, buttonSize.width, buttonSize.height);
    return frame;
}

- (CGRect)getFinishButtonDisappearFrame
{
    CGRect appearFrame = [self getFinishButtonAppearFrame];
    CGFloat d = 30;
    CGFloat originY = CGRectGetHeight(self.frame) + d + [self getButtonSize].height;
    
    CGRect frame = CGRectMake(appearFrame.origin.x, originY, appearFrame.size.width, appearFrame.size.height);
    return frame;
}

- (CGRect)getContinueButtonAppearFrame
{
    CGFloat distance = 106;  // 与底边的间距
    CGFloat d = 40;    // 与边缘的间距
    CGSize buttonSize = [self getButtonSize];
    
    CGFloat originX = CGRectGetWidth(self.frame) - buttonSize.width - d;
    CGFloat originY = CGRectGetHeight(self.frame) - distance - buttonSize.height;
    
    CGRect frame = CGRectMake(originX, originY, buttonSize.width, buttonSize.height);
    return frame;
}

- (CGRect)getContinueButtonDisappearFrame
{
    CGRect appearFrame = [self getContinueButtonAppearFrame];
    CGFloat d = 30;
    CGFloat originY = CGRectGetHeight(self.frame) + d + [self getButtonSize].height;
    
    CGRect frame = CGRectMake(appearFrame.origin.x, originY, appearFrame.size.width, appearFrame.size.height);
    return frame;
}

- (CGSize)getButtonSize
{
    // 按钮的宽度
    CGSize size = self.continueButton.frame.size;
    return size;
}

- (CGRect)getPulldownViewFrame
{
    CGFloat width = CGRectGetWidth(self.pulldownView.frame);
    CGFloat height = CGRectGetHeight(self.pulldownView.frame);
    
    CGFloat originY = [self getContinueButtonAppearFrame].origin.y;
    CGFloat originX = (CGRectGetWidth(self.frame) - width) / 2;
    
    CGRect frame = CGRectMake(originX, originY, width, height);
    return frame;
}

- (CGRect)getPulldownViewDisappearFrame
{
    CGRect appearFrame = [self getPulldownViewFrame];
    CGFloat d = 30;
    CGFloat originY = CGRectGetHeight(self.frame) + d + [self getPulldownViewFrame].size.height;
    
    CGRect frame = CGRectMake(appearFrame.origin.x, originY, appearFrame.size.width, appearFrame.size.height);
    return frame;
}

- (CGPoint)pulldownViewOriginPoint
{
    CGRect frame = [self getPulldownViewFrame];
    CGPoint point = CGPointMake(frame.origin.x + frame.size.width / 2,
                                frame.origin.y + frame.size.height / 2);
    
    return point;
}

- (CGFloat)getPulldownViewOriginDistanceFromEdge
{
    // pulldownView初始位置中心距离父视图（屏幕）下边缘的距离
    CGFloat height = CGRectGetHeight(self.bounds);
    CGPoint originPoint = [self pulldownViewOriginPoint];
    
    CGFloat distance = height - originPoint.y;
    return distance;
}

- (CGFloat)getContinueButtonChangeDistance
{
    // 继续按钮显示位置和隐藏位置之间的距离
    CGRect appearFrame = [self getContinueButtonAppearFrame];
    CGRect disappearFrame = [self getContinueButtonDisappearFrame];
    
    CGFloat distance = disappearFrame.origin.y - appearFrame.origin.y;
    return distance;
}

- (CGFloat)getFinishButtonChangeDistance
{
    // 完成按钮显示位置和隐藏位置之间的距离
    CGRect appearFrame = [self getFinishButtonAppearFrame];
    CGRect disappearFrame = [self getFinishButtonDisappearFrame];
    
    CGFloat distance = disappearFrame.origin.y - appearFrame.origin.y;
    return distance;
}



@end
