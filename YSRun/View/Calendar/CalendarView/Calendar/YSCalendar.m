//
//  YSCalendar.m
//  YSRun
//
//  Created by moshuqi on 15/11/2.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSCalendar.h"
#import "YSCalendarDayItem.h"
#import "NSDate+YSDateLogic.h"
#import "YSDayItemModel.h"
#import "YSDatabaseManager.h"
#import "YSUtilsMacro.h"
#import "YSAppMacro.h"

@interface YSCalendar () <UIScrollViewDelegate, YSCalendarDayItemDelegate>

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) NSDate *displayDate;  // 当前所显示月份里的日期

// 保存数据的数组
@property (nonatomic, copy) NSArray *currentMonthDataArray;
@property (nonatomic, copy) NSArray *nextMonthDataArray;
@property (nonatomic, copy) NSArray *lastMonthDataArray;

// 用来包含每个月YSCalendarDayItem的父视图
@property (nonatomic, strong) UIView *currentMonthDaysView;
@property (nonatomic, strong) UIView *nextMonthDaysView;
@property (nonatomic, strong) UIView *lastMonthDaysView;

// dayItem数组
@property (nonatomic, strong) NSArray *currentMonthDayItemArray;
@property (nonatomic, strong) NSArray *nextMonthDayItemArray;
@property (nonatomic, strong) NSArray *lastMonthDayItemArray;

@property (nonatomic, strong) YSDatabaseManager *databaseManager;
@property (nonatomic, assign) BOOL bSlideToLastMonth;
@property (nonatomic, assign) BOOL bNeedSlide;

@property (nonatomic, strong) NSDate *selectedDate;     // 选中的日期，默认选中为当天

@end

@implementation YSCalendar

static const NSInteger kColunm = 7;
static const NSInteger kRow = 6;
static const CGFloat kDuration = 0.6;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setup];
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.currentDate = [NSDate date];
    self.selectedDate = [NSDate date];
    self.databaseManager = [YSDatabaseManager new];
    
    [self initDataArray];
    [self initDaysView];
    [self initDayItemArray];
    [self daysViewAddItems];
    
    self.backgroundColor = LightgrayBackgroundColor;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self resetSubviewFrame];
}

- (void)initDataArray
{
    self.displayDate = self.currentDate;
    
    self.currentMonthDataArray = [self getDataArrayWithDate:self.currentDate];
    self.lastMonthDataArray = [self getDataArrayWithDate:[self getLastMonthDateWithDate:self.currentDate]];
    self.nextMonthDataArray = [self getDataArrayWithDate:[self getNextMonthDateWithDate:self.currentDate]];
}

- (void)initDaysView
{
    self.contentScrollView = [UIScrollView new];
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
    self.contentScrollView.bounces = NO;
    [self addSubview:self.contentScrollView];
    
    self.currentMonthDaysView = [UIView new];
    [self.contentScrollView addSubview:self.currentMonthDaysView];
    
    self.nextMonthDaysView = [UIView new];
    [self.contentScrollView addSubview:self.nextMonthDaysView];
    
    self.lastMonthDaysView = [UIView new];
    [self.contentScrollView addSubview:self.lastMonthDaysView];
}

- (void)initDayItemArray
{
    self.currentMonthDayItemArray = [self getDayItemArray];
    self.nextMonthDayItemArray = [self getDayItemArray];
    self.lastMonthDayItemArray = [self getDayItemArray];
    
    [self setupDayItemArray:self.currentMonthDayItemArray withDataArray:self.currentMonthDataArray];
    [self setupDayItemArray:self.nextMonthDayItemArray withDataArray:self.nextMonthDataArray];
    [self setupDayItemArray:self.lastMonthDayItemArray withDataArray:self.lastMonthDataArray];
}

- (void)daysViewAddItems
{
    [self daysView:self.currentMonthDaysView addDayItems:self.currentMonthDayItemArray];
    [self daysView:self.nextMonthDaysView addDayItems:self.nextMonthDayItemArray];
    [self daysView:self.lastMonthDaysView addDayItems:self.lastMonthDayItemArray];
}

- (void)resetSubviewFrame
{
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CGRect contentScrollViewFrame = CGRectMake(0, 0, width, height);
    self.contentScrollView.frame = contentScrollViewFrame;
    
    [self resetDaysViewFrame];
    
    [self resetDayItemsFrame:self.currentMonthDayItemArray];
    [self resetDayItemsFrame:self.nextMonthDayItemArray];
    [self resetDayItemsFrame:self.lastMonthDayItemArray];
    
    self.contentScrollView.contentSize = CGSizeMake(width * 3, height);
    self.contentScrollView.contentOffset = CGPointMake(width, 0);
}

- (void)resetDaysViewFrame
{
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CGRect lastMonthDaysViewFrame = CGRectMake(0, 0, width, height);
    self.lastMonthDaysView.frame = lastMonthDaysViewFrame;
    
    CGRect currentMonthDaysViewFrame = CGRectMake(width, 0, width, height);
    self.currentMonthDaysView.frame = currentMonthDaysViewFrame;
    
    CGRect nextMonthDaysViewFrame = CGRectMake(width * 2, 0, width, height);
    self.nextMonthDaysView.frame = nextMonthDaysViewFrame;
}

- (void)resetDayItemsFrame:(NSArray *)dayItems
{
    CGFloat itemHorizontalSpacing = 0;  // 水平间距
    CGFloat itemVerticalSpacing = 1;    // 垂直间距
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CGFloat itemWidth = (width - (kColunm - 1) * itemHorizontalSpacing) / kColunm;
    CGFloat itemHeight = (height - (kRow - 1) * itemVerticalSpacing) / kRow;
    
    for (NSInteger i = 0; i < [dayItems count]; i++)
    {
        CGFloat originX = (i % kColunm) * itemWidth;
        CGFloat originY = (i / kColunm) * itemHeight + (i / kColunm) * itemVerticalSpacing;
        
        CGRect frame = CGRectMake(originX, originY, itemWidth, itemHeight);
        YSCalendarDayItem *dayItem = dayItems[i];
        dayItem.frame = frame;
    }
}

- (void)daysView:(UIView *)daysView addDayItems:(NSArray *)dayItems
{
    // 检验参数
    NSInteger dayItemCount = kRow * kColunm;
    if (daysView == nil || ([dayItems count] != dayItemCount))
    {
        YSLog(@"daysView为空，或dayItems数组个数不正确");
        return;
    }
    
    for (NSInteger i = 0; i < dayItemCount; i++)
    {
        [daysView addSubview:dayItems[i]];
    }
}

- (NSArray *)getDayItemArray
{
    // 初始化每个dayItem添加到数组中
    NSMutableArray *dayItemArray = [NSMutableArray array];
    NSInteger dayItemCount = kRow * kColunm;
    
    for (NSInteger i = 0; i < dayItemCount; i++)
    {
        YSCalendarDayItem *dayItem = [YSCalendarDayItem new];
        dayItem.delegate = self;
        [dayItemArray addObject:dayItem];
    }
    
    return dayItemArray;
}

- (void)setupDayItemArray:(NSArray *)dayItemArray withDataArray:(NSArray *)dataArray
{
    // 检验参数
    NSInteger dayItemCount = kRow * kColunm;
    if (([dayItemArray count] != [dataArray count]) || ([dayItemArray count] != dayItemCount))
    {
        YSLog(@"dayItemArray、dataArray数组个数不正确");
        return;
    }
    
    // 设置对应dayItem的值
    for (NSInteger i = 0; i < dayItemCount; i++)
    {
        YSCalendarDayItem *dayItem = dayItemArray[i];
        YSDayItemModel *model = dataArray[i];
        
        [dayItem setupWithDayItemModel:model];
    }
}

- (NSDate *)getLastMonthDateWithDate:(NSDate *)date
{
    // 获取上个月的一天
    NSDate *firstDay = [date firstDayOfCurrentMonth];
    return [firstDay beforeDays:1];
}

- (NSDate *)getNextMonthDateWithDate:(NSDate *)date
{
    // 获取下个月的一天
    NSDate *lastDay = [date lastDayOfCurrentMonth];
    return [lastDay afterDays:1];
}


- (NSArray *)getDataArrayWithDate:(NSDate *)date
{
    // 通过日期获取日期所在月份的显示数据
    NSDate *firstDay = [date firstDayOfCurrentMonth];
    NSDate *lastDay = [date lastDayOfCurrentMonth];
    
    NSInteger firstWeekday = [firstDay weekdayValue];   // 第一天是星期几
    NSInteger lastWeekday = [lastDay weekdayValue];     // 最后一天是星期几
    
    NSInteger numberOfDaysInLastMonth = firstWeekday - 1;   // 上个月需要显示几天
    NSInteger numberOfDaysInNextMonth = 7 - lastWeekday;    // 下个月需要显示几天
    NSInteger numberOfDaysInMonth = [date numberOfDaysInCurrentMonth];  // 当前月一共有几天
    
    // 月份最多需要6行显示，为了统一均用6行，只有5行的月份再尾部再加上7天。
    NSInteger total = numberOfDaysInLastMonth + numberOfDaysInNextMonth + numberOfDaysInMonth;
    numberOfDaysInNextMonth += (kRow * kColunm - total);
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    // 上个月显示的cell
    for (NSInteger i = 0; i < numberOfDaysInLastMonth; i++)
    {
        NSDate *date = [firstDay beforeDays:(numberOfDaysInLastMonth - i)];
        YSDayItemModel *model = [self getDayItemModelWithDate:date isCurrentMonth:NO];
        [dataArray addObject:model];
    }
    
    // 当前月显示的cell
    for (NSInteger i = 0; i < numberOfDaysInMonth; i++)
    {
        NSDate *date = [firstDay afterDays:i];
        YSDayItemModel *model = [self getDayItemModelWithDate:date isCurrentMonth:YES];
        [dataArray addObject:model];
    }
    
    // 下个月显示的cell
    for (NSInteger i = 0 ; i < numberOfDaysInNextMonth; i++)
    {
        NSDate *date = [lastDay afterDays:i + 1];
        YSDayItemModel *model = [self getDayItemModelWithDate:date isCurrentMonth:NO];
        [dataArray addObject:model];
    }
    
    // 标记当天日期，颜色与其他的不一样
    if ([self compareDate1:date date2:self.currentDate])
    {
        NSInteger day = [self.currentDate dayValue];
        for (NSInteger i = numberOfDaysInLastMonth; i < numberOfDaysInLastMonth + numberOfDaysInMonth; i++)
        {
            YSDayItemModel *model = dataArray[i];
            if (day == model.day)
            {
                model.isCurrentDate = YES;
                break;
            }
        }
    }
    
    // 是否为选中日期
    if ([self compareDate1:date date2:self.selectedDate])
    {
        // 暂时只考虑当前月分的选中
        NSInteger day = [self.selectedDate dayValue];
        NSInteger selectedIndex = numberOfDaysInLastMonth + day - 1;
        
        YSDayItemModel *model = dataArray[selectedIndex];
        model.selected = YES;
    }
    
    return dataArray;
}

- (BOOL)compareDate1:(NSDate *)date1 date2:(NSDate *)date2
{
    // 只对年月进行对比
    if (([date1 yearValue] == [date2 yearValue]) &&
        ([date1 monthValue] == [date2 monthValue]))
    {
        return YES;
    }
    
    return NO;
}

- (YSDayItemModel *)getDayItemModelWithDate:(NSDate *)date isCurrentMonth:(BOOL)isCurrentMonth
{
    YSDayItemModel *model = [YSDayItemModel new];
    
    // 判断当天是否有跑步记录
    NSInteger starRating = [self.databaseManager getRunStarRatingWithDate:date];
    if (starRating >= 0)
    {
        model.hasRunRecord = YES;
        model.starRating = starRating;
    }
    else
    {
        model.hasRunRecord = NO;
    }
    
    model.day = [date dayValue];
    model.isCurrentMonth = isCurrentMonth;
    
    // 统一设为NO，其他地方会再判断赋值。
    model.isCurrentDate = NO;
    model.selected = NO;
    
    return model;
}

- (void)slideToLastMonth
{
    self.bSlideToLastMonth = YES;
    
    [UIView animateWithDuration:kDuration animations:^(){
        [self.contentScrollView setContentOffset:CGPointMake(0, 0)];
    }completion:^(BOOL finished){
        if (finished)
        {
            [self calendarSlideFinish];
        }
    }];
    
}

- (void)slideToNextMonth
{
    self.bSlideToLastMonth = NO;
    
    [UIView animateWithDuration:kDuration animations:^(){
        [self.contentScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.contentScrollView.frame) * 2, 0)];
    }completion:^(BOOL finished){
        if (finished)
        {
            [self calendarSlideFinish];
        }
    }];
}

- (void)calendarSlideFinish
{
    // 日期切换滑动完成，重置视图和相关数据
    
    if (self.bSlideToLastMonth)
    {
        // 滑到上一个月
        self.nextMonthDataArray = self.currentMonthDataArray;
        self.currentMonthDataArray = self.lastMonthDataArray;
        
        self.displayDate = [self getLastMonthDateWithDate:self.displayDate];        // 滑动后当前展示月份的日期。
        NSDate *lastMonthDate = [self getLastMonthDateWithDate:self.displayDate];   // 上个月的日期
        self.lastMonthDataArray = [self getDataArrayWithDate:lastMonthDate];
    }
    else
    {
        // 滑到下一个月
        self.lastMonthDataArray = self.currentMonthDataArray;
        self.currentMonthDataArray = self.nextMonthDataArray;
        
        self.displayDate = [self getNextMonthDateWithDate:self.displayDate];        // 滑动后当前展示月份的日期。
        NSDate *nextMonthDate = [self getNextMonthDateWithDate:self.displayDate];   // 下个月的日期
        self.nextMonthDataArray = [self getDataArrayWithDate:nextMonthDate];
    }
    
    [self setupDayItemArray:self.currentMonthDayItemArray withDataArray:self.currentMonthDataArray];
    [self setupDayItemArray:self.nextMonthDayItemArray withDataArray:self.nextMonthDataArray];
    [self setupDayItemArray:self.lastMonthDayItemArray withDataArray:self.lastMonthDataArray];
    
    [self resetDaysViewFrame];
    self.contentScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.contentScrollView.frame), 0);
    
    if ([self.delegate respondsToSelector:@selector(calendarSlideFinishWithDisplayDate:)])
    {
        [self.delegate calendarSlideFinishWithDisplayDate:self.displayDate];
    }
}

- (void)resetCalanderWithDate:(NSDate *)date
{
    // 切换回日历界面时调用这个函数
    self.displayDate = date;
    self.selectedDate = date;
    self.currentMonthDataArray = [self getDataArrayWithDate:self.displayDate];
    
    NSDate *lastMonthDate = [self getLastMonthDateWithDate:self.displayDate];   // 上个月的日期
    self.lastMonthDataArray = [self getDataArrayWithDate:lastMonthDate];
    
    NSDate *nextMonthDate = [self getNextMonthDateWithDate:self.displayDate];   // 上个月的日期
    self.nextMonthDataArray = [self getDataArrayWithDate:nextMonthDate];
    
    [self setupDayItemArray:self.currentMonthDayItemArray withDataArray:self.currentMonthDataArray];
    [self setupDayItemArray:self.nextMonthDayItemArray withDataArray:self.nextMonthDataArray];
    [self setupDayItemArray:self.lastMonthDayItemArray withDataArray:self.lastMonthDataArray];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    // 标记滑动的方向
    if (velocity.x > 0)
    {
        self.bSlideToLastMonth = NO;
    }
    else
    {
        self.bSlideToLastMonth = YES;
    }
    
//    YSLog(@"targetContentOffset x = %@, y = %@, velocity = %@", @((*targetContentOffset).x), @((*targetContentOffset).y), @(velocity.x));
    
    CGFloat width = CGRectGetWidth(scrollView.frame);
    CGFloat distance = width / 2;   // 滑动之后若预期结果大于这个距离，则页面滑动
    if (self.bSlideToLastMonth)
    {
        if ((*targetContentOffset).x < distance)
        {
            (*targetContentOffset).x = 0;
            self.bNeedSlide = YES;
        }
        else
        {
            (*targetContentOffset).x = width;
            self.bNeedSlide = NO;
        }
    }
    else
    {
        if (((*targetContentOffset).x - width) > distance)
        {
            (*targetContentOffset).x = width * 2;
            self.bNeedSlide = YES;
        }
        else
        {
            (*targetContentOffset).x = width;
            self.bNeedSlide = NO;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.bNeedSlide)
    {
        [self calendarSlideFinish];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 日历滑动切换结束后重置offset值
}

#pragma mark - YSCalendarDayItemDelegate

- (void)touchDayItemWithDay:(NSInteger)day
{
    NSInteger year = [self.displayDate yearValue];
    NSInteger month = [self.displayDate monthValue];
    
    // 点击的日期
    NSDate *date = [NSDate dateFromYear:year month:month day:day];
    
    // 设为选中的日期，直接全刷新一遍，后期考虑优化。
    self.selectedDate = date;
    [self resetCalanderWithDate:self.selectedDate];
    
    [self.delegate calendarDidSelectedDate:date];
}


@end
