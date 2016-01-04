//
//  YSSubscriptLabel.h
//  YSRun
//
//  Created by moshuqi on 15/10/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSSubscriptLabel : UIView

- (void)setContentText:(NSString *)text;
- (void)setSubscriptText:(NSString *)text;

- (void)setContentFontSize:(CGFloat)size;
- (void)setSubscriptFontSize:(CGFloat)size;

- (void)setTextColor:(UIColor *)color;
- (void)setContentBoldWithFontSize:(CGFloat)size;

@end
