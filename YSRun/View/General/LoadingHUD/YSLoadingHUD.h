//
//  YSLoadingHUD.h
//  YSRun
//
//  Created by moshuqi on 15/12/14.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSLoadingHUD : NSObject

+ (instancetype)shareLoadingHUD;
- (void)show;
- (void)dismiss;

@end
