//
//  UMFullScreenPhotoViewController.m
//  UMFeedback
//
//  Created by umeng on 4/1/15.
//
//

#import "UMFullScreenPhotoView.h"
#import "UMOpenMacros.h"

@implementation UMFullScreenPhotoView
{
    BOOL _animationFinish;
    CGRect _thumbRect;
    CGRect _originalThumbRect;
    UIImageView *_imageView;
    UIView *_colorView;
    void (^_callBack)(void);
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        _thumbRect = CGRectZero;
        
        [self loadColorView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
        [self addGestureRecognizer:tap];
        
        
    }
    return self;
}

- (void)loadColorView
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if (!_colorView)
    {
        _colorView = [[UIView alloc] initWithFrame:bounds];
        _colorView.backgroundColor = [UIColor blackColor];
        _colorView.alpha = 0.f;
    }
    if (!_colorView.superview)
    {
        [self addSubview:_colorView];
    }
    _colorView.frame = bounds;
}

- (void)resetViewFrame
{
    self.frame = [UIScreen mainScreen].bounds;
    
    [self loadColorView];
    
    [self updateThumbRect];
    
    UIImage *image = _imageView.image;
    if (!image)
    {
        return;
    }
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if (image.size.width <= bounds.size.width && image.size.height <= bounds.size.height)
    {
        _imageView.frame = CGRectMake((bounds.size.width - image.size.width) / 2, (bounds.size.height - image.size.height) / 2, image.size.width, image.size.height);
    }
    else
    {
        CGFloat scaleH = bounds.size.height / _thumbRect.size.height;
        CGFloat scaleW = bounds.size.width / _thumbRect.size.width;
        CGFloat scale = scaleH < scaleW ? scaleH : scaleW;
        CGSize scaledSize = CGSizeMake(_thumbRect.size.width * scale, _thumbRect.size.height * scale);
        CGPoint origin = CGPointZero;
        if (scaledSize.width >= bounds.size.width)
        {
            origin = CGPointMake(0.f, (bounds.size.height - scaledSize.height) / 2);
        }
        else
        {
            origin = CGPointMake((bounds.size.width - scaledSize.width) / 2, 0.f);
        }
        _imageView.frame = CGRectMake(origin.x, origin.y, scaledSize.width, scaledSize.height);
    }
}

- (void)updateThumbRect
{
    if (UM_IOS_8_OR_LATER) {
        _thumbRect = _originalThumbRect;
        return;
    }
    if (_orientation == UIInterfaceOrientationLandscapeLeft
        || _orientation == UIInterfaceOrientationLandscapeRight)
    {
        // 竖屏坐标转换为横屏坐标
        _thumbRect.origin.x = [UIScreen mainScreen].bounds.size.width - _originalThumbRect.origin.y - _originalThumbRect.size.height;
        _thumbRect.origin.y = _originalThumbRect.origin.x;
    }
    else
    {
        _thumbRect.origin = _originalThumbRect.origin;
    }
    _thumbRect.size = _originalThumbRect.size;
}

- (void)addImage:(UIImage *)image forRect:(CGRect)rect dismissCallBack:(void (^)(void))callBack
{
    _originalThumbRect = rect;
    [self updateThumbRect];
    
    _callBack = callBack;
    
    _imageView = [[UIImageView alloc] initWithImage:image];
    _imageView.userInteractionEnabled = NO;
    _imageView.frame = _thumbRect;
    [self addSubview:_imageView];
    
    _animationFinish = NO;
    _imageView.alpha = 0.1;
    [UIView animateWithDuration:0.4f animations:^{
        _colorView.alpha = 1.f;
        [self resetViewFrame];
        _imageView.alpha = 1.f;
    } completion:^(BOOL finished) {
        _animationFinish = YES;
    }];
}

- (void)dismissView
{
    if (!_animationFinish)
        return;
    [UIView animateWithDuration:0.4f
                     animations:^{
                         _imageView.frame = _thumbRect;
                         _colorView.alpha = 0.f;
                         _imageView.alpha = 0.1f;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         _callBack();
                     }];
}

@end
