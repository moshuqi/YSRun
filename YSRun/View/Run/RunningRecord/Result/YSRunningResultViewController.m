//
//  YSRunningResultViewController.m
//  YSRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSRunningResultViewController.h"
#import "YSResultRecordView.h"
#import "YSAppMacro.h"
#import "YSMapManager.h"

@interface YSRunningResultViewController ()

@property (nonatomic, weak) IBOutlet YSResultRecordView *resultRecordView;
@property (nonatomic, weak) IBOutlet UIButton *returnButton;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;
@property (nonatomic, weak) IBOutlet UIView *mapContentView;

@property (nonatomic, strong) YSMapManager *mapManager;

@end

@implementation YSRunningResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupButtons];
    
    self.mapManager = [YSMapManager new];
    [self.mapContentView addSubview:self.mapManager.mapView];
    [self.mapContentView sendSubviewToBack:self.mapManager.mapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.mapManager.mapView.frame = self.mapContentView.bounds;
}

- (void)setupButtons
{
    self.returnButton.backgroundColor = GreenBackgroundColor;
    self.shareButton.backgroundColor = GreenBackgroundColor;
}

- (IBAction)returnButtonClicked:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareButtonClicked:(id)sender
{
    
}

@end
