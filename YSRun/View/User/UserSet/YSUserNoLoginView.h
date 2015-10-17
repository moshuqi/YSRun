//
//  YSUserNoLoginView.h
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSUserNoLoginViewDelegate <NSObject>

- (void)login;

@end

@interface YSUserNoLoginView : UIView

@property (nonatomic, assign) id<YSUserNoLoginViewDelegate> delegate;

@end
