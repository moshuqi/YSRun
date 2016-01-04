//
//  YSCalendarDayItem.m
//  YSRun
//
//  Created by moshuqi on 15/11/2.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSCalendarDayItem.h"
#import "YSDayItemModel.h"
#import "YSAppMacro.h"
#import "YSDevice.h"

@interface YSCalendarDayItem ()

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UIView *starContentView;

@property (nonatomic, assign) NSInteger starRating;
@property (nonatomic, strong) YSDayItemModel *dayItemModel;

@property (nonatomic, strong) UIView *selectedBackgroundView;   // 用来作为选中背景的视图

@end

@implementation YSCalendarDayItem

const CGFloat starContentHeight = 15;

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setupDayLabel];
        [self setupStarContentView];
        [self addGesture];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)setupDayLabel
{
    self.dayLabel = [UILabel new];
    [self addSubview:self.dayLabel];
    
    self.dayLabel.textAlignment = NSTextAlignmentCenter;
//    self.dayLabel.adjustsFontSizeToFitWidth = YES;
    self.dayLabel.font = [UIFont systemFontOfSize:9];
    if ([YSDevice isPhone6Plus])
    {
        self.dayLabel.font = [UIFont systemFontOfSize:12];
    }
}

- (void)setupStarContentView
{
    self.starContentView = [UIView new];
    [self addSubview:self.starContentView];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self resetSubviewsFrame];
}

- (void)resetSubviewsFrame
{
    // 重置子视图的frame值
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    // 加上10的偏移，否则选中时的圈会遮住星星
    CGFloat labelHeight = height - 10;
    CGRect labelFrame = CGRectMake(0, 0, width, labelHeight);
    self.dayLabel.frame = labelFrame;
    
    if (self.selectedBackgroundView)
    {
        self.selectedBackgroundView.frame = [self getSelectedBackgroundViewByDayLabel];
        CGFloat cornerRadius = CGRectGetHeight(self.selectedBackgroundView.frame) / 2;
        self.selectedBackgroundView.layer.cornerRadius = cornerRadius;
    }
    
    CGRect starContentViewFrame = CGRectMake(0, height - starContentHeight, width, starContentHeight);
    self.starContentView.frame = starContentViewFrame;
    
    [self setStarContentWithStarRating:self.starRating];
}

- (void)setupWithDayItemModel:(YSDayItemModel *)dayItemModel
{
    self.dayItemModel = dayItemModel;
    self.dayLabel.text = [NSString stringWithFormat:@"%@", @(dayItemModel.day)];
    
//    UIColor *textColor = RGB(198, 198, 198);
//    if (dayItemModel.isCurrentMonth)
//    {
//        if (dayItemModel.isCurrentDate)
//        {
//            textColor = GreenBackgroundColor;
//        }
//        else
//        {
//            textColor = RGB(144, 144, 144);
//        }
//    }
//    self.dayLabel.textColor = textColor;
    
    [self setSelected:dayItemModel.selected];
    
    self.starRating = dayItemModel.starRating;
}


- (void)setStarContentWithStarRating:(NSInteger)starRating
{
    // 移除子视图
    for (UIView *view in [self.starContentView subviews])
    {
        [view removeFromSuperview];
    }
    
    if (starRating < 1)
    {
        return;
    }
    
    CGFloat starIconWidth = 10;
    CGFloat starIconHeight = starIconWidth;
    CGFloat totalWidht = starIconWidth * starRating;
    
    CGFloat originX = (CGRectGetWidth(self.starContentView.bounds) - totalWidht) / 2;
    CGFloat origniY = (CGRectGetHeight(self.starContentView.bounds) - starIconHeight) / 2;
    
    for (NSInteger i = 0; i < starRating; i++)
    {
        CGRect imageViewFrame = CGRectMake(originX + starIconWidth * i, origniY, starIconWidth, starIconHeight);
        UIImageView *starImageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
        
        UIImage *starImage = [UIImage imageNamed:@"small_star.png"];
        starImageView.image = starImage;
        
        [self.starContentView addSubview:starImageView];
    }
}

- (void)setSelected:(BOOL)isSelected
{
    // 设置当前item是否为选中
    
    // 字体颜色
    UIColor *textColor = RGB(144, 144, 144);    // 非当天([NSDate date])字体颜色
    if (self.dayItemModel.isCurrentMonth)
    {
        if (self.dayItemModel.isCurrentDate)
        {
            // 当天item，选中时为绿色背景，字体为白色；不选中时没有背景色，字体为绿色
            if (isSelected)
            {
                textColor = [UIColor whiteColor];
            }
            else
            {
                textColor = GreenBackgroundColor;
            }
        }
    }
    else
    {
        // 非当前月份的颜色置灰
        textColor = RGB(198, 198, 198);
    }
    
    self.dayLabel.textColor = textColor;
    
    [self setupSelectedBackgroundViewWithState:isSelected];
}

- (void)setupSelectedBackgroundViewWithState:(BOOL)isSelected
{
    // 设置选中背景
    if (isSelected)
    {
        if (self.selectedBackgroundView == nil)
        {
            // 第一次使用时初始化
            [self setupSelectedBackgroundView];
        }
        self.selectedBackgroundView.hidden = NO;
        
        if (self.dayItemModel.isCurrentDate)
        {
            self.selectedBackgroundView.backgroundColor = GreenBackgroundColor;
        }
        else
        {
            self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        }
    }
    else
    {
        self.selectedBackgroundView.hidden = YES;
    }
}

- (void)setupSelectedBackgroundView
{
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:[self getSelectedBackgroundViewByDayLabel]];
    [self addSubview:self.selectedBackgroundView];
    [self bringSubviewToFront:self.dayLabel];   // 标签显示在背景视图前面
    
    self.selectedBackgroundView.layer.borderWidth = 1;
    self.selectedBackgroundView.layer.borderColor = GreenBackgroundColor.CGColor;
    
    if (!CGRectIsEmpty(self.selectedBackgroundView.frame))
    {
        CGFloat cornerRadius = CGRectGetHeight(self.selectedBackgroundView.frame) / 2;
        self.selectedBackgroundView.layer.cornerRadius = cornerRadius;
    }
}

- (CGRect)getSelectedBackgroundViewByDayLabel
{
    // 通过dayLabel来获取selecedBackgroundView的frame值
    CGPoint center = self.dayLabel.center;
    CGFloat selectedBgViewHeight = CGRectGetHeight(self.frame) - starContentHeight - 4;
    CGFloat selectedBgViewWidth = selectedBgViewHeight;
    
    CGRect frame = CGRectMake(center.x - selectedBgViewWidth / 2,
                              center.y - selectedBgViewHeight / 2,
                              selectedBgViewWidth, selectedBgViewHeight);
    return frame;
}

- (void)addGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dayItemTouched:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)dayItemTouched:(UITapGestureRecognizer *)tapGesture
{
    if (self.dayItemModel.isCurrentMonth)
    {
        [self.delegate touchDayItemWithDay:self.dayItemModel.day];
    }
}

@end
