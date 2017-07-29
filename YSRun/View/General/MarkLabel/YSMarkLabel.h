//
//  YSMarkLabel.h
//  YSRun
//
//  Created by moshuqi on 15/11/24.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSMarkLabel : UIView

- (void)setContentText:(NSString *)text;
- (void)setMarkText:(NSString *)text;

- (void)setContentFontSize:(CGFloat)size;
- (void)setMarkFontSize:(CGFloat)size;
- (void)setContentBoldWithFontSize:(CGFloat)fontSize;

- (void)setContentTextColor:(UIColor *)color;
- (void)setMarkTextColor:(UIColor *)color;
- (void)setTextColor:(UIColor *)color;

- (void)setContentAttributedText:(NSAttributedString *)attributedText;

@end
