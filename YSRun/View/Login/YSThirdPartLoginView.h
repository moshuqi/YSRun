//
//  YSThirdPartLoginView.h
//  YSRun
//
//  Created by moshuqi on 16/1/5.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSThirdPartLoginResponseModel;

@protocol YSThirdPartLoginViewDelegate <NSObject>

- (void)thirdPartLoginSuccessWithResponseModel:(YSThirdPartLoginResponseModel *)respondeModel;
- (void)thirdPartLoginFailureWithMessage:(NSString *)message;

@end

@interface YSThirdPartLoginView : UIView

@property (nonatomic, weak) id<YSThirdPartLoginViewDelegate> delegate;

- (void)setupSubViews;

@end
