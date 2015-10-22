//
//  YSTipLabelHUD.h
//  YSRun
//
//  Created by moshuqi on 15/10/22.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSTipLabelHUD : NSObject 

+ (instancetype)shareTipLabelHUD;
- (void)showTipWithText:(NSString *)text;

@end
