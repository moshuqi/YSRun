//
//  YSHeartRateRecordCommentView.h
//  YSRun
//
//  Created by moshuqi on 15/11/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSHeartRateRecordCommentView : UIView

- (void)setLeftCommentElementColor:(UIColor *)color text:(NSString *)text;
- (void)setCenterCommentElementColor:(UIColor *)color text:(NSString *)text;
- (void)setRightCommentElementColor:(UIColor *)color text:(NSString *)text;
- (void)setFontSize:(CGFloat)fontSize;

@end
