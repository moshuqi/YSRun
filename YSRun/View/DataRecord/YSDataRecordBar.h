//
//  YSDataRecordBar.h
//  YSRun
//
//  Created by moshuqi on 15/11/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSDataRecordBarDelegate <NSObject>

@required
- (void)viewBack;

@end

@interface YSDataRecordBar : UIView

@property (nonatomic, weak) id<YSDataRecordBarDelegate> delegate;

- (void)setBarTitle:(NSString *)title;

@end
