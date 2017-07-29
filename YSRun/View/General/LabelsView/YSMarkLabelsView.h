//
//  YSMarkLabelsView.h
//  YSRun
//
//  Created by moshuqi on 15/11/25.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSMarkLabelsView : UIView

// left
- (void)setLeftLabelContentText:(NSString *)text;
- (void)setLeftLabelMarkText:(NSString *)text;

- (void)setLeftLabelContentTextColor:(UIColor *)color;
- (void)setLeftLabelMarkTextColor:(UIColor *)color;

- (void)setLeftLabelContentTextFontSize:(CGFloat)fontSize;
- (void)setLeftLabelMarkTextFontSize:(CGFloat)fontSize;

// center
- (void)setCenterLabelContentText:(NSString *)text;
- (void)setCenterLabelMarkText:(NSString *)text;

- (void)setCenterLabelContentTextColor:(UIColor *)color;
- (void)setCenterLabelMarkTextColor:(UIColor *)color;

- (void)setCenterLabelContentTextFontSize:(CGFloat)fontSize;
- (void)setCenterLabelMarkTextFontSize:(CGFloat)fontSize;

// right
- (void)setRightLabelContentText:(NSString *)text;
- (void)setRightLabelMarkText:(NSString *)text;

- (void)setRightLabelContentTextColor:(UIColor *)color;
- (void)setRightLabelMarkTextColor:(UIColor *)color;

- (void)setRightLabelContentTextFontSize:(CGFloat)fontSize;
- (void)setRightLabelMarkTextFontSize:(CGFloat)fontSize;

// 设置为相同字体大小、颜色
- (void)setContentTextFontSize:(CGFloat)fontSize;
- (void)setMarkTextFontSize:(CGFloat)fontsize;
- (void)setContentTextBoldWithFontSize:(CGFloat)fontSize;

- (void)setContentTextColor:(UIColor *)color;
- (void)setMarkTextColor:(UIColor *)color;

// 设置attributedText
- (void)setContentAttributedTextWithLeftStr:(NSAttributedString *)leftStr
                                  centerStr:(NSAttributedString *)centerStr
                                   rightStr:(NSAttributedString *)rightStr;

@end
