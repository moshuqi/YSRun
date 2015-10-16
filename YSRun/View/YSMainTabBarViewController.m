//
//  YSMainTabBarViewController.m
//  YSRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSMainTabBarViewController.h"
#import "YSCalendarViewController.h"
#import "YSRunViewController.h"
#import "YSUserViewController.h"

@interface YSMainTabBarViewController ()

@property (nonatomic, strong) YSCalendarViewController *calendarViewController;
@property (nonatomic, strong) YSRunViewController *runViewController;
@property (nonatomic, strong) YSUserViewController *userViewController;

@end

@implementation YSMainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initViewControllers];
    
    self.selectedIndex = 2; // 进入应用首先显示中间的视图
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initViewControllers
{
    // 初始化视图控制器
    
    [self initCalendarViewController];
    [self initRunViewController];
    [self initUserViewController];
    
    self.viewControllers = @[self.calendarViewController, self.runViewController, self.userViewController];
}

- (void)initCalendarViewController
{
    self.calendarViewController = [[YSCalendarViewController alloc] init];
    
    // 用原图，否则系统会进行渲染
    UIImage *image = [UIImage imageNamed:@"calendar.png"];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.calendarViewController.tabBarItem.image = image;
    
    UIImage *selectedImage = [UIImage imageNamed:@"calendar_highlight.png"];
//    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.calendarViewController.tabBarItem.selectedImage = selectedImage;
    
//    self.calendarViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(10, 5, 0, 5);
}

- (void)initRunViewController
{
    self.runViewController = [[YSRunViewController alloc] init];
    
    UIImage *image = [UIImage imageNamed:@"run.png"];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.runViewController.tabBarItem.image = image;
    
    UIImage *selectedImage = [UIImage imageNamed:@"run_highlight.png"];
//    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.runViewController.tabBarItem.selectedImage = selectedImage;
    
//    self.runViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(15, 10, 5, 10);
}

- (void)initUserViewController
{
    self.userViewController = [[YSUserViewController alloc] init];
    
    UIImage *image = [UIImage imageNamed:@"user.png"];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.userViewController.tabBarItem.image = image;
    
    UIImage *selectedImage = [UIImage imageNamed:@"user_highlight.png"];
//    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.userViewController.tabBarItem.selectedImage = selectedImage;
    
//    self.userViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(10, 5, 0, 5);
}

@end
