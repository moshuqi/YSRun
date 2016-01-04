//
//  YSCicularProgressView.h
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSCicularProgressView : UIView

- (id)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth;

- (void)animationToProgress:(CGFloat)progress;
- (CGPoint)getGapPoint;


@end
