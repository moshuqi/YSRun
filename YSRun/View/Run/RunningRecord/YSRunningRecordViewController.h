//
//  YSRunningRecordViewController.h
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSRunningRecordViewControllerDelegate <NSObject>

@required
- (void)runningRecordFinish;

@end

@interface YSRunningRecordViewController : UIViewController

@property (nonatomic, weak) id<YSRunningRecordViewControllerDelegate> delegate;

@end
