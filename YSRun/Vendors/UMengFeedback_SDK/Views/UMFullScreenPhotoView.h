//
//  UMFullScreenPhotoViewController.h
//  UMFeedback
//
//  Created by umeng on 4/1/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UMFullScreenPhotoView : UIView

@property (assign, nonatomic) UIInterfaceOrientation orientation;

- (void)addImage:(UIImage *)image forRect:(CGRect)rect dismissCallBack:(void(^)(void) ) callBack;

- (void)resetViewFrame;

@end
