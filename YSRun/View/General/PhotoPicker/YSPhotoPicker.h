//
//  YSPhotoPicker.h
//  YSRun
//
//  Created by moshuqi on 15/10/30.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol YSPhotoPickerDelegate <NSObject>

- (void)imagePickerController:(UIImagePickerController *)picker didSelectImage:(UIImage *)image;

@end

@interface YSPhotoPicker : NSObject

@property (nonatomic, weak) id<YSPhotoPickerDelegate> delegate;

- (id)initWithViewController:(UIViewController *)viewController;
- (void)showPickerChoice;

@end
