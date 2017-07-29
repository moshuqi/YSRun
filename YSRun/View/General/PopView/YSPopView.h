//
//  YSPopView.h
//  YSRun
//
//  Created by moshuqi on 16/2/24.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSPopView : UIView

- (void)showPopViewWithFrame:(CGRect)frame fromView:(UIView *)fromView atPoint:(CGPoint)point;
- (void)addContentView:(UIView *)contentView;
- (void)setColor:(UIColor *)color;
- (void)setArrowHeight:(CGFloat)arrowHeight;

@end
