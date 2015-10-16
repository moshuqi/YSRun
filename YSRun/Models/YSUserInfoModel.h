//
//  YSUserInfoModel.h
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YSUserInfoModel : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, strong) UIImage *userPhoto;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) CGFloat progress;

@end
