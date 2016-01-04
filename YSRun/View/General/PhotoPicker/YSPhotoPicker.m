//
//  YSPhotoPicker.m
//  YSRun
//
//  Created by moshuqi on 15/10/30.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSPhotoPicker.h"

@interface YSPhotoPicker () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, assign) BOOL fromCamera;  // 照片来源为拍照

@end

@implementation YSPhotoPicker

- (id)initWithViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self)
    {
        self.currentViewController = viewController;
    }
    
    return self;
}

- (void)showPickerChoice
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil                                                                             message: nil                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    
    //添加Button
    [alertController addAction: [UIAlertAction actionWithTitle: @"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //处理点击拍照
        [self showCamera];
    }]];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"从相册选取" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //处理点击从相册选取
        [self showPhotoLibrary];
    }]];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self.currentViewController presentViewController: alertController animated: YES completion: nil];
}

- (void)showPhotoLibrary
{
    self.fromCamera = NO;
    [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)showCamera
{
    self.fromCamera = YES;
    [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (void)showImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        UIImagePickerController *imagePickerController = [UIImagePickerController new];
        [imagePickerController setSourceType:sourceType];
        
        imagePickerController.allowsEditing = YES;
        imagePickerController.delegate = self;
        
        [self.currentViewController presentViewController:imagePickerController animated:YES completion:nil];
    }
    else
    {
        [self authorityTipWithSourceType:sourceType];
    }
}

- (void)authorityTipWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    // 提示打开相关权限
    
    NSString *source = (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) ? @"相片" : @"相机";
    NSString *title = [NSString stringWithFormat:@"不能访问您的%@", source];
    NSString *message = [NSString stringWithFormat:@"若要访问您的%@，请前往“设置>隐私\n>%@”，然后将“易瘦跑步”开关设定\n为“打开”。", source, source];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate: nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil, Nil];
    [alertView show];
}

- (UIImage *)adjustImage:(UIImage *)image
{
    // 调整图片大小，图片大小限制。
    const NSInteger maxLength = 200;
    
    NSData * imageData = UIImageJPEGRepresentation(image,1);
    NSInteger length = [imageData length] / 1000;
    
    // 图片小于最大限制，直接返回原图，否则将图片进行重绘处理以减小图片的大小
    if (length < maxLength)
    {
        return image;
    }
    
    CGFloat originalWidth = image.size.width;
    CGFloat originalHeight = image.size.height;
    
    CGFloat scale = (CGFloat)maxLength / length;
    CGFloat newWidth = originalWidth * scale;
    CGFloat newHeight = originalHeight * scale;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    
    [image drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CGRect cropRect = [[info valueForKey:@"UIImagePickerControllerCropRect"] CGRectValue];
    CGRect originRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    if (!CGRectEqualToRect(cropRect, originRect))
    {
        // 在真机上，拍照获得的图像需要做旋转处理，否则得到的图片为转了90°的图
        if (self.fromCamera)
        {
            image =[self rotatedImage:image degrees:90.0];
        }
        
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
        image = [UIImage imageWithCGImage:imageRef];
        
        CGImageRelease(imageRef);
    }
    
    // 调整图片大小
    image = [self adjustImage:image];
    
    [self.delegate imagePickerController:picker didSelectImage:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)rotatedImage:(UIImage *)image degrees:(CGFloat)degrees
{
    @autoreleasepool {
        // calculate the size of the rotated view's containing box for our drawing space
        UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.height, image.size.width)];
        CGAffineTransform t = CGAffineTransformMakeRotation(degrees * M_PI / 180);
        rotatedViewBox.transform = t;
        CGSize rotatedSize = rotatedViewBox.frame.size;
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize);
        CGContextRef bitmap = UIGraphicsGetCurrentContext();
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
        
        //   // Rotate the image context
        CGContextRotateCTM(bitmap, degrees * M_PI / 180);
        
        // Now, draw the rotated/scaled image into the context
        CGContextScaleCTM(bitmap, 1.0, -1.0);
        CGContextDrawImage(bitmap, CGRectMake(-image.size.height / 2, -image.size.width / 2, image.size.height, image.size.width), [image CGImage]);
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
    
    
    
}



@end
