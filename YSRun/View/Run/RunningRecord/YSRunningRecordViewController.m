//
//  YSRunningRecordViewController.m
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSRunningRecordViewController.h"
#import "YSRunningGeneralModeView.h"
#import "YSRunningMapModeView.h"

@interface YSRunningRecordViewController ()

@property (nonatomic, strong) YSRunningGeneralModeView *runningGeneralModeView;
@property (nonatomic, strong) YSRunningMapModeView *runningMapModeView;
@property (nonatomic, strong) YSRunningModeView *currentModeView;

@end

@implementation YSRunningRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.runningGeneralModeView = [[YSRunningGeneralModeView alloc] init];
//    [self.view addSubview:self.runningGeneralModeView];
    
    self.runningMapModeView = [[YSRunningMapModeView alloc] init];
    [self.view addSubview:self.runningMapModeView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.runningMapModeView resetLayoutWithFrame:[self getModeViewFrame]];
}

- (CGRect)getModeViewFrame
{
    CGFloat originY = 20;
    CGRect frame = CGRectMake(0, originY, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - originY);
    
    return frame;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
