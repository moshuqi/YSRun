//
//  YSRunViewController.m
//  YSRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSRunViewController.h"
#import "YSAppMacro.h"
#import "YSRunningRecordViewController.h"

@interface YSRunViewController ()

@property (nonatomic, weak) IBOutlet UIButton *startRunningButton;
@property (nonatomic, weak) IBOutlet UIView *methodTipView;

@property (nonatomic, weak) IBOutlet UILabel *tipLabel1;
@property (nonatomic, weak) IBOutlet UILabel *tipLabel2;
@property (nonatomic, weak) IBOutlet UILabel *tipTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *greenLabel;

@end

@implementation YSRunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.startRunningButton.backgroundColor = GreenBackgroundColor;
    self.view.backgroundColor = LightgrayBackgroundColor;
    self.methodTipView.backgroundColor = RGB(231, 231, 231);
    
    [self setupTipLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTipLabel
{
    UIColor *textColor = RGB(79, 79, 79);
    
    self.tipLabel1.text = @" 1.请保持40分钟以上的运动时间";
    self.tipLabel1.textColor = textColor;
    
    self.tipLabel2.text = @" 2.不要跑太快，时速6公里左右";
    self.tipLabel2.textColor = textColor;
    
    self.tipTitleLabel.text = @"跑步减肥方法 ";
    self.tipTitleLabel.textColor = textColor;
    
    self.greenLabel.text = @"基于MAF180训练法>";
    self.greenLabel.textColor = GreenBackgroundColor;
}

- (IBAction)startRunning:(id)sender
{
    YSRunningRecordViewController *runningRecordViewController = [YSRunningRecordViewController new];
    [self presentViewController:runningRecordViewController animated:YES completion:nil];
}

@end
