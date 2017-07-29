//
//  YSNavigationBarView.h
//  YSRun
//
//  Created by moshuqi on 15/10/17.
//  Copyright © 2015年 msq. All rights reserved.
//

@import UIKit;

@interface YSNavigationBarView : UIView

- (void)setupWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (void)setupWithTitle:(NSString *)title barBackgroundColor:(UIColor *)color target:(id)target action:(SEL)action;

- (void)setRightButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (void)setRightButtonWithImage:(UIImage *)image target:(id)target action:(SEL)action;


@end
