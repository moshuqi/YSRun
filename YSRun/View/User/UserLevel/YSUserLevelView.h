//
//  YSUserLevelView.h
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSUserLevelViewDelegate <NSObject>

@required
- (void)headPhotoChange;
- (void)toLogin;
- (BOOL)loginState;

@end

@interface YSUserLevelView : UIView

@property (nonatomic, weak) id<YSUserLevelViewDelegate> delegate;

- (void)setUserName:(NSString *)userName
          headPhoto:(UIImage *)headPhoto
              grade:(NSInteger)grade
       achieveTitle:(NSString *)achieveTitle
           progress:(CGFloat)progress
upgradeRequireTimes:(NSInteger)upgradeRequireTimes;

- (void)setHeadPhoto:(UIImage *)photo;

@end
