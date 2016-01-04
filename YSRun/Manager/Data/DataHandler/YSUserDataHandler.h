//
//  YSUserDataHandler.h
//  YSRun
//
//  Created by moshuqi on 15/12/14.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YSUserDataHandlerDelegate <NSObject>

@optional
- (void)uploadHeadImageFinish;

@end

@class UIImage;

@interface YSUserDataHandler : NSObject

@property (nonatomic, weak) id<YSUserDataHandlerDelegate> delegate;

- (void)uploadHeadImage:(UIImage *)headImage;

@end
