//
//  YSPulldownView.h
//  YSRun
//
//  Created by moshuqi on 15/10/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YSPulldownType)
{
    YSPulldownTypeGeneralMode = 1,
    YSPulldownTypeMapMode
};

@interface YSPulldownView : UIView

+ (instancetype)defaultPulldownViewWithRadius:(CGFloat)radius;
- (void)setAppearanceWithType:(YSPulldownType)type;

@end
