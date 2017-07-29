//
//  YSResultTipView.h
//  YSRun
//
//  Created by moshuqi on 16/2/23.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSResultTipViewDelegate <NSObject>

@optional
- (void)showHelpFromPoint:(CGPoint)point;

@end

@interface YSResultTipView : UIView

@property (nonatomic, weak) id<YSResultTipViewDelegate> delegate;

- (void)showTipWithRating:(NSInteger)rating;

@end
