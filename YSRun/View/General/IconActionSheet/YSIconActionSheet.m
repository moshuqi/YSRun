//
//  YSIconActionSheet.m
//  YSRun
//
//  Created by moshuqi on 15/12/9.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSIconActionSheet.h"
#import <UIKit/UIKit.h>
#import "YSUtilsMacro.h"

@interface YSIconActionSheet ()

@property (nonatomic, strong) NSArray *dictArray;

@property (nonatomic, strong) UIView *sheet;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *backgroundView;   // 灰色透明背景

@end

const CGFloat kCancelButtonHeight = 40;     // 取消按钮的高度
const CGFloat kMargin = 10;                 // 按钮、sheet与屏幕边缘的间距，按钮与sheet之间的间距
const CGFloat kVerticalMargin = 30;         // item之间，item与sheet边缘的垂直间距

const CGFloat kItemLabelHeight = 20;        // 标签的高度
const NSInteger kEachRowItemCount = 3;     // 每行最多item的个数

const CGFloat kCornerRadius = 10;            // 每个控件的圆角
const NSTimeInterval kAnimationTimeInterval = 0.2;   // 动画时间

const CGFloat kFontSize = 13;

@implementation YSIconActionSheet

- (id)initWithDictArray:(NSArray *)dictArray
{
    self = [super init];
    if (self)
    {
        self.dictArray = dictArray;
    }
    
    return self;
}

- (void)showIconActionSheet
{
    if (![self.backgroundView superview]) {
        [self addBackgroundView];
    }
    
    // 从下往上滑出动画显示
    [UIView animateWithDuration:kAnimationTimeInterval animations:^(){
        self.sheet.frame = [self sheetAppearFrame];
        self.cancelButton.frame = [self cancelButtonAppearFrame];
    }completion:^(BOOL finished){
        
    }];
}

- (void)hideIconActionSheet
{
    [UIView animateWithDuration:kAnimationTimeInterval animations:^(){
        self.sheet.frame = [self sheetDisappearFrame];
        self.cancelButton.frame = [self cancelButtonDisappearFrame];
    }completion:^(BOOL finished){
        // 消失动画完成后透明背景图从keywindow移除
        [self.backgroundView removeFromSuperview];
    }];
}

- (void)addBackgroundView
{
    // 将灰色背景添加到keywindow上
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self screenSize].width, [self screenSize].height)];
    self.backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
    self.backgroundView.userInteractionEnabled = YES;
    
    // 背景加上手势，点击背景处时界面收起并消失
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundView:)];
    tap.numberOfTapsRequired = 1;
    [self.backgroundView addGestureRecognizer:tap];
    
    [self addSheetToBackgoroundView];
    [self addCancelButtonToBackroundView];

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.backgroundView];
    [window bringSubviewToFront:self.backgroundView];
}

- (void)tapBackgroundView:(UITapGestureRecognizer *)gesture
{
    [self hideIconActionSheet];
}

- (void)addSheetToBackgoroundView
{
    // 将sheet添加到背景视图上，初始化时sheet在消失的位置
    self.sheet = [[UIView alloc] initWithFrame:[self sheetDisappearFrame]];
    self.sheet.layer.cornerRadius = kCornerRadius;
    self.sheet.backgroundColor = [UIColor whiteColor];
    
    [self.backgroundView addSubview:self.sheet];
    
    [self sheetAddItems];
}

- (void)addCancelButtonToBackroundView
{
    // 将取消按钮添加到背景视图上，初始化时按钮在消失的位置
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cancelButton.frame = [self cancelButtonDisappearFrame];
    self.cancelButton.backgroundColor = [UIColor whiteColor];
    
    self.cancelButton.layer.cornerRadius = kCornerRadius;
    self.cancelButton.clipsToBounds = YES;
    
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(hideIconActionSheet) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backgroundView addSubview:self.cancelButton];
}

- (void)sheetAddItems
{
    // 将图片和标签添加到sheet上
    if ((self.sheet == nil) || CGRectIsEmpty(self.sheet.frame))
    {
        YSLog(@"sheet为空或尺寸为0");
        return;
    }
    
    CGSize iconSize = [self iconSize];
    CGSize sheetSize = [self sheetSize];
    
    // icon间的间距，icon与sheet边缘的间距
    CGFloat distance = (sheetSize.width - iconSize.width * kEachRowItemCount) / (kEachRowItemCount + 1);
    
    for (NSInteger i = 0; i < [self.dictArray count]; i++)
    {
        NSDictionary *dict = self.dictArray[i];
        
        UIImage *icon = [dict valueForKey:YSIconActionSheetItemIconKey];
        NSString *text = [dict valueForKey:YSIconActionSheetItemTextKey];
        id object = [dict valueForKey:YSIconActionSheetItemObjectKey];
        
        NSString *selectorString = [dict valueForKey:YSIconActionSheetItemSelectorStringKey];
        SEL sel = NSSelectorFromString(selectorString);
        
        // 添加包含图片的按钮
        CGFloat buttonOriginX = distance * ((i % kEachRowItemCount) + 1) + iconSize.width * (i % kEachRowItemCount);
        CGFloat buttonOriginY = (i / kEachRowItemCount + 1) * kVerticalMargin + (i / kEachRowItemCount) * iconSize.height;
        
        CGRect buttonFrame = CGRectMake(buttonOriginX, buttonOriginY, iconSize.width, iconSize.height);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = buttonFrame;
        
        [button setImage:icon forState:UIControlStateNormal];
        [self.sheet addSubview:button];
        
        [button addTarget:object action:sel forControlEvents:UIControlEventTouchUpInside];
        
        // 添加标签
        CGFloat labelOriginX = button.frame.origin.x;
        CGFloat labelOriginY = button.frame.origin.y + button.frame.size.height;
        
        CGRect labelFrame = CGRectMake(labelOriginX, labelOriginY, button.frame.size.width, kItemLabelHeight);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        label.textAlignment = NSTextAlignmentCenter;
        
        label.text = text;
        label.adjustsFontSizeToFitWidth = YES;
        label.font = [UIFont systemFontOfSize:kFontSize];
        
        [self.sheet addSubview:label];
    }
}

- (NSInteger)numberOfRows
{
    // 一共需要显示几行
    NSInteger numberOfRows = [self.dictArray count] / kEachRowItemCount;
    if (([self.dictArray count] % kEachRowItemCount) != 0)
    {
        numberOfRows += 1;
    }
    
    return numberOfRows;
}

- (CGRect)cancelButtonAppearFrame
{
    // 取消按钮显示时的frame
    CGRect frame = CGRectMake(kMargin, [self cancelButtonAppearOriginY],
                              [self cancelButtonSize].width, [self cancelButtonSize].height);
    return frame;
}

- (CGRect)cancelButtonDisappearFrame
{
    // 取消按钮消失时的frame
    CGRect frame = CGRectMake(kMargin, [self cancelButtonDisappearOriginY],
                              [self cancelButtonSize].width, [self cancelButtonSize].height);
    return frame;
}

- (CGFloat)cancelButtonAppearOriginY
{
    CGFloat originY = [self sheetAppearOriginY] + [self sheetSize].height + kMargin;
    return originY;
}

- (CGFloat)cancelButtonDisappearOriginY
{
    CGFloat originY = [self sheetDisappearOriginY] + [self sheetSize].height + kMargin;
    return originY;
}

- (CGRect)sheetAppearFrame
{
    // sheet显示时的frame
    return [self sheetFrameWithOriginY:[self sheetAppearOriginY]];
}

- (CGRect)sheetDisappearFrame
{
    // sheet消失时的frame
    return [self sheetFrameWithOriginY:[self sheetDisappearOriginY]];
}

- (CGRect)sheetFrameWithOriginY:(CGFloat)originY
{
    CGRect sheetFrame = CGRectMake(kMargin, originY,
                                   [self sheetSize].width,
                                   [self sheetSize].height);
    return sheetFrame;
}

- (CGFloat)sheetDisappearOriginY
{
    // sheet消失时的坐标Y值
    CGSize screenSize = [self screenSize];
    CGFloat originY = screenSize.height + kMargin;
    
    return originY;
}

- (CGFloat)sheetAppearOriginY
{
    // sheet显示时的坐标Y值
    CGSize screenSize = [self screenSize];
    CGSize sheetSize = [self sheetSize];

    CGFloat originY = screenSize.height - kCancelButtonHeight - 2 * kMargin - sheetSize.height;
    return originY;
}

- (CGSize)sheetSize
{
    // sheet的尺寸
    NSInteger numberOfRows = [self numberOfRows];
    
    CGFloat iconHeight = [self iconSize].height;
    CGFloat sheetHeight = numberOfRows * (iconHeight + kItemLabelHeight) + (numberOfRows + 1) * kVerticalMargin;
    CGFloat sheetWidth = [self screenSize].width - 2 * kMargin;
    
    CGSize sheetSize = CGSizeMake(sheetWidth, sheetHeight);
    return sheetSize;
}

- (CGSize)cancelButtonSize
{
    // 取消按钮的尺寸
    CGFloat width = [self screenSize].width - 2 * kMargin;
    CGSize size = CGSizeMake(width, kCancelButtonHeight);
    
    return size;
}

- (CGSize)iconSize
{
    // 每个图标的尺寸
    return CGSizeMake(56, 56);
}

- (CGSize)screenSize
{
    // 整个屏幕的尺寸
    CGSize size = [UIApplication sharedApplication].keyWindow.bounds.size;
    return size;
}

@end
