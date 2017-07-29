//
//  YSDetailLabelView.h
//  YSRun
//
//  Created by moshuqi on 16/1/25.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSDetailLabelView : UIView

- (void)setLeftContentText:(NSString *)text;
- (void)setLeftScriptText:(NSString *)text;
- (void)setRightContentText:(NSString *)text;
- (void)setRightScriptText:(NSString *)text;

- (void)setLeftHidden:(BOOL)hidden;
- (void)setRightHidden:(BOOL)hidden;

@end
